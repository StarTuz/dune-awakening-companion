import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/models/activity_event.dart';
import '../../../core/providers/activity_log_provider.dart';
import '../../characters/providers/character_provider.dart';
import '../models/base.dart';
import '../services/base_repository.dart';
import 'package:uuid/uuid.dart';

final baseRepositoryProvider = Provider<BaseRepository>((ref) {
  return BaseRepository(AppDatabase.instance);
});

final basesProvider =
    StateNotifierProvider<BaseNotifier, AsyncValue<List<Base>>>((ref) {
  final repository = ref.watch(baseRepositoryProvider);
  return BaseNotifier(repository, ref);
});

final basesByCharacterProvider =
    FutureProvider.family<List<Base>, String>((ref, characterId) async {
  final repository = ref.watch(baseRepositoryProvider);
  return await repository.getByCharacterId(characterId);
});

final expiringBasesProvider = FutureProvider<List<Base>>((ref) async {
  final repository = ref.watch(baseRepositoryProvider);
  return await repository.getExpiringSoon();
});

class BaseNotifier extends StateNotifier<AsyncValue<List<Base>>> {
  final BaseRepository _repository;
  final Ref _ref;

  BaseNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    _loadBases();
  }

  Future<void> _loadBases() async {
    try {
      state = const AsyncValue.loading();
      final bases = await _repository.getAll();
      state = AsyncValue.data(bases);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBase(
    String characterId,
    String name,
    DateTime powerExpirationTime, {
    bool notificationsEnabled = true,
    int? warningThresholdHours,
    int? criticalThresholdHours,
  }) async {
    try {
      final base = Base(
        id: const Uuid().v4(),
        characterId: characterId,
        name: name,
        powerExpirationTime: powerExpirationTime,
        notificationsEnabled: notificationsEnabled,
        warningThresholdHours: warningThresholdHours,
        criticalThresholdHours: criticalThresholdHours,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.create(base);
      await _logActivity(ActivityEventType.baseCreated, name, characterId);
      _ref.invalidate(basesByCharacterProvider(characterId));
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateBase(Base base) async {
    try {
      final updatedBase = base.copyWith(updatedAt: DateTime.now());
      await _repository.update(updatedBase);
      _ref.invalidate(basesByCharacterProvider(base.characterId));
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteBase(String id, String characterId) async {
    try {
      final base = await _repository.getById(id);
      await _repository.delete(id);
      if (base != null) {
        await _logActivity(
            ActivityEventType.baseDeleted, base.name, characterId);
      }
      _ref.invalidate(basesByCharacterProvider(characterId));
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Resolve the character's display name from already-loaded state; the
  /// activity log stores a snapshot, so a miss just means a blank subtitle.
  Future<void> _logActivity(
      ActivityEventType type, String subject, String characterId) async {
    String? characterName;
    final characters = _ref.read(charactersProvider).value;
    if (characters != null) {
      for (final c in characters) {
        if (c.id == characterId) {
          characterName = c.name;
          break;
        }
      }
    }
    await _ref
        .read(activityLoggerProvider)
        .log(type, subject, characterName: characterName);
  }
}
