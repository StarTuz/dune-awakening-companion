import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/core/utils/constants.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/class_quests/models/class_quest_catalog.dart';
import 'package:dune_awakening_companion/features/class_quests/models/class_quest_progress.dart';
import 'package:dune_awakening_companion/features/class_quests/services/class_quest_repository.dart';

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
  late ClassQuestRepository classQuestRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_class_quests_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    classQuestRepo = ClassQuestRepository(AppDatabase.instance);
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

  test('persists starting class and class quest step progress', () async {
    final now = DateTime.now();
    await characterRepo.create(
      Character(
        id: 'char-skills',
        name: 'Alia',
        region: 'North America',
        serverType: 'Official',
        world: 'Arrakis',
        sietch: 'Tabr',
        primaryClass: AppConstants.classBeneGesserit,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final character = await characterRepo.getById('char-skills');
    expect(character?.primaryClass, AppConstants.classBeneGesserit);

    final quest = classQuestCatalog.firstWhere(
      (entry) => entry.id == 'planetologist-basic-minimic-film',
    );
    final progress = ClassQuestProgress(
      id: 'progress-1',
      characterId: 'char-skills',
      questId: quest.id,
      status: ClassQuestStatus.inProgress,
      startedAt: now,
      updatedAt: now,
    );
    await classQuestRepo.upsertProgress(progress);
    await classQuestRepo.upsertStep(
      ClassQuestStepProgress(
        id: 'step-1',
        classQuestProgressId: progress.id,
        stepId: quest.steps.first.id,
        isCompleted: true,
        completedAt: now,
      ),
    );

    final progressEntries =
        await classQuestRepo.getByCharacterId('char-skills');
    final stepEntries = await classQuestRepo.getSteps(progress.id);

    expect(progressEntries.single.questId, quest.id);
    expect(progressEntries.single.status, ClassQuestStatus.inProgress);
    expect(stepEntries.single.stepId, quest.steps.first.id);
    expect(stepEntries.single.isCompleted, isTrue);
  });
}
