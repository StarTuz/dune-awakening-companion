import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles OS notifications for the Field Timer T=0 page and escalation repeats.
///
/// Uses a dedicated `field_timers` channel with max importance so the page
/// cannot be silenced by quiet-hours settings (controlled by the bypass toggle).
/// Does NOT handle pre-alarm cues — those use [FieldTimerAudioService] directly.
class FieldTimerNotificationService {
  FieldTimerNotificationService();

  static const _channelId = 'field_timers';
  static const _channelName = 'Field Timers';

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

  // ── Internal ──────────────────────────────────────────────────────────

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Urgent harvest-window alerts',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Field Timer',
      playSound: true,
      enableVibration: true,
      fullScreenIntent: Platform.isAndroid,
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

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      macOS: iosDetails,
      windows: windowsDetails,
    );

    try {
      await _plugin.show(id, title, body, details, payload: 'field_timer');
      debugPrint('[FieldTimerNotification] Showed notification id=$id');
    } catch (e) {
      debugPrint('[FieldTimerNotification] Error: $e');
    }
  }
}
