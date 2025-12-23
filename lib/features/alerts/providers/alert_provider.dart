import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/alert.dart';
import '../models/alert_settings.dart';
import '../services/alert_repository.dart';
import 'package:uuid/uuid.dart';

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  return AlertRepository(AppDatabase.instance);
});

final alertSettingsRepositoryProvider = Provider<AlertSettingsRepository>((ref) {
  return AlertSettingsRepository(AppDatabase.instance);
});

final alertsProvider = StateNotifierProvider<AlertNotifier, AsyncValue<List<Alert>>>((ref) {
  final repository = ref.watch(alertRepositoryProvider);
  return AlertNotifier(repository, ref);
});

final activeAlertsProvider = FutureProvider<List<Alert>>((ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  return await repository.getActive();
});

final alertsByBaseProvider = FutureProvider.family<List<Alert>, String>((ref, baseId) async {
  final repository = ref.watch(alertRepositoryProvider);
  return await repository.getByBaseId(baseId);
});

final alertSettingsProvider = FutureProvider<AlertSettings>((ref) async {
  final repository = ref.watch(alertSettingsRepositoryProvider);
  return await repository.get();
});

class AlertNotifier extends StateNotifier<AsyncValue<List<Alert>>> {
  final AlertRepository _repository;
  final Ref _ref;

  AlertNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    try {
      state = const AsyncValue.loading();
      final alerts = await _repository.getAll();
      state = AsyncValue.data(alerts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createAlert(String baseId, int thresholdHours) async {
    try {
      final alert = Alert(
        id: const Uuid().v4(),
        baseId: baseId,
        thresholdHours: thresholdHours,
        createdAt: DateTime.now(),
      );
      await _repository.create(alert);
      _ref.invalidate(activeAlertsProvider);
      _ref.invalidate(alertsByBaseProvider(baseId));
      await _loadAlerts();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> acknowledgeAlert(String id, String baseId) async {
    try {
      await _repository.acknowledge(id);
      _ref.invalidate(activeAlertsProvider);
      _ref.invalidate(alertsByBaseProvider(baseId));
      await _loadAlerts();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> dismissAlert(String id, String baseId) async {
    try {
      await _repository.dismiss(id);
      _ref.invalidate(activeAlertsProvider);
      _ref.invalidate(alertsByBaseProvider(baseId));
      await _loadAlerts();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAlert(String id, String baseId) async {
    try {
      await _repository.delete(id);
      _ref.invalidate(activeAlertsProvider);
      _ref.invalidate(alertsByBaseProvider(baseId));
      await _loadAlerts();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final alertSettingsNotifierProvider =
    StateNotifierProvider<AlertSettingsNotifier, AsyncValue<AlertSettings>>((ref) {
  final repository = ref.watch(alertSettingsRepositoryProvider);
  return AlertSettingsNotifier(repository, ref);
});

class AlertSettingsNotifier extends StateNotifier<AsyncValue<AlertSettings>> {
  final AlertSettingsRepository _repository;
  final Ref _ref;

  AlertSettingsNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = const AsyncValue.loading();
      final settings = await _repository.get();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(AlertSettings settings) async {
    try {
      await _repository.update(settings);
      _ref.invalidate(alertSettingsProvider);
      await _loadSettings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
