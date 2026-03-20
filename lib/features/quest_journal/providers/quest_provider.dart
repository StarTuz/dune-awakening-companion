import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../models/quest.dart';
import '../models/quest_step.dart';
import '../services/quest_reminder_service.dart';
import '../services/quest_repository.dart';

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository(AppDatabase.instance);
});

final questReminderServiceProvider = Provider<QuestReminderService>((ref) {
  return QuestReminderService();
});

final questsProvider = FutureProvider<List<Quest>>((ref) async {
  final repository = ref.watch(questRepositoryProvider);
  return repository.getAll();
});

final questsByCharacterProvider =
    FutureProvider.family<List<Quest>, String>((ref, characterId) async {
  final repository = ref.watch(questRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final questStepsProvider =
    FutureProvider.family<List<QuestStep>, String>((ref, questId) async {
  final repository = ref.watch(questRepositoryProvider);
  return repository.getSteps(questId);
});

final questEditorProvider = Provider((ref) {
  return QuestEditor(
    ref.watch(questRepositoryProvider),
    ref.watch(questReminderServiceProvider),
    ref,
  );
});

class QuestEditor {
  final QuestRepository _repository;
  final QuestReminderService _reminders;
  final Ref _ref;

  QuestEditor(this._repository, this._reminders, this._ref);

  Future<void> saveQuest(Quest quest) async {
    final updated = quest.copyWith(updatedAt: DateTime.now());
    await _repository.upsertQuest(updated);
    await _reminders.syncAfterQuestSave(updated);
    _ref.invalidate(questsProvider);
    _ref.invalidate(questsByCharacterProvider(quest.characterId));
  }

  Future<void> saveStep(QuestStep step, String characterId) async {
    await _repository.upsertStep(step);
    _ref.invalidate(questStepsProvider(step.questId));
    _ref.invalidate(questsByCharacterProvider(characterId));
    _ref.invalidate(questsProvider);
  }

  Future<void> deleteQuest(String id, String characterId) async {
    await _reminders.cancelForQuest(id);
    await _repository.deleteQuest(id);
    _ref.invalidate(questsProvider);
    _ref.invalidate(questsByCharacterProvider(characterId));
  }

  Future<void> deleteStep(String id, String questId) async {
    await _repository.deleteStep(id);
    _ref.invalidate(questStepsProvider(questId));
  }

  Future<void> reorderSteps(
    String questId,
    String characterId,
    List<QuestStep> ordered,
  ) async {
    await _repository.updateStepsSortOrder(ordered);
    _ref.invalidate(questStepsProvider(questId));
    _ref.invalidate(questsByCharacterProvider(characterId));
    _ref.invalidate(questsProvider);
  }
}
