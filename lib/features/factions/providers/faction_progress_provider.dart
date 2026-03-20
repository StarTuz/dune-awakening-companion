import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../models/faction_progress.dart';
import '../services/faction_progress_repository.dart';

final factionProgressRepositoryProvider =
    Provider<FactionProgressRepository>((ref) {
  return FactionProgressRepository(AppDatabase.instance);
});

final factionProgressProvider =
    FutureProvider.family<List<FactionProgress>, String>(
        (ref, characterId) async {
  final repository = ref.watch(factionProgressRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final factionProgressEditorProvider = Provider((ref) {
  return FactionProgressEditor(
    ref.watch(factionProgressRepositoryProvider),
    ref,
  );
});

class FactionProgressEditor {
  final FactionProgressRepository _repository;
  final Ref _ref;

  FactionProgressEditor(this._repository, this._ref);

  Future<void> save(FactionProgress progress) async {
    await _repository.upsert(progress.copyWith(updatedAt: DateTime.now()));
    _ref.invalidate(factionProgressProvider(progress.characterId));
  }

  Future<void> delete(String id, String characterId) async {
    await _repository.delete(id);
    _ref.invalidate(factionProgressProvider(characterId));
  }
}
