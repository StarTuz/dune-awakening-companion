import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/augmentations/models/augmentation.dart';
import 'package:dune_awakening_companion/features/augmentations/services/augmentation_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/factions/models/faction_progress.dart';
import 'package:dune_awakening_companion/features/factions/services/faction_progress_repository.dart';
import 'package:dune_awakening_companion/features/quest_journal/models/quest.dart';
import 'package:dune_awakening_companion/features/quest_journal/models/quest_step.dart';
import 'package:dune_awakening_companion/features/quest_journal/services/quest_repository.dart';
import 'package:dune_awakening_companion/features/specializations/models/character_specialization.dart';
import 'package:dune_awakening_companion/features/specializations/services/character_specialization_repository.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this.basePath);
  final String basePath;

  @override
  Future<String?> getApplicationSupportPath() async => basePath;

  @override
  Future<String?> getApplicationDocumentsPath() async => basePath;
}

void main() {
  late Directory tempDir;
  late CharacterRepository characterRepo;
  late CharacterSpecializationRepository specializationRepo;
  late FactionProgressRepository factionRepo;
  late AugmentationRepository augmentationRepo;
  late QuestRepository questRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_progression_quest_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    specializationRepo =
        CharacterSpecializationRepository(AppDatabase.instance);
    factionRepo = FactionProgressRepository(AppDatabase.instance);
    augmentationRepo = AugmentationRepository(AppDatabase.instance);
    questRepo = QuestRepository(AppDatabase.instance);
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    await AppDatabase.instance.clearAllData();
  });

  test('persists specialization, faction progress, augmentations, and quests',
      () async {
    final now = DateTime.now();

    await characterRepo.create(
      Character(
        id: 'char-progress',
        name: 'Paul',
        region: 'NA',
        serverType: 'Official',
        world: 'Arrakis',
        sietch: 'Tabr',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await specializationRepo.upsert(
      CharacterSpecialization(
        id: 'spec-1',
        characterId: 'char-progress',
        combatLevel: 25,
        craftingLevel: 10,
        gatheringLevel: 8,
        explorationLevel: 12,
        sabotageLevel: 5,
        updatedAt: now,
      ),
    );

    await factionRepo.upsert(
      FactionProgress(
        id: 'faction-1',
        characterId: 'char-progress',
        factionName: 'Atreides',
        currentRank: 7,
        contractsCompleted: 14,
        updatedAt: now,
      ),
    );

    await augmentationRepo.upsert(
      Augmentation(
        id: 'aug-1',
        characterId: 'char-progress',
        name: 'Spice Lens',
        slot: 'Helmet',
        sourceBoss: 'Forge Tyrant',
        isEquipped: true,
        updatedAt: now,
      ),
    );

    await questRepo.upsertQuest(
      Quest(
        id: 'quest-1',
        characterId: 'char-progress',
        title: 'Trial of Arrakis',
        questType: 'challenge',
        status: 'active',
        missionType: 'Exploration',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await questRepo.upsertStep(
      QuestStep(
        id: 'step-1',
        questId: 'quest-1',
        title: 'Reach the first station',
        isCompleted: true,
        completedAt: now,
        createdAt: now,
      ),
    );

    final specialization =
        await specializationRepo.getByCharacterId('char-progress');
    final factionEntries = await factionRepo.getByCharacterId('char-progress');
    final augmentations =
        await augmentationRepo.getByCharacterId('char-progress');
    final quests = await questRepo.getByCharacterId('char-progress');
    final steps = await questRepo.getSteps('quest-1');

    expect(specialization, isNotNull);
    expect(specialization!.totalLevel, 60);
    expect(factionEntries.single.currentRank, 7);
    expect(augmentations.single.isEquipped, isTrue);
    expect(quests.single.title, 'Trial of Arrakis');
    expect(steps.single.isCompleted, isTrue);
  });
}
