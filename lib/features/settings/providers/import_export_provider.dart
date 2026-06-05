import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../augmentations/providers/augmentation_provider.dart';
import '../../blueprints/providers/blueprint_provider.dart';
import '../../class_quests/providers/class_quest_provider.dart';
import '../../factions/providers/faction_progress_provider.dart';
import '../../base_calculator/providers/base_calculator_plan_provider.dart';
import '../../journal/providers/journal_provider.dart';
import '../../quest_journal/providers/quest_provider.dart';
import '../../skills/providers/skill_provider.dart';
import '../../specializations/providers/character_specialization_provider.dart';
import '../services/export_service.dart';
import '../services/import_service.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  final characterRepo = ref.watch(characterRepositoryProvider);
  final baseRepo = ref.watch(baseRepositoryProvider);
  final specializationRepo =
      ref.watch(characterSpecializationRepositoryProvider);
  final factionRepo = ref.watch(factionProgressRepositoryProvider);
  final augmentationRepo = ref.watch(augmentationRepositoryProvider);
  final questRepo = ref.watch(questRepositoryProvider);
  final blueprintRepo = ref.watch(blueprintRepositoryProvider);
  final classQuestRepo = ref.watch(classQuestRepositoryProvider);
  final skillRepo = ref.watch(characterSkillRepositoryProvider);
  final journalRepo = ref.watch(journalRepositoryProvider);
  final planRepo = ref.watch(baseCalculatorPlanRepositoryProvider);
  return ExportService(
    characterRepo,
    baseRepo,
    specializationRepository: specializationRepo,
    factionRepository: factionRepo,
    augmentationRepository: augmentationRepo,
    questRepository: questRepo,
    blueprintRepository: blueprintRepo,
    classQuestRepository: classQuestRepo,
    characterSkillRepository: skillRepo,
    journalRepository: journalRepo,
    baseCalculatorPlanRepository: planRepo,
  );
});

final importServiceProvider = Provider<ImportService>((ref) {
  final characterRepo = ref.watch(characterRepositoryProvider);
  final baseRepo = ref.watch(baseRepositoryProvider);
  final specializationRepo =
      ref.watch(characterSpecializationRepositoryProvider);
  final factionRepo = ref.watch(factionProgressRepositoryProvider);
  final augmentationRepo = ref.watch(augmentationRepositoryProvider);
  final questRepo = ref.watch(questRepositoryProvider);
  final blueprintRepo = ref.watch(blueprintRepositoryProvider);
  final classQuestRepo = ref.watch(classQuestRepositoryProvider);
  final skillRepo = ref.watch(characterSkillRepositoryProvider);
  final journalRepo = ref.watch(journalRepositoryProvider);
  final planRepo = ref.watch(baseCalculatorPlanRepositoryProvider);
  return ImportService(
    characterRepo,
    baseRepo,
    specializationRepository: specializationRepo,
    factionRepository: factionRepo,
    augmentationRepository: augmentationRepo,
    questRepository: questRepo,
    blueprintRepository: blueprintRepo,
    classQuestRepository: classQuestRepo,
    characterSkillRepository: skillRepo,
    journalRepository: journalRepo,
    baseCalculatorPlanRepository: planRepo,
  );
});
