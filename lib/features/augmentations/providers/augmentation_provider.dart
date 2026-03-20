import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../models/augmentation.dart';
import '../services/augmentation_repository.dart';

final augmentationRepositoryProvider = Provider<AugmentationRepository>((ref) {
  return AugmentationRepository(AppDatabase.instance);
});

final augmentationsProvider =
    FutureProvider.family<List<Augmentation>, String>((ref, characterId) async {
  final repository = ref.watch(augmentationRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final augmentationEditorProvider = Provider((ref) {
  return AugmentationEditor(
    ref.watch(augmentationRepositoryProvider),
    ref,
  );
});

class AugmentationEditor {
  final AugmentationRepository _repository;
  final Ref _ref;

  AugmentationEditor(this._repository, this._ref);

  Future<void> save(Augmentation augmentation) async {
    await _repository.upsert(augmentation.copyWith(updatedAt: DateTime.now()));
    _ref.invalidate(augmentationsProvider(augmentation.characterId));
  }

  Future<void> delete(String id, String characterId) async {
    await _repository.delete(id);
    _ref.invalidate(augmentationsProvider(characterId));
  }
}
