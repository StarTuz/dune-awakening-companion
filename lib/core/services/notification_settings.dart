import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist notification settings
class NotificationSettings {
  static const String _keyEnabled = 'notifications_enabled';
  static const String _keyInterval = 'notification_interval_minutes';
  static const String _keyIncludeWarnings = 'notifications_include_warnings';
  static const String _keyStartMinimized = 'start_minimized_to_tray';
  static const String _keyQuietHoursEnabled = 'quiet_hours_enabled';
  static const String _keyQuietHoursStart = 'quiet_hours_start'; // minutes from midnight
  static const String _keyQuietHoursEnd = 'quiet_hours_end'; // minutes from midnight

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

  // ===== QUIET HOURS =====

  /// Check if quiet hours are enabled
  static Future<bool> getQuietHoursEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyQuietHoursEnabled) ?? false; // Default: disabled
  }

  /// Set quiet hours enabled/disabled
  static Future<void> setQuietHoursEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyQuietHoursEnabled, enabled);
  }

  /// Get quiet hours start time (minutes from midnight, default 22:00 = 1320)
  static Future<int> getQuietHoursStart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyQuietHoursStart) ?? 1320; // Default: 10 PM
  }

  /// Set quiet hours start time (minutes from midnight)
  static Future<void> setQuietHoursStart(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyQuietHoursStart, minutes);
  }

  /// Get quiet hours end time (minutes from midnight, default 08:00 = 480)
  static Future<int> getQuietHoursEnd() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyQuietHoursEnd) ?? 480; // Default: 8 AM
  }

  /// Set quiet hours end time (minutes from midnight)
  static Future<void> setQuietHoursEnd(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyQuietHoursEnd, minutes);
  }

  /// Check if current time is within quiet hours
  static Future<bool> isInQuietHours() async {
    final enabled = await getQuietHoursEnabled();
    if (!enabled) return false;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final start = await getQuietHoursStart();
    final end = await getQuietHoursEnd();

    // Handle overnight quiet hours (e.g., 22:00 - 08:00)
    if (start > end) {
      // Quiet hours span midnight
      return currentMinutes >= start || currentMinutes < end;
    } else {
      // Quiet hours within same day (e.g., 13:00 - 15:00)
      return currentMinutes >= start && currentMinutes < end;
    }
  }

  /// Convert minutes from midnight to TimeOfDay-like string
  static String minutesToTimeString(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    return '${displayHour.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')} $period';
  }

  /// Get all settings as a map
  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'enabled': await getNotificationsEnabled(),
      'intervalMinutes': await getCheckInterval(),
      'includeWarnings': await getIncludeWarnings(),
      'startMinimized': await getStartMinimized(),
      'quietHoursEnabled': await getQuietHoursEnabled(),
      'quietHoursStart': await getQuietHoursStart(),
      'quietHoursEnd': await getQuietHoursEnd(),
    };
  }
}
