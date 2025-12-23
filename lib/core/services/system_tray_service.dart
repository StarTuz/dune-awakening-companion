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
    if (Platform.isLinux || Platform.isMacOS) {
      // Load icon from assets
      final byteData = await rootBundle.load('assets/app_icon.png');
      final bytes = byteData.buffer.asUint8List();
      
      // Write to temp directory
      final tempDir = await getTemporaryDirectory();
      final iconFile = File(path.join(tempDir.path, 'dune_tray_icon.png'));
      await iconFile.writeAsBytes(bytes);
      
      return iconFile.path;
    } else {
      // Windows uses ICO format
      return 'assets/app_icon.ico';
    }
  }

  /// Update alert count badge
  Future<void> updateAlertCount(int count) async {
    if (!_initialized) return;

    _alertCount = count;

    // Update tooltip (may not be supported on all platforms)
    try {
      final tooltip = count > 0
          ? 'Dune Companion - $count alert${count == 1 ? '' : 's'}'
          : 'Dune Companion';

      await trayManager.setToolTip(tooltip);
    } catch (e) {
      // setToolTip not supported on this platform, ignore
      print('[SystemTray] setToolTip not supported: $e');
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
