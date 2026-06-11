import 'package:shared_preferences/shared_preferences.dart';

/// Persists Field Timer user preferences via SharedPreferences.
/// All values have research-seeded defaults; every value is user-editable.
class FieldTimerSettings {
  static const _keyDefaultDurationSeconds = 'field_timer_default_duration_s';
  static const _keyCueCount = 'field_timer_cue_count';
  static const _keyCueSpacingSeconds = 'field_timer_cue_spacing_s';
  static const _keyCueVolume = 'field_timer_cue_volume';
  static const _keyEscalationIntervalSeconds =
      'field_timer_escalation_interval_s';
  static const _keyBypassQuietHours = 'field_timer_bypass_quiet_hours';

  // ── Defaults (research-seeded) ──────────────────────────────────────────
  static const defaultDurationSeconds = 180; // 3:00 conservative
  static const defaultCueCount = 3;
  static const defaultCueSpacingSeconds = 30;
  static const defaultCueVolume = 0.8;
  static const defaultEscalationIntervalSeconds = 15;
  static const defaultBypassQuietHours = true;

  static Future<int> getDefaultDurationSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDefaultDurationSeconds) ?? defaultDurationSeconds;
  }

  static Future<void> setDefaultDurationSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDefaultDurationSeconds, seconds);
  }

  static Future<int> getCueCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCueCount) ?? defaultCueCount;
  }

  static Future<void> setCueCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCueCount, count.clamp(0, 6));
  }

  static Future<int> getCueSpacingSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCueSpacingSeconds) ?? defaultCueSpacingSeconds;
  }

  static Future<void> setCueSpacingSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCueSpacingSeconds, seconds);
  }

  static Future<double> getCueVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyCueVolume) ?? defaultCueVolume;
  }

  static Future<void> setCueVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyCueVolume, volume.clamp(0.0, 1.0));
  }

  static Future<int> getEscalationIntervalSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyEscalationIntervalSeconds) ??
        defaultEscalationIntervalSeconds;
  }

  static Future<void> setEscalationIntervalSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyEscalationIntervalSeconds, seconds);
  }

  static Future<bool> getBypassQuietHours() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBypassQuietHours) ?? defaultBypassQuietHours;
  }

  static Future<void> setBypassQuietHours(bool bypass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBypassQuietHours, bypass);
  }

  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'defaultDurationSeconds': await getDefaultDurationSeconds(),
      'cueCount': await getCueCount(),
      'cueSpacingSeconds': await getCueSpacingSeconds(),
      'cueVolume': await getCueVolume(),
      'escalationIntervalSeconds': await getEscalationIntervalSeconds(),
      'bypassQuietHours': await getBypassQuietHours(),
    };
  }
}
