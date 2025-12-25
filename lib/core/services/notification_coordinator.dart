import '../services/notification_service.dart';
import '../services/notification_settings.dart';
import '../services/alert_checker_service.dart';
import 'dart:async';

/// Coordinates alert checking and notification triggering
class NotificationCoordinator {
  final NotificationService _notificationService;
  final AlertCheckerService _alertCheckerService;
  
  Timer? _periodicTimer;
  bool _isRunning = false;

  NotificationCoordinator(
    this._notificationService,
    this._alertCheckerService,
  );

  /// Start periodic alert checking
  void startPeriodicChecks({
    Duration interval = const Duration(minutes: 30),
    bool includeWarnings = false,
  }) {
    if (_isRunning) return;

    _isRunning = true;

    // Run immediate check
    checkAndNotify(includeWarnings: includeWarnings);

    // Schedule periodic checks
    _periodicTimer = Timer.periodic(interval, (_) {
      checkAndNotify(includeWarnings: includeWarnings);
    });
  }

  /// Stop periodic checking
  void stopPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _isRunning = false;
  }

  /// Perform a single check and send notifications
  Future<void> checkAndNotify({bool includeWarnings = false}) async {
    print('[NotificationCoordinator] Starting alert check...');
    
    // Check if we're in quiet hours
    final inQuietHours = await NotificationSettings.isInQuietHours();
    if (inQuietHours) {
      print('[NotificationCoordinator] Currently in quiet hours - skipping notifications');
      return;
    }
    
    final alerts = await _alertCheckerService.checkForAlerts(
      includeWarnings: includeWarnings,
    );

    print('[NotificationCoordinator] Found ${alerts.length} alerts');

    // Group alerts by base to avoid spam
    final Map<String, List<BaseAlert>> alertsByBase = {};
    for (final alert in alerts) {
      alertsByBase.putIfAbsent(alert.base.id, () => []).add(alert);
    }

    print('[NotificationCoordinator] Grouped into ${alertsByBase.length} bases');

    // Send notifications (limit to avoid spam)
    int notificationCount = 0;
    const maxNotifications = 5; // Don't overwhelm user

    for (final baseAlerts in alertsByBase.values) {
      if (notificationCount >= maxNotifications) break;

      // Send notification for most critical alert for this base
      final criticalAlerts = baseAlerts
          .where((a) => a.severity == AlertSeverity.critical)
          .toList();
      
      final alertToSend = criticalAlerts.isNotEmpty 
          ? criticalAlerts.first 
          : baseAlerts.first;

      print('[NotificationCoordinator] Sending notification for ${alertToSend.base.name}');
      await _sendNotificationForAlert(alertToSend);
      notificationCount++;
    }

    print('[NotificationCoordinator] Sent $notificationCount notifications');
  }

  /// Send notification for a specific alert
  Future<void> _sendNotificationForAlert(BaseAlert alert) async {
    if (alert.type == AlertType.power) {
      await _notificationService.showPowerAlert(
        baseId: alert.base.id,
        baseName: alert.base.name,
        characterInfo: alert.characterInfo,
        timeRemaining: alert.timeRemaining,
        isCritical: alert.severity == AlertSeverity.critical,
      );
    } else if (alert.type == AlertType.tax) {
      await _notificationService.showTaxAlert(
        baseId: alert.base.id,
        baseName: alert.base.name,
        characterInfo: alert.characterInfo,
        timeRemaining: alert.timeRemaining,
        isOverdue: alert.timeRemaining.isNegative,
      );
    }
  }

  /// Get current alert count
  Future<int> getAlertCount() async {
    return await _alertCheckerService.getCriticalAlertCount();
  }

  /// Dispose resources
  void dispose() {
    stopPeriodicChecks();
  }
}
