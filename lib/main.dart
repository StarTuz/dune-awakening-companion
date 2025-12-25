import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
import 'core/database/app_database.dart';
import 'core/services/notification_manager.dart';
import 'core/services/notification_service.dart';
import 'core/services/notification_coordinator.dart';
import 'core/services/system_tray_service.dart';
import 'core/services/alert_checker_service.dart';
import 'core/services/notification_settings.dart';
import 'core/providers/notification_settings_provider.dart';
import 'features/bases/services/base_repository.dart';
import 'features/characters/services/character_repository.dart';
import 'shared/theme/app_theme.dart';
import 'core/providers/language_provider.dart';
import 'shared/navigation/main_navigation.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// Global key for navigation (needed for notification taps)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Global ProviderContainer for accessing providers from outside widget tree
// This allows system tray callbacks to update Riverpod state
late final ProviderContainer globalContainer;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enforce single instance on Windows
  // If another instance is already running, this will bring it to front and exit
  if (Platform.isWindows) {
    await WindowsSingleInstance.ensureSingleInstance(
      args,
      "dune_awakening_companion",
      onSecondWindow: (args) {
        // When a second instance tries to open, show the existing window
        windowManager.show();
        windowManager.focus();
      },
    );
  }
  
  // Initialize database
  await AppDatabase.instance.initialize();
  
  // Create global provider container BEFORE system tray init
  globalContainer = ProviderContainer();
  
  // Initialize notification system
  await _initializeNotifications();
  
  // Initialize system tray (desktop platforms)
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await _initializeSystemTray();
    
    // Initialize window manager
    await windowManager.ensureInitialized();
    
    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    
    // Linux has issues with waitUntilReadyToShow due to 'first-frame' signal
    // So we handle it differently per platform
    if (Platform.isLinux) {
      // For Linux, configure window directly without waiting for first-frame
      await windowManager.setSize(windowOptions.size!);
      await windowManager.setMinimumSize(windowOptions.minimumSize!);
      await windowManager.center();
      await windowManager.setPreventClose(true);
      
      final startMinimized = await NotificationSettings.getStartMinimized();
      if (startMinimized) {
        await windowManager.hide();
      } else {
        await windowManager.show();
        await windowManager.focus();
      }
    } else {
      // Windows/macOS: Use the standard approach
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setPreventClose(true);
        
        final startMinimized = await NotificationSettings.getStartMinimized();
        if (startMinimized) {
          await windowManager.hide();
        } else {
          await windowManager.show();
          await windowManager.focus();
        }
      });
    }
  }
  
  runApp(
    UncontrolledProviderScope(
      container: globalContainer,
      child: const DuneAwakeningCompanionApp(),
    ),
  );
}

/// Initialize notification system
Future<void> _initializeNotifications() async {
  final database = AppDatabase.instance;
  final baseRepository = BaseRepository(database);
  final characterRepository = CharacterRepository(database);
  
  final notificationService = NotificationService.instance;
  final alertChecker = AlertCheckerService(baseRepository, characterRepository);
  final coordinator = NotificationCoordinator(notificationService, alertChecker);
  final manager = NotificationManager(notificationService, coordinator);
  
  await manager.initialize();
  
  // Update tray badge with initial alert count (desktop only)
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    final alertCount = await coordinator.getAlertCount();
    await SystemTrayService.instance.updateAlertCount(alertCount);
  }
}

/// Initialize system tray (desktop only)
Future<void> _initializeSystemTray() async {
  final trayService = SystemTrayService.instance;
  
  await trayService.initialize(
    onShowWindow: () async {
      await windowManager.show();
      await windowManager.focus();
    },
    onCheckAlerts: () async {
      // Show window first
      await windowManager.show();
      await windowManager.focus();
      
      // Then navigate to alerts screen using the navigator key
      // Wait a bit for window to be ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Navigate directly - MainNavigationScreen will handle tab switching
      // For now, just show the window and user can click Alerts tab
      // Later we can add proper deep linking
      
      // Trigger immediate alert check
      try {
        final database = AppDatabase.instance;
        final baseRepository = BaseRepository(database);
        final characterRepository = CharacterRepository(database);
        final notificationService = NotificationService.instance;
        final alertChecker = AlertCheckerService(baseRepository, characterRepository);
        final coordinator = NotificationCoordinator(notificationService, alertChecker);
        final manager = NotificationManager(notificationService, coordinator);
        await manager.checkNow();
        
        // Update tray with current alert count
        final alertCount = await coordinator.getAlertCount();
        await trayService.updateAlertCount(alertCount);
      } catch (e) {
        print('[SystemTray] Check alerts error: $e');
      }
    },
    onToggleNotifications: () async {
      // Get current state from the Riverpod provider
      final currentState = globalContainer.read(notificationSettingsProvider);
      final newState = !currentState.enabled;
      
      // Update via the provider notifier (this updates SharedPreferences AND Riverpod state)
      // The Settings UI watches this provider, so it will automatically update!
      await globalContainer.read(notificationSettingsProvider.notifier).setEnabled(newState);
      
      // Update notification manager with new state FIRST
      // This is important because when disabling, the manager cancels all pending notifications
      // We need to do this BEFORE showing our feedback notification
      final notificationService = NotificationService.instance;
      final database = AppDatabase.instance;
      final baseRepository = BaseRepository(database);
      final characterRepository = CharacterRepository(database);
      final alertChecker = AlertCheckerService(baseRepository, characterRepository);
      final coordinator = NotificationCoordinator(notificationService, alertChecker);
      final manager = NotificationManager(notificationService, coordinator);
      
      await manager.updateSettings(enabled: newState);
      
      // Update tray menu with actual alert count
      final alertCount = newState ? await coordinator.getAlertCount() : 0;
      await trayService.updateAlertCount(alertCount);
      
      // NOW show feedback notification AFTER manager updates
      // This ensures it won't be canceled by cancelAllNotifications()
      try {
        await notificationService.showSimpleNotification(
          title: newState ? '🔔 Notifications Enabled' : '🔕 Notifications Disabled',
          message: newState 
              ? 'You will receive alerts for expiring bases'
              : 'Notification alerts have been turned off',
        );
      } catch (e) {
        print('[SystemTray] Feedback notification error: $e');
      }
      
      print('[SystemTray] Notifications toggled: $newState (UI should update automatically!)');
    },
    onQuit: () async {
      await trayService.dispose();
      globalContainer.dispose();
      exit(0);
    },
  );
}

class DuneAwakeningCompanionApp extends ConsumerWidget {
  const DuneAwakeningCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    
    return MaterialApp(
      title: 'Dune Awakening Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.duneTheme,
      navigatorKey: navigatorKey, // For notification navigation
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigationScreen(),
    );
  }
}

