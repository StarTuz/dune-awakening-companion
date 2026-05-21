import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../models/class_quest_progress.dart';
import '../services/class_quest_repository.dart';

final classQuestRepositoryProvider = Provider<ClassQuestRepository>((ref) {
  return ClassQuestRepository(AppDatabase.instance);
});

final classQuestProgressProvider =
    FutureProvider.family<List<ClassQuestProgress>, String>(
        (ref, characterId) async {
  final repository = ref.watch(classQuestRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final classQuestStepsProvider =
    FutureProvider.family<List<ClassQuestStepProgress>, String>(
  (ref, progressId) async {
    final repository = ref.watch(classQuestRepositoryProvider);
    return repository.getSteps(progressId);
  },
);

final classQuestEditorProvider = Provider((ref) {
  return ClassQuestEditor(ref.watch(classQuestRepositoryProvider), ref);
});

class ClassQuestEditor {
  final ClassQuestRepository _repository;
  final Ref _ref;

  ClassQuestEditor(this._repository, this._ref);

  Future<ClassQuestProgress> setStatus({
    required String characterId,
    required String questId,
    required String status,
  }) async {
    final now = DateTime.now();
    final existing =
        await _repository.getByCharacterAndQuest(characterId, questId);
    final progress = (existing ??
            ClassQuestProgress(
              id: const Uuid().v4(),
              characterId: characterId,
              questId: questId,
              updatedAt: now,
            ))
        .copyWith(
      status: status,
      startedAt:
          status == ClassQuestStatus.inProgress && existing?.startedAt == null
              ? now
              : existing?.startedAt,
      completedAt: status == ClassQuestStatus.completed ? now : null,
      updatedAt: now,
    );
    await _repository.upsertProgress(progress);
    _invalidate(characterId);
    return progress;
  }

  Future<void> toggleStep({
    required String characterId,
    required String questId,
    required String stepId,
    required bool isCompleted,
  }) async {
    final now = DateTime.now();
    final progress = await _ensureProgress(characterId, questId, now);
    final existingSteps = await _repository.getSteps(progress.id);
    final existing = existingSteps
        .cast<ClassQuestStepProgress?>()
        .firstWhere((step) => step?.stepId == stepId, orElse: () => null);
    final stepProgress = ClassQuestStepProgress(
      id: existing?.id ?? const Uuid().v4(),
      classQuestProgressId: progress.id,
      stepId: stepId,
      isCompleted: isCompleted,
      completedAt: isCompleted ? now : null,
    );
    await _repository.upsertStep(stepProgress);
    _invalidate(characterId);
    _ref.invalidate(classQuestStepsProvider(progress.id));
  }

  Future<ClassQuestProgress> _ensureProgress(
    String characterId,
    String questId,
    DateTime now,
  ) async {
    final existing =
        await _repository.getByCharacterAndQuest(characterId, questId);
    if (existing != null) return existing;

    final progress = ClassQuestProgress(
      id: const Uuid().v4(),
      characterId: characterId,
      questId: questId,
      status: ClassQuestStatus.inProgress,
      startedAt: now,
      updatedAt: now,
    );
    await _repository.upsertProgress(progress);
    return progress;
  }

  void _invalidate(String characterId) {
    _ref.invalidate(classQuestProgressProvider(characterId));
  }
}
