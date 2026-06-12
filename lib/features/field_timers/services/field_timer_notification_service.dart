import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/field_timer_preset.dart';

/// Handles OS notifications for the Field Timer.
///
/// On Android the **entire timeline is pre-scheduled at arm time** via
/// [scheduleTimeline]: every pre-alarm cue, the T=0 page, and all escalation
/// repeats become exact `AlarmManager.setAlarmClock()` wakeups. The cue audio
/// is baked into per-stage notification channels (alarm stream, raw-resource
/// sounds), so the OS plays the sound itself — nothing depends on the Dart
/// isolate being alive. Screen off, Doze, app swiped away: the alarms still
/// fire. This is the PagerDuty model.
///
/// On other platforms the in-app Dart timer + FieldTimerAudioService handle
/// audio (desktops don't suspend the way phones do) and this service only
/// shows the immediate T=0 / escalation notifications.
class FieldTimerNotificationService {
  FieldTimerNotificationService();

  static const _pageChannelId = 'field_timer_page';
  static const _pageChannelName = 'Field Timer page';

  // Maximum number of escalation alarms pre-scheduled at arm time.
  static const _maxScheduledEscalations = 20;

  // Use fixed ID ranges that don't overlap with base/quest notification IDs.
  // Page: 900000. Escalations: 900001-900020. Cues: 900101-900110.
  static const _baseNotificationId = 900000;
  static const _cueNotificationIdBase = 900100;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final linux = LinuxInitializationSettings(
      defaultActionName: 'Open',
      defaultIcon: AssetsLinuxIcon('assets/app_icon.png'),
    );
    const ios = DarwinInitializationSettings();
    const windows = WindowsInitializationSettings(
      appName: 'Dune Awakening Companion',
      appUserModelId: 'com.example.dune_awakening_companion',
      guid: 'd5e8a7b3-4c2f-4a1e-9d3b-6f8c2e1a5b7d',
    );

    await _plugin.initialize(
      InitializationSettings(
        android: android,
        iOS: ios,
        linux: linux,
        macOS: ios,
        windows: windows,
      ),
    );
    _initialized = true;
  }

  /// Whether this platform can hand the timer timeline to the OS (Android).
  bool get supportsOsTimeline => !kIsWeb && Platform.isAndroid;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// Whether exact alarm-clock scheduling is currently permitted.
  ///
  /// Android 12/13 deny SCHEDULE_EXACT_ALARM by default — the user must
  /// enable "Alarms & reminders" in system settings. Android 14+ auto-grants
  /// via USE_EXACT_ALARM. Without it, alarmClock scheduling throws.
  Future<bool> canScheduleExactAlarms() async {
    if (!supportsOsTimeline) return false;
    try {
      return await _android?.canScheduleExactNotifications() ?? false;
    } catch (e) {
      debugPrint('[FieldTimerNotification] exact-alarm check failed: $e');
      return false;
    }
  }

  /// Open the system "Alarms & reminders" grant flow (Android 12/13).
  Future<bool> requestExactAlarmsPermission() async {
    if (!supportsOsTimeline) return false;
    try {
      return await _android?.requestExactAlarmsPermission() ?? false;
    } catch (e) {
      debugPrint('[FieldTimerNotification] exact-alarm request failed: $e');
      return false;
    }
  }

  /// Pre-schedule the full timer timeline as exact alarm-clock wakeups:
  /// each unfired cue at its offset, the page at T=0, and
  /// [_maxScheduledEscalations] escalation repeats after it.
  ///
  /// Returns true only if exact alarms are permitted and every entry was
  /// scheduled — the caller must keep in-app audio alive otherwise. When
  /// exact alarms are denied, entries are still scheduled inexactly as a
  /// best-effort backstop (may be delayed by Doze), but this returns false.
  Future<bool> scheduleTimeline({
    required Duration totalDuration,
    required List<FieldTimerCue> cues,
    required int escalationIntervalSeconds,
    required String cueTitle,
    required String cueBody,
    required String pageTitle,
    required String pageBody,
  }) async {
    if (!supportsOsTimeline) return false;

    final exact = await canScheduleExactAlarms();
    final mode = exact
        ? AndroidScheduleMode.alarmClock
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final now = tz.TZDateTime.now(tz.local);
    final firesAt = now.add(totalDuration);
    var failures = 0;

    // Pre-alarm cues, each on its own stage channel (stage sound baked in).
    var cueIndex = 0;
    for (final cue in cues) {
      cueIndex++;
      final when = firesAt.subtract(cue.offsetFromEnd);
      if (!when.isAfter(now)) continue;
      if (!await _schedule(
        id: _cueNotificationIdBase + cueIndex,
        title: cueTitle,
        body: cueBody,
        when: when,
        details: _cueDetails(cue.stage),
        mode: mode,
      )) {
        failures++;
      }
    }

    // T=0 page.
    if (!await _schedule(
      id: _baseNotificationId,
      title: pageTitle,
      body: pageBody,
      when: firesAt,
      details: _pageDetails(),
      mode: mode,
    )) {
      failures++;
    }

    // Escalation repeats.
    for (var i = 1; i <= _maxScheduledEscalations; i++) {
      if (!await _schedule(
        id: _baseNotificationId + i,
        title: pageTitle,
        body: pageBody,
        when: firesAt.add(Duration(seconds: escalationIntervalSeconds * i)),
        details: _pageDetails(),
        mode: mode,
      )) {
        failures++;
      }
    }

    final armed = exact && failures == 0;
    debugPrint(
        '[FieldTimerNotification] Timeline scheduled: ${cues.length} cues, '
        'page at $firesAt, exact=$exact, failures=$failures, armed=$armed');
    return armed;
  }

  /// Fire the T=0 page notification (and each escalation repeat).
  /// Used on platforms where the in-app timer drives the timeline.
  Future<void> showTimerFired({
    required String title,
    required String body,
    required int escalationCount,
  }) async {
    final id = _baseNotificationId + escalationCount;
    try {
      await _plugin.show(id, title, body, _pageDetails(),
          payload: 'field_timer');
      debugPrint('[FieldTimerNotification] Showed notification id=$id');
    } catch (e) {
      debugPrint('[FieldTimerNotification] Error: $e');
    }
  }

  /// Cancel every shown and pending field-timer notification (called on ack
  /// and on arm, so a re-armed timer starts from a clean slate).
  Future<void> cancelAll() async {
    for (var i = 0; i <= _maxScheduledEscalations; i++) {
      await _plugin.cancel(_baseNotificationId + i);
    }
    for (var i = 1; i <= 10; i++) {
      await _plugin.cancel(_cueNotificationIdBase + i);
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────

  Future<bool> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    required NotificationDetails details,
    required AndroidScheduleMode mode,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: mode,
        payload: 'field_timer',
      );
      return true;
    } catch (e) {
      debugPrint('[FieldTimerNotification] Schedule error id=$id: $e');
      return false;
    }
  }

  NotificationDetails _cueDetails(int stage) {
    final effectiveStage = stage.clamp(1, 4);
    final androidDetails = AndroidNotificationDetails(
      'field_timer_cue_$effectiveStage',
      'Field Timer cue $effectiveStage',
      channelDescription:
          'Pre-alarm cue stage $effectiveStage before the harvest window closes',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Field Timer cue',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('cue_stage_$effectiveStage'),
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    return NotificationDetails(android: androidDetails);
  }

  NotificationDetails _pageDetails() {
    final androidDetails = AndroidNotificationDetails(
      _pageChannelId,
      _pageChannelName,
      channelDescription:
          'Harvest window closed — pages until acknowledged, fires when screen off',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Field Timer',
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('cue_page'),
      enableVibration: true,
      fullScreenIntent: Platform.isAndroid,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    final linuxDetails = LinuxNotificationDetails(
      sound: ThemeLinuxSound('message-new-instant'),
      urgency: LinuxNotificationUrgency.critical,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const windowsDetails = WindowsNotificationDetails();

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      macOS: iosDetails,
      windows: windowsDetails,
    );
  }
}
