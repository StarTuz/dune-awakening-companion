import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../models/blueprint.dart';
import '../services/blueprint_repository.dart';

final blueprintRepositoryProvider = Provider<BlueprintRepository>((ref) {
  return BlueprintRepository(AppDatabase.instance);
});

final blueprintsProvider = FutureProvider<List<Blueprint>>((ref) async {
  final repository = ref.watch(blueprintRepositoryProvider);
  return repository.getAll();
});

final blueprintsByCharacterProvider =
    FutureProvider.family<List<Blueprint>, String>((ref, characterId) async {
  final repository = ref.watch(blueprintRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final haggaSouthBlueprintsProvider =
    FutureProvider.family<List<Blueprint>, String>((ref, characterId) async {
  final repository = ref.watch(blueprintRepositoryProvider);
  return repository.getByCharacterAndRegion(
    characterId,
    Blueprint.defaultRegion,
  );
});

final blueprintEditorProvider = Provider((ref) {
  return BlueprintEditor(ref.watch(blueprintRepositoryProvider), ref);
});

class BlueprintEditor {
  final BlueprintRepository _repository;
  final Ref _ref;

  BlueprintEditor(this._repository, this._ref);

  Future<void> save(Blueprint blueprint) async {
    final updated = blueprint.copyWith(updatedAt: DateTime.now());
    await _repository.upsert(updated);
    _invalidate(updated.characterId);
  }

  /// Flip the `isUnlocked` state. When transitioning from locked → unlocked
  /// AND the per-user `autoStartRespawnTimer` setting is on, also enable the
  /// respawn timer in the same write. When transitioning the other way the
  /// timer is always cleared (existing behavior).
  Future<void> toggleUnlocked(
    Blueprint blueprint, {
    bool autoStartRespawnTimer = false,
  }) async {
    final now = DateTime.now();
    final goingToUnlocked = !blueprint.isUnlocked;
    final updated = blueprint.copyWith(
      isUnlocked: goingToUnlocked,
      unlockedAt: goingToUnlocked ? now : null,
      respawnTimerEnabled: goingToUnlocked
          ? (blueprint.respawnTimerEnabled || autoStartRespawnTimer)
          : false,
      updatedAt: now,
    );
    await _repository.upsert(updated);
    _invalidate(updated.characterId);
  }

  Future<void> setRespawnTimerEnabled(
    Blueprint blueprint,
    bool isEnabled,
  ) async {
    final now = DateTime.now();
    final updated = blueprint.copyWith(
      respawnTimerEnabled: isEnabled,
      unlockedAt: isEnabled && blueprint.unlockedAt == null
          ? now
          : blueprint.unlockedAt,
      updatedAt: now,
    );
    await _repository.upsert(updated);
    _invalidate(updated.characterId);
  }

  Future<void> resetRespawnTimer(Blueprint blueprint) async {
    final now = DateTime.now();
    final updated = blueprint.copyWith(
      isUnlocked: true,
      unlockedAt: now,
      respawnTimerEnabled: true,
      updatedAt: now,
    );
    await _repository.upsert(updated);
    _invalidate(updated.characterId);
  }

  Future<void> delete(Blueprint blueprint) async {
    await _repository.delete(blueprint.id);
    _invalidate(blueprint.characterId);
  }

  void _invalidate(String characterId) {
    _ref.invalidate(blueprintsProvider);
    _ref.invalidate(blueprintsByCharacterProvider(characterId));
    _ref.invalidate(haggaSouthBlueprintsProvider(characterId));
  }
}
