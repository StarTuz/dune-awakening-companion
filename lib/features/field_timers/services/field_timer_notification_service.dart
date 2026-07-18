import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// OS notifications for the Field Timer on platforms where the in-app Dart
/// timer drives the timeline (desktop, iOS). On Android the timeline is
/// owned by FieldTimerOsAlarmService (native alarms + foreground service);
/// this service only provides the exact-alarm permission probes used by the
/// Field Timer screen's warning banner.
class FieldTimerNotificationService {
  FieldTimerNotificationService();

  static const _pageChannelId = 'field_timer_page';
  static const _pageChannelName = 'Field Timer page';

  // Page: 900000, escalation repeats 900001+ (desktop in-app path only).
  static const _baseNotificationId = 900000;
  static const _maxEscalationIds = 20;

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

  /// Whether this platform hands the timer timeline to native alarms.
  bool get supportsOsTimeline => !kIsWeb && Platform.isAndroid;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// Whether exact alarm scheduling is currently permitted. With only
  /// USE_EXACT_ALARM declared this is auto-granted; kept as a probe for the
  /// screen's warning banner.
  Future<bool> canScheduleExactAlarms() async {
    if (!supportsOsTimeline) return false;
    try {
      return await _android?.canScheduleExactNotifications() ?? false;
    } catch (e) {
      debugPrint('[FieldTimerNotification] exact-alarm check failed: $e');
      return false;
    }
  }

  /// Open the system "Alarms & reminders" grant flow.
  Future<bool> requestExactAlarmsPermission() async {
    if (!supportsOsTimeline) return false;
    try {
      return await _android?.requestExactAlarmsPermission() ?? false;
    } catch (e) {
      debugPrint('[FieldTimerNotification] exact-alarm request failed: $e');
      return false;
    }
  }

  /// Fire the T=0 page notification (and each escalation repeat) — used on
  /// platforms where the in-app timer drives the timeline.
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

  /// Cancel every shown field-timer notification (called on ack).
  Future<void> cancelAll() async {
    for (var i = 0; i <= _maxEscalationIds; i++) {
      await _plugin.cancel(_baseNotificationId + i);
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────

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
