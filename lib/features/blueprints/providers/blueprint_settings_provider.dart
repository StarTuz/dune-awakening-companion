import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings specific to the Blueprints / Schematics tracker.
///
/// Today this is just the "auto-start respawn timer when I unlock a
/// schematic" toggle, but it's structured as a notifier so new toggles
/// (e.g. default region, default view mode) can land alongside it.
class BlueprintSettings {
  final bool autoStartRespawnTimer;

  const BlueprintSettings({this.autoStartRespawnTimer = false});

  BlueprintSettings copyWith({bool? autoStartRespawnTimer}) {
    return BlueprintSettings(
      autoStartRespawnTimer:
          autoStartRespawnTimer ?? this.autoStartRespawnTimer,
    );
  }
}

class BlueprintSettingsNotifier extends StateNotifier<BlueprintSettings> {
  BlueprintSettingsNotifier() : super(const BlueprintSettings()) {
    _load();
  }

  static const String _kAutoStartRespawnTimer =
      'blueprint_auto_start_respawn_timer';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final autoStart = prefs.getBool(_kAutoStartRespawnTimer);
      if (autoStart != null) {
        state = state.copyWith(autoStartRespawnTimer: autoStart);
      }
    } catch (_) {
      // SharedPreferences plugin unavailable in unit/widget tests without
      // setMockInitialValues — fall back to defaults.
    }
  }

  Future<void> setAutoStartRespawnTimer(bool value) async {
    state = state.copyWith(autoStartRespawnTimer: value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kAutoStartRespawnTimer, value);
    } catch (_) {
      // Same as above; persistence is best-effort.
    }
  }
}

final blueprintSettingsProvider =
    StateNotifierProvider<BlueprintSettingsNotifier, BlueprintSettings>(
  (ref) => BlueprintSettingsNotifier(),
);
