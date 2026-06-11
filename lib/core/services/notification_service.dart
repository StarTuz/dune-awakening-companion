import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_settings.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _notificationsEnabled = true;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Android initialization
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    debugPrint('[NotificationService] Initializing...');

    // Linux initialization
    final linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('assets/app_icon.png'),
    );

    // Windows initialization
    // GUID generated for this app - required by Windows notification system
    const windowsSettings = WindowsInitializationSettings(
      appName: 'Dune Awakening Companion',
      appUserModelId: 'com.example.dune_awakening_companion',
      guid: 'd5e8a7b3-4c2f-4a1e-9d3b-6f8c2e1a5b7d',
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
      macOS: iosSettings,
      windows: windowsSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    debugPrint('[NotificationService] Plugin initialized');

    // Request permissions (iOS/Android)
    if (Platform.isIOS || Platform.isAndroid) {
      await _requestPermissions();
    }

    // Create notification channels (Android)
    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }

    _initialized = true;
  }

  /// Request notification permissions (mobile)
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true; // Desktop doesn't need permission
  }

  /// Create Android notification channels
  Future<void> _createAndroidChannels() async {
    const criticalChannel = AndroidNotificationChannel(
      'critical_alerts',
      'Critical Alerts',
      description: 'Urgent alerts for bases < 24 hours',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    const warningChannel = AndroidNotificationChannel(
      'warning_alerts',
      'Warning Alerts',
      description: 'Warning alerts for bases < 48 hours',
      importance: Importance.defaultImportance,
      playSound: true,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(criticalChannel);
    await androidPlugin?.createNotificationChannel(warningChannel);

    const questChannel = AndroidNotificationChannel(
      'quest_reminders',
      'Quest reminders',
      description: 'Optional quest journal reminders',
      importance: Importance.defaultImportance,
    );
    await androidPlugin?.createNotificationChannel(questChannel);

    const fieldTimerChannel = AndroidNotificationChannel(
      'field_timers',
      'Field Timers',
      description: 'Urgent harvest-window alerts — page until acknowledged',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    await androidPlugin?.createNotificationChannel(fieldTimerChannel);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigate to specific screen based on payload
    debugPrint('Notification tapped: ${response.payload}');
    // Will be implemented when we integrate with navigation
  }

  /// Show a power alert notification
  Future<void> showPowerAlert({
    required String baseId,
    required String baseName,
    required String characterInfo,
    required Duration timeRemaining,
    required bool isCritical,
  }) async {
    if (!_notificationsEnabled) return;

    final hours = timeRemaining.inHours;
    final timeText = hours < 1
        ? '${timeRemaining.inMinutes} minutes'
        : hours == 1
            ? '1 hour'
            : '$hours hours';

    await _showNotification(
      id: baseId.hashCode,
      title: isCritical ? '⚡ Power Critical!' : '⚡ Power Running Low',
      body: '$baseName ($characterInfo) - $timeText remaining',
      payload: 'power:$baseId',
      channelId: isCritical ? 'critical_alerts' : 'warning_alerts',
      importance: isCritical ? Importance.high : Importance.defaultImportance,
    );
  }

  /// Internal method to show notification
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'critical_alerts',
    Importance importance = Importance.high,
  }) async {
    // Load sound and vibration preferences
    final soundEnabled = await NotificationSettings.getSoundEnabled();
    final vibrationEnabled = await NotificationSettings.getVibrationEnabled();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'critical_alerts' ? 'Critical Alerts' : 'Warning Alerts',
      channelDescription: 'Base alerts',
      importance: importance,
      priority: importance == Importance.high
          ? Priority.high
          : Priority.defaultPriority,
      ticker: 'Base Alert',
      playSound: soundEnabled,
      enableVibration: vibrationEnabled,
      // Use silent mode if sound is disabled
      silent: !soundEnabled && !vibrationEnabled,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: soundEnabled,
    );

    final linuxDetails = LinuxNotificationDetails(
      sound: soundEnabled ? ThemeLinuxSound('message-new-instant') : null,
      suppressSound: !soundEnabled,
      urgency: importance == Importance.high
          ? LinuxNotificationUrgency.critical
          : LinuxNotificationUrgency.normal,
    );

    const windowsDetails = WindowsNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    try {
      debugPrint(
        '[NotificationService] Showing notification: $title '
        '(ID: $id, sound: $soundEnabled, vibration: $vibrationEnabled)',
      );
      await _notifications.show(id, title, body, details, payload: payload);
      debugPrint('[NotificationService] Notification shown successfully');
    } catch (e, stack) {
      debugPrint('[NotificationService] Error showing notification: $e');
      debugPrint(stack.toString());
      // Don't rethrow, just log, so the app doesn't crash
    }
  }

  /// Show a simple notification (for non-alert messages)
  Future<void> showSimpleNotification({
    required String title,
    required String message,
  }) async {
    // Always show simple notifications (bypass _notificationsEnabled check)
    final soundEnabled = await NotificationSettings.getSoundEnabled();

    const androidDetails = AndroidNotificationDetails(
      'app_messages',
      'App Messages',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: soundEnabled,
    );

    final linuxDetails = LinuxNotificationDetails(
      sound: soundEnabled ? ThemeLinuxSound('message-new-instant') : null,
      suppressSound: !soundEnabled,
    );

    const windowsDetails = WindowsNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    // Use timestamp for unique ID so notifications don't replace each other
    final uniqueId = DateTime.now().millisecondsSinceEpoch % 100000;

    await _notifications.show(
      uniqueId,
      title,
      message,
      details,
    );
  }

  /// Schedule a one-shot quest reminder (Android / iOS only).
  Future<void> scheduleQuestReminder({
    required int id,
    required String questTitle,
    required DateTime scheduledTime,
  }) async {
    if (!_notificationsEnabled) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;

    final soundEnabled = await NotificationSettings.getSoundEnabled();
    final vibrationEnabled = await NotificationSettings.getVibrationEnabled();

    final androidDetails = AndroidNotificationDetails(
      'quest_reminders',
      'Quest reminders',
      channelDescription: 'Optional quest journal reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: soundEnabled,
      enableVibration: vibrationEnabled,
      silent: !soundEnabled && !vibrationEnabled,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: soundEnabled,
    );

    const linuxDetails = LinuxNotificationDetails();

    const windowsDetails = WindowsNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    final when = tz.TZDateTime.from(scheduledTime, tz.local);
    if (!when.isAfter(tz.TZDateTime.now(tz.local))) return;

    try {
      await _notifications.zonedSchedule(
        id,
        'Quest reminder',
        questTitle,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'quest',
      );
      debugPrint(
          '[NotificationService] Scheduled quest reminder id=$id at $when');
    } catch (e, stack) {
      debugPrint('[NotificationService] Quest schedule error: $e');
      debugPrint(stack.toString());
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Enable/disable notifications
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    if (!enabled) {
      cancelAllNotifications();
    }
  }

  /// Check if notifications are enabled
  bool get notificationsEnabled => _notificationsEnabled;
}
