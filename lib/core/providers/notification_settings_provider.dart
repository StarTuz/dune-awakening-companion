import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_settings.dart';

/// State class for notification settings
class NotificationSettingsState {
  final bool enabled;
  final int intervalMinutes;
  final bool includeWarnings;
  final bool startMinimized;
  final bool isLoading;

  const NotificationSettingsState({
    this.enabled = true,
    this.intervalMinutes = 30,
    this.includeWarnings = false,
    this.startMinimized = false,
    this.isLoading = true,
  });

  NotificationSettingsState copyWith({
    bool? enabled,
    int? intervalMinutes,
    bool? includeWarnings,
    bool? startMinimized,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      includeWarnings: includeWarnings ?? this.includeWarnings,
      startMinimized: startMinimized ?? this.startMinimized,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// StateNotifier for notification settings
/// This ensures state sync between Settings UI and System Tray
class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsNotifier() : super(const NotificationSettingsState()) {
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final settings = await NotificationSettings.getAllSettings();
    state = NotificationSettingsState(
      enabled: settings['enabled'] as bool,
      intervalMinutes: settings['intervalMinutes'] as int,
      includeWarnings: settings['includeWarnings'] as bool,
      startMinimized: settings['startMinimized'] as bool,
      isLoading: false,
    );
  }

  /// Reload settings (call when external changes occur)
  Future<void> refresh() async {
    await _loadSettings();
  }

  /// Set notifications enabled/disabled
  Future<void> setEnabled(bool enabled) async {
    await NotificationSettings.setNotificationsEnabled(enabled);
    state = state.copyWith(enabled: enabled);
  }

  /// Set check interval
  Future<void> setInterval(int minutes) async {
    await NotificationSettings.setCheckInterval(minutes);
    state = state.copyWith(intervalMinutes: minutes);
  }

  /// Set include warnings
  Future<void> setIncludeWarnings(bool include) async {
    await NotificationSettings.setIncludeWarnings(include);
    state = state.copyWith(includeWarnings: include);
  }

  /// Set start minimized
  Future<void> setStartMinimized(bool minimized) async {
    await NotificationSettings.setStartMinimized(minimized);
    state = state.copyWith(startMinimized: minimized);
  }
}

/// Provider for notification settings state
/// Both Settings UI and System Tray should use this provider
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>((ref) {
  return NotificationSettingsNotifier();
});
