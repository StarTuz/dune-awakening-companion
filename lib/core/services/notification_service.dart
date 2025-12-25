import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
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
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    print('[NotificationService] Initializing...');
    
    // Linux initialization
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
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
    print('[NotificationService] Plugin initialized');

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
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
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
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigate to specific screen based on payload
    print('Notification tapped: ${response.payload}');
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

  /// Show a tax alert notification
  Future<void> showTaxAlert({
    required String baseId,
    required String baseName,
    required String characterInfo,
    required Duration timeRemaining,
    required bool isOverdue,
  }) async {
    if (!_notificationsEnabled) return;

    final String timeText;
    if (isOverdue) {
      final days = timeRemaining.inDays.abs();
      timeText = days == 1 ? '1 day overdue' : '$days days overdue';
    } else {
      final hours = timeRemaining.inHours;
      timeText = hours < 1
          ? '${timeRemaining.inMinutes} minutes'
          : hours == 1
              ? '1 hour'
              : hours < 24
                  ? '$hours hours'
                  : '${timeRemaining.inDays} days';
    }

    await _showNotification(
      id: baseId.hashCode + 1000, // Offset to avoid ID collision with power alerts
      title: isOverdue ? '💰 Tax Overdue!' : '💰 Tax Payment Due',
      body: '$baseName ($characterInfo) - $timeText',
      payload: 'tax:$baseId',
      channelId: 'critical_alerts',
      importance: Importance.high,
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
      priority: importance == Importance.high ? Priority.high : Priority.defaultPriority,
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

    const linuxDetails = LinuxNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
    );

    try {
      print('[NotificationService] Showing notification: $title (ID: $id, sound: $soundEnabled, vibration: $vibrationEnabled)');
      await _notifications.show(id, title, body, details, payload: payload);
      print('[NotificationService] Notification shown successfully');
    } catch (e, stack) {
      print('[NotificationService] Error showing notification: $e');
      print(stack);
      // Don't rethrow, just log, so the app doesn't crash
    }
  }

  /// Show a simple notification (for non-alert messages)
  Future<void> showSimpleNotification({
    required String title,
    required String message,
  }) async {
    // Always show simple notifications (bypass _notificationsEnabled check)
    final androidDetails = const AndroidNotificationDetails(
      'app_messages',
      'App Messages',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const linuxDetails = LinuxNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
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
