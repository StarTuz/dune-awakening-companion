import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available Dune factions for theming
enum DuneFaction {
  /// Default desert theme (current)
  desert,
  /// House Atreides - Green & Black
  atreides,
  /// House Harkonnen - Red & Black
  harkonnen,
  /// Fremen - Tan & Blue (stillsuit aesthetic)
  fremen,
  /// Smuggler - Purple & Bronze
  smuggler,
}

/// Theme mode provider - manages light/dark theme preference
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Faction theme provider - manages which faction's color scheme to use
final factionThemeProvider = StateNotifierProvider<FactionThemeNotifier, DuneFaction>((ref) {
  return FactionThemeNotifier();
});

/// Notifier for theme mode state with persistence
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  static const String _kThemeModeKey = 'theme_mode';

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeModeString = prefs.getString(_kThemeModeKey);
    if (themeModeString != null) {
      state = _themeModeFromString(themeModeString);
    }
  }

  /// Set theme mode and persist to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, _themeModeToString(mode));
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Check if currently using dark mode
  bool get isDarkMode => state == ThemeMode.dark;

  /// Convert ThemeMode to string for storage
  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert string to ThemeMode
  static ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }
}

/// Notifier for faction theme state with persistence
class FactionThemeNotifier extends StateNotifier<DuneFaction> {
  FactionThemeNotifier() : super(DuneFaction.desert) {
    _loadFaction();
  }

  static const String _kFactionKey = 'faction_theme';

  /// Load saved faction from SharedPreferences
  Future<void> _loadFaction() async {
    final prefs = await SharedPreferences.getInstance();
    final String? factionString = prefs.getString(_kFactionKey);
    if (factionString != null) {
      state = _factionFromString(factionString);
    }
  }

  /// Set faction and persist to SharedPreferences
  Future<void> setFaction(DuneFaction faction) async {
    state = faction;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFactionKey, _factionToString(faction));
  }

  /// Convert DuneFaction to string for storage
  static String _factionToString(DuneFaction faction) {
    return faction.name;
  }

  /// Convert string to DuneFaction
  static DuneFaction _factionFromString(String value) {
    return DuneFaction.values.firstWhere(
      (f) => f.name == value,
      orElse: () => DuneFaction.desert,
    );
  }

  /// Get display name for a faction
  static String getFactionDisplayName(DuneFaction faction) {
    switch (faction) {
      case DuneFaction.desert:
        return 'Desert (Default)';
      case DuneFaction.atreides:
        return 'House Atreides';
      case DuneFaction.harkonnen:
        return 'House Harkonnen';
      case DuneFaction.fremen:
        return 'Fremen';
      case DuneFaction.smuggler:
        return 'Smuggler';
    }
  }

  /// Get description for a faction
  static String getFactionDescription(DuneFaction faction) {
    switch (faction) {
      case DuneFaction.desert:
        return 'Warm sand & spice gold';
      case DuneFaction.atreides:
        return 'Green & black - The noble house';
      case DuneFaction.harkonnen:
        return 'Red & black - The brutal rulers';
      case DuneFaction.fremen:
        return 'Tan & blue - The desert warriors';
      case DuneFaction.smuggler:
        return 'Purple & bronze - The shadow traders';
    }
  }
}
