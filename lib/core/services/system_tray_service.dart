import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

/// Manages system tray icon and menu (desktop only)
class SystemTrayService with TrayListener, WindowListener {
  static final SystemTrayService instance = SystemTrayService._internal();
  factory SystemTrayService() => instance;
  SystemTrayService._internal();

  bool _initialized = false;
  int _alertCount = 0;
  Function()? _onShowWindow;
  Function()? _onCheckAlerts;
  Function()? _onToggleNotifications;
  Function()? _onQuit;

  /// Initialize system tray (desktop only)
  Future<void> initialize({
    required Function() onShowWindow,
    required Function() onCheckAlerts,
    required Function() onToggleNotifications,
    required Function() onQuit,
  }) async {
    // Only init on desktop platforms
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) {
      return;
    }

    if (_initialized) return;

    _onShowWindow = onShowWindow;
    _onCheckAlerts = onCheckAlerts;
    _onToggleNotifications = onToggleNotifications;
    _onQuit = onQuit;

    try {
      // Copy icon to temp directory for tray_manager (Linux needs absolute path)
      final iconPath = await _prepareIcon();
      
      // Initialize tray manager with absolute path
      await trayManager.setIcon(iconPath);
      print('[SystemTray] Icon set to: $iconPath');
    } catch (e) {
      print('[SystemTray] Error setting icon: $e');
    }

    // Set up context menu
    await _updateMenu();

    // Add listeners
    trayManager.addListener(this);
    windowManager.addListener(this);

    _initialized = true;
  }

  /// Prepare icon by copying to a temp location with absolute path
  Future<String> _prepareIcon() async {
    final tempDir = await getTemporaryDirectory();
    
    if (Platform.isWindows) {
      // Windows REQUIRES .ico format for system tray
      // The .ico file is bundled with the Windows build
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final icoPath = path.join(exeDir, 'data', 'flutter_assets', 'assets', 'app_icon.ico');
      
      // Check if custom ICO exists in assets, otherwise fall back to Windows runner icon
      if (await File(icoPath).exists()) {
        print('[SystemTray] Using ICO from assets: $icoPath');
        return icoPath;
      }
      
      // Fall back to the runner resources icon
      final fallbackIco = path.join(exeDir, 'app_icon.ico');
      if (await File(fallbackIco).exists()) {
        print('[SystemTray] Using fallback ICO: $fallbackIco');
        return fallbackIco;
      }
      
      // Create a minimal ICO from embedded data if nothing else works
      print('[SystemTray] Warning: No ICO file found, tray icon may not appear');
      return icoPath; // Return path anyway, will fail gracefully
    } else {
      // Linux/macOS: Load PNG from assets
      final byteData = await rootBundle.load('assets/app_icon.png');
      final bytes = byteData.buffer.asUint8List();
      
      final iconFile = File(path.join(tempDir.path, 'dune_tray_icon.png'));
      await iconFile.writeAsBytes(bytes);
      
      print('[SystemTray] Icon prepared at: ${iconFile.path}');
      return iconFile.path;
    }
  }

  /// Update alert count badge
  Future<void> updateAlertCount(int count) async {
    if (!_initialized) return;

    _alertCount = count;

    final tooltipText = count > 0
        ? 'Dune Companion - $count alert${count == 1 ? '' : 's'}'
        : 'Dune Companion';

    // Try setToolTip first (works on Windows/macOS)
    try {
      await trayManager.setToolTip(tooltipText);
    } catch (e) {
      // setToolTip not supported on this platform
      print('[SystemTray] setToolTip not supported: $e');
    }

    // On Linux, also use setTitle as a workaround
    // Some desktop environments (KDE, etc.) display the title on hover
    if (Platform.isLinux) {
      try {
        await trayManager.setTitle(tooltipText);
        print('[SystemTray] Linux: Using setTitle as tooltip workaround');
      } catch (e) {
        print('[SystemTray] setTitle failed: $e');
      }
    }

    // Update menu to show count
    await _updateMenu();
  }

  /// Update the tray context menu
  Future<void> _updateMenu() async {
    final menu = Menu(
      items: [
        MenuItem(
          key: 'show',
          label: 'Show Window',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'check',
          label: _alertCount > 0
              ? 'Check Alerts ($_alertCount)'
              : 'Check Alerts',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'toggle_notifications',
          label: 'Toggle Notifications',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'quit',
          label: 'Quit',
        ),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  /// Handle tray icon click
  @override
  void onTrayIconMouseDown() {
    _onShowWindow?.call();
  }

  /// Handle tray icon right click
  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  /// Handle menu item click
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        _onShowWindow?.call();
        break;
      case 'check':
        _onCheckAlerts?.call();
        break;
      case 'toggle_notifications':
        _onToggleNotifications?.call();
        break;
      case 'quit':
        _onQuit?.call();
        break;
    }
  }

  /// Handle window close (minimize to tray instead of quit)
  @override
  void onWindowClose() async {
    // Prevent window from closing
    await windowManager.hide();
  }

  /// Show the main window
  Future<void> showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  /// Hide the main window (minimize to tray)
  Future<void> hideWindow() async {
    await windowManager.hide();
  }

  /// Dispose resources
  Future<void> dispose() async {
    if (!_initialized) return;

    trayManager.removeListener(this);
    windowManager.removeListener(this);
    await trayManager.destroy();

    _initialized = false;
  }

  // Unused WindowListener methods (required by interface)
  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowUnmaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowResize() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowLeaveFullScreen() {}

  @override
  void onWindowEvent(String eventName) {}
}
