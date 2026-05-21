import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/blueprints/models/blueprint.dart';
import 'package:dune_awakening_companion/features/blueprints/services/blueprint_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';

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
  late BlueprintRepository blueprintRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_blueprints_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    blueprintRepo = BlueprintRepository(AppDatabase.instance);
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

  test('persists Hagga Basin South blueprints per character', () async {
    final now = DateTime.now();

    await characterRepo.create(
      Character(
        id: 'char-blueprints',
        name: 'Chani',
        region: 'NA',
        serverType: 'Official',
        world: 'Arrakis',
        sietch: 'Tabr',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await blueprintRepo.upsert(
      Blueprint(
        id: 'bp-1',
        characterId: 'char-blueprints',
        name: 'Starter Cutter Schematic',
        category: 'Tool',
        sourceType: 'Chest',
        sourceLocation: 'Hagga Basin South',
        requiredMaterials: const ['Scrap Metal', 'Plant Fiber'],
        notes: 'Verify exact source in-game before publishing as guide data.',
        isUnlocked: true,
        unlockedAt: now,
        respawnTimerEnabled: true,
        questId: 'quest-placeholder',
        mapPinId: 'hagga-south-placeholder',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final blueprints = await blueprintRepo.getByCharacterAndRegion(
      'char-blueprints',
      Blueprint.defaultRegion,
    );

    expect(blueprints, hasLength(1));
    expect(blueprints.single.name, 'Starter Cutter Schematic');
    expect(blueprints.single.requiredMaterials, contains('Scrap Metal'));
    expect(blueprints.single.isUnlocked, isTrue);
    expect(blueprints.single.respawnTimerEnabled, isTrue);
    expect(blueprints.single.questId, 'quest-placeholder');
    expect(blueprints.single.mapPinId, 'hagga-south-placeholder');
  });
}
