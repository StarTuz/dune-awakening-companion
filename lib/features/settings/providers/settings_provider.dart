import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});

class SettingsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = const AsyncValue.loading();
      // Load any saved settings
      state = AsyncValue.data({});
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setString(String key, String value) async {
    try {
      await _repository.setString(key, value);
      final current = state.value ?? {};
      state = AsyncValue.data({...current, key: value});
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      await _repository.setBool(key, value);
      final current = state.value ?? {};
      state = AsyncValue.data({...current, key: value});
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      await _repository.setInt(key, value);
      final current = state.value ?? {};
      state = AsyncValue.data({...current, key: value});
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
