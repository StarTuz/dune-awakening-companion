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
import 'core/providers/theme_provider.dart';
import 'core/providers/accessibility_provider.dart';
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
    final themeMode = ref.watch(themeModeProvider);
    final faction = ref.watch(factionThemeProvider);
    final accessibility = ref.watch(accessibilityProvider);
    
    // Get base themes based on selected faction
    var darkTheme = AppTheme.getDarkThemeForFaction(faction);
    var lightTheme = AppTheme.getLightThemeForFaction(faction);
    
    // Apply accessibility modifications
    darkTheme = _applyAccessibility(darkTheme, accessibility);
    lightTheme = _applyAccessibility(lightTheme, accessibility);
    
    return MaterialApp(
      title: 'Dune Awakening Companion',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      navigatorKey: navigatorKey, // For notification navigation
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // Apply text scale factor and reduced motion
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accessibility.textScaleFactor),
            disableAnimations: accessibility.reducedMotion,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainNavigationScreen(),
    );
  }

  /// Apply accessibility settings to a theme
  ThemeData _applyAccessibility(ThemeData theme, AccessibilitySettings settings) {
    var modifiedTheme = theme;
    
    // Apply font weight to text theme
    if (settings.fontWeight != FontWeightOption.regular) {
      modifiedTheme = modifiedTheme.copyWith(
        textTheme: _applyFontWeight(modifiedTheme.textTheme, settings.fontWeightValue),
      );
    }
    
    // Apply high contrast modifications
    if (settings.highContrast) {
      modifiedTheme = _applyHighContrast(modifiedTheme);
    }
    
    return modifiedTheme;
  }

  /// Apply font weight to all text styles in a TextTheme
  TextTheme _applyFontWeight(TextTheme textTheme, FontWeight weight) {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(fontWeight: weight),
      displayMedium: textTheme.displayMedium?.copyWith(fontWeight: weight),
      displaySmall: textTheme.displaySmall?.copyWith(fontWeight: weight),
      headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: weight),
      headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: weight),
      headlineSmall: textTheme.headlineSmall?.copyWith(fontWeight: weight),
      titleLarge: textTheme.titleLarge?.copyWith(fontWeight: weight),
      titleMedium: textTheme.titleMedium?.copyWith(fontWeight: weight),
      titleSmall: textTheme.titleSmall?.copyWith(fontWeight: weight),
      bodyLarge: textTheme.bodyLarge?.copyWith(fontWeight: weight),
      bodyMedium: textTheme.bodyMedium?.copyWith(fontWeight: weight),
      bodySmall: textTheme.bodySmall?.copyWith(fontWeight: weight),
      labelLarge: textTheme.labelLarge?.copyWith(fontWeight: weight),
      labelMedium: textTheme.labelMedium?.copyWith(fontWeight: weight),
      labelSmall: textTheme.labelSmall?.copyWith(fontWeight: weight),
    );
  }

  /// Apply high contrast modifications to a theme
  ThemeData _applyHighContrast(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    if (isDark) {
      // Dark mode: Increase contrast with brighter text and stronger colors
      return theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: _increaseContrast(theme.colorScheme.primary),
          secondary: _increaseContrast(theme.colorScheme.secondary),
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        textTheme: theme.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.white24,
          thickness: 2,
        ),
        cardTheme: theme.cardTheme.copyWith(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1),
          ),
        ),
      );
    } else {
      // Light mode: Increase contrast with darker text
      return theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          onSurface: Colors.black,
          onBackground: Colors.black,
        ),
        textTheme: theme.textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.black26,
          thickness: 2,
        ),
        cardTheme: theme.cardTheme.copyWith(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.primary, width: 1),
          ),
        ),
      );
    }
  }

  /// Increase the brightness/saturation of a color for high contrast
  Color _increaseContrast(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0))
              .withSaturation((hsl.saturation + 0.1).clamp(0.0, 1.0))
              .toColor();
  }
}
