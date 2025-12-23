import 'package:workmanager/workmanager.dart';
import 'dart:io';
import '../database/app_database.dart';
import '../../features/bases/services/base_repository.dart';
import '../../features/characters/services/character_repository.dart';
import './alert_checker_service.dart';
import './notification_service.dart';
import './notification_settings.dart';

/// Background worker service for periodic alert checks
class BackgroundWorkerService {
  static const String taskName = 'alertCheckTask';
  static const String uniqueName = 'duneCompanionAlertCheck';

  /// Initialize and register background tasks
  static Future<void> initialize() async {
    // Only init on mobile platforms
    if (!Platform.isAndroid && !Platform.isIOS) {
      return; // Desktop uses timer-based checks instead
    }

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    // Register periodic task
    await registerPeriodicTask();
  }

  /// Register the periodic alert check task
  static Future<void> registerPeriodicTask() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    final settings = await NotificationSettings.getAllSettings();
    final enabled = settings['enabled'] as bool;
    final intervalMinutes = settings['intervalMinutes'] as int;

    if (!enabled) {
      // Cancel if notifications disabled
      await cancelPeriodicTask();
      return;
    }

    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: Duration(minutes: intervalMinutes),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  /// Cancel the periodic task
  static Future<void> cancelPeriodicTask() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    await Workmanager().cancelByUniqueName(uniqueName);
  }

  /// Update the task when settings change
  static Future<void> updateTask() async {
    await cancelPeriodicTask();
    await registerPeriodicTask();
  }
}

/// Background callback dispatcher (runs in isolate)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize database
      final database = AppDatabase.instance;
      await database.initialize();

      // Initialize services
      final baseRepository = BaseRepository(database);
      final characterRepository = CharacterRepository(database);
      final alertChecker = AlertCheckerService(baseRepository, characterRepository);
      final notificationService = NotificationService.instance;

      // Initialize notification service
      await notificationService.initialize();

      // Get settings
      final includeWarnings = await NotificationSettings.getIncludeWarnings();

      // Check for alerts
      final alerts = await alertChecker.checkForAlerts(
        includeWarnings: includeWarnings,
      );

      // Send notifications (limit to avoid spam)
      int sentCount = 0;
      const maxNotifications = 5;

      for (final alert in alerts) {
        if (sentCount >= maxNotifications) break;

        // Only send critical alerts in background
        if (alert.severity == AlertSeverity.critical) {
          if (alert.type == AlertType.power) {
            await notificationService.showPowerAlert(
              baseId: alert.base.id,
              baseName: alert.base.name,
              characterInfo: alert.characterInfo,
              timeRemaining: alert.timeRemaining,
              isCritical: true,
            );
          } else if (alert.type == AlertType.tax) {
            await notificationService.showTaxAlert(
              baseId: alert.base.id,
              baseName: alert.base.name,
              characterInfo: alert.characterInfo,
              timeRemaining: alert.timeRemaining,
              isOverdue: alert.timeRemaining.isNegative,
            );
          }
          sentCount++;
        }
      }

      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}
