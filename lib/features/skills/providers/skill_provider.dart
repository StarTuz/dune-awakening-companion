import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../models/character_skill.dart';
import '../models/skill_catalog.dart';
import '../services/character_skill_repository.dart';

final skillCatalogProvider = Provider<List<SkillCatalogEntry>>((ref) {
  return skillCatalog;
});

final characterSkillRepositoryProvider =
    Provider<CharacterSkillRepository>((ref) {
  return CharacterSkillRepository(AppDatabase.instance);
});

final characterSkillsProvider =
    FutureProvider.family<List<CharacterSkill>, String>(
        (ref, characterId) async {
  final repository = ref.watch(characterSkillRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final characterSkillEditorProvider = Provider((ref) {
  return CharacterSkillEditor(
    ref.watch(characterSkillRepositoryProvider),
    ref,
  );
});

class CharacterSkillEditor {
  final CharacterSkillRepository _repository;
  final Ref _ref;

  CharacterSkillEditor(this._repository, this._ref);

  Future<void> save(CharacterSkill skill) async {
    await _repository.upsert(skill.copyWith(updatedAt: DateTime.now()));
    _ref.invalidate(characterSkillsProvider(skill.characterId));
  }

  Future<void> delete(String id, String characterId) async {
    await _repository.delete(id);
    _ref.invalidate(characterSkillsProvider(characterId));
  }
}
