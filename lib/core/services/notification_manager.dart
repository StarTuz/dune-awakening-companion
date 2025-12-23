import 'dart:io';
import './notification_service.dart';
import './notification_coordinator.dart';
import './notification_settings.dart';
import './background_worker_service.dart';

/// Initializes all notification-related services
class NotificationManager {
  final NotificationService _notificationService;
  final NotificationCoordinator _coordinator;

  NotificationManager(
    this._notificationService,
    this._coordinator,
  );

  /// Initialize all notification services
  Future<void> initialize() async {
    // 1. Initialize notification service
    await _notificationService.initialize();

    // 2. Load settings
    final settings = await NotificationSettings.getAllSettings();
    final enabled = settings['enabled'] as bool;
    final intervalMinutes = settings['intervalMinutes'] as int;
    final includeWarnings = settings['includeWarnings'] as bool;

    // 3. Apply settings to notification service
    _notificationService.setNotificationsEnabled(enabled);

    if (!enabled) {
      return; // Don't start if disabled
    }

    // 4. Platform-specific initialization
    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile: Use WorkManager for background checks
      await BackgroundWorkerService.initialize();
      await BackgroundWorkerService.registerPeriodicTask();
    } else {
      // Desktop: Use timer-based periodic checks
      _coordinator.startPeriodicChecks(
        interval: Duration(minutes: intervalMinutes),
        includeWarnings: includeWarnings,
      );
    }
  }

  /// Update settings and restart checks
  Future<void> updateSettings({
    bool? enabled,
    int? intervalMinutes,
    bool? includeWarnings,
  }) async {
    print('[NotificationManager] Updating settings: enabled=$enabled, interval=$intervalMinutes, warnings=$includeWarnings');
    
    // Save new settings
    if (enabled != null) {
      await NotificationSettings.setNotificationsEnabled(enabled);
      _notificationService.setNotificationsEnabled(enabled);
      print('[NotificationManager] Notification service enabled state set to: $enabled');
    }
    if (intervalMinutes != null) {
      await NotificationSettings.setCheckInterval(intervalMinutes);
    }
    if (includeWarnings != null) {
      await NotificationSettings.setIncludeWarnings(includeWarnings);
    }

    // Restart with new settings
    await restart();
  }

  /// Restart notification checks with current settings
  Future<void> restart() async {
    final settings = await NotificationSettings.getAllSettings();
    final enabled = settings['enabled'] as bool;
    final intervalMinutes = settings['intervalMinutes'] as int;
    final includeWarnings = settings['includeWarnings'] as bool;

    // Stop current checks
    if (Platform.isAndroid || Platform.isIOS) {
      await BackgroundWorkerService.cancelPeriodicTask();
    } else {
      _coordinator.stopPeriodicChecks();
    }

    // Don't restart if disabled
    if (!enabled) {
      return;
    }

    // Restart with new settings
    if (Platform.isAndroid || Platform.isIOS) {
      await BackgroundWorkerService.registerPeriodicTask();
    } else {
      _coordinator.startPeriodicChecks(
        interval: Duration(minutes: intervalMinutes),
        includeWarnings: includeWarnings,
      );
    }
  }

  /// Manually trigger an immediate check
  Future<void> checkNow() async {
    final includeWarnings = await NotificationSettings.getIncludeWarnings();
    await _coordinator.checkAndNotify(includeWarnings: includeWarnings);
  }

  /// Stop all notification checks
  Future<void> stop() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await BackgroundWorkerService.cancelPeriodicTask();
    } else {
      _coordinator.stopPeriodicChecks();
    }
  }

  /// Clean up resources
  void dispose() {
    _coordinator.dispose();
  }
}
