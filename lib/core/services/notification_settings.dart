import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist notification settings
class NotificationSettings {
  static const String _keyEnabled = 'notifications_enabled';
  static const String _keyInterval = 'notification_interval_minutes';
  static const String _keyIncludeWarnings = 'notifications_include_warnings';
  static const String _keyStartMinimized = 'start_minimized_to_tray';

  /// Check if notifications are enabled
  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnabled) ?? true; // Default: enabled
  }

  /// Set notifications enabled/disabled
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, enabled);
  }

  /// Get check interval in minutes
  static Future<int> getCheckInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyInterval) ?? 30; // Default: 30 minutes
  }

  /// Set check interval in minutes
  static Future<void> setCheckInterval(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyInterval, minutes);
  }

  /// Check if warning notifications (< 48h) are included
  static Future<bool> getIncludeWarnings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIncludeWarnings) ?? false; // Default: critical only
  }

  /// Set whether to include warning notifications
  static Future<void> setIncludeWarnings(bool include) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIncludeWarnings, include);
  }

  /// Check if app should start minimized to tray (desktop only)
  static Future<bool> getStartMinimized() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyStartMinimized) ?? false; // Default: show window
  }

  /// Set whether app starts minimized to tray
  static Future<void> setStartMinimized(bool minimized) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStartMinimized, minimized);
  }

  /// Get all settings as a map
  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'enabled': await getNotificationsEnabled(),
      'intervalMinutes': await getCheckInterval(),
      'includeWarnings': await getIncludeWarnings(),
      'startMinimized': await getStartMinimized(),
    };
  }
}
