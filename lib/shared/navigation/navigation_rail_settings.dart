import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the desktop navigation rail shows labels (extended) or icons only.
/// Persisted across launches via SharedPreferences.
final navigationRailExpandedProvider =
    StateNotifierProvider<NavigationRailExpandedNotifier, bool>((ref) {
  return NavigationRailExpandedNotifier();
});

class NavigationRailExpandedNotifier extends StateNotifier<bool> {
  NavigationRailExpandedNotifier() : super(true) {
    _load();
  }

  static const _key = 'navigation_rail_expanded';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_key);
      if (saved != null && mounted) state = saved;
    } catch (_) {
      // Keep the default (expanded) if prefs are unavailable.
    }
  }

  Future<void> toggle() async {
    state = !state;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, state);
    } catch (_) {
      // Non-fatal: the toggle still applies for this session.
    }
  }
}
