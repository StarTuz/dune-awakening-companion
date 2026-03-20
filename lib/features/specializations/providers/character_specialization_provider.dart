import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../models/character_specialization.dart';
import '../services/character_specialization_repository.dart';

final characterSpecializationRepositoryProvider =
    Provider<CharacterSpecializationRepository>((ref) {
  return CharacterSpecializationRepository(AppDatabase.instance);
});

final characterSpecializationProvider =
    FutureProvider.family<CharacterSpecialization, String>(
        (ref, characterId) async {
  final repository = ref.watch(characterSpecializationRepositoryProvider);
  final existing = await repository.getByCharacterId(characterId);
  return existing ??
      CharacterSpecialization(
        id: const Uuid().v4(),
        characterId: characterId,
        updatedAt: DateTime.now(),
      );
});

final characterSpecializationEditorProvider = Provider((ref) {
  return CharacterSpecializationEditor(
    ref.watch(characterSpecializationRepositoryProvider),
    ref,
  );
});

class CharacterSpecializationEditor {
  final CharacterSpecializationRepository _repository;
  final Ref _ref;

  CharacterSpecializationEditor(this._repository, this._ref);

  Future<void> save(CharacterSpecialization specialization) async {
    await _repository.upsert(
      specialization.copyWith(updatedAt: DateTime.now()),
    );
    _ref.invalidate(
        characterSpecializationProvider(specialization.characterId));
  }
}
