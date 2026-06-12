import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Handles OS notifications for the Field Timer T=0 page and escalation repeats.
///
/// Uses a dedicated `field_timers` channel with max importance so the page
/// cannot be silenced by quiet-hours settings (controlled by the bypass toggle).
/// Does NOT handle pre-alarm cues — those use [FieldTimerAudioService] directly.
class FieldTimerNotificationService {
  FieldTimerNotificationService();

  static const _channelId = 'field_timers_alarm';
  static const _channelName = 'Field Timers (Alarm)';

  // Maximum number of escalation alarms pre-scheduled at T=0.
  static const _maxScheduledEscalations = 20;

  // Use a fixed ID range that doesn't overlap with base/quest notification IDs.
  static const _baseNotificationId = 900000;

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

  /// Fire the T=0 page notification (and each escalation repeat).
  Future<void> showTimerFired({
    required String title,
    required String body,
    required int escalationCount,
  }) async {
    final id = _baseNotificationId + escalationCount;
    await _show(id: id, title: title, body: body);
  }

  /// Cancel all field-timer notifications (called on ack).
  Future<void> cancelAll() async {
    // Cancel up to a generous range of escalation IDs.
    for (var i = 0; i < 200; i++) {
      await _plugin.cancel(_baseNotificationId + i);
    }
  }

  /// Pre-schedule [_maxScheduledEscalations] escalation notifications as exact
  /// AlarmManager wakeups so they fire even with the screen off.
  ///
  /// Call at T=0. On ack, [cancelAll] removes any that haven't fired yet.
  Future<void> scheduleEscalations({
    required int intervalSeconds,
    required String title,
    required String body,
  }) async {
    if (!Platform.isAndroid) return;
    final now = tz.TZDateTime.now(tz.local);
    for (var i = 1; i <= _maxScheduledEscalations; i++) {
      final when = now.add(Duration(seconds: intervalSeconds * i));
      final id = _baseNotificationId + i;
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          when,
          _buildDetails(escalationCount: i),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          payload: 'field_timer',
        );
      } catch (e) {
        debugPrint('[FieldTimerNotification] Schedule error id=$id: $e');
      }
    }
    debugPrint(
        '[FieldTimerNotification] Scheduled $_maxScheduledEscalations escalations at ${intervalSeconds}s intervals');
  }

  // ── Internal ──────────────────────────────────────────────────────────

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _plugin.show(id, title, body, _buildDetails(),
          payload: 'field_timer');
      debugPrint('[FieldTimerNotification] Showed notification id=$id');
    } catch (e) {
      debugPrint('[FieldTimerNotification] Error: $e');
    }
  }

  NotificationDetails _buildDetails({int escalationCount = 0}) {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Urgent harvest-window alerts — alarm stream',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Field Timer',
      playSound: true,
      enableVibration: true,
      fullScreenIntent: Platform.isAndroid,
      // Route through the Android alarm audio stream so the alert fires even
      // when the phone is in silent / DND mode with the screen off.
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
