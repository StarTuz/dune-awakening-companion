import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/settings/services/import_service.dart';
import 'package:dune_awakening_companion/features/skills/services/character_skill_repository.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this.basePath);
  final String basePath;
  @override
  Future<String?> getApplicationSupportPath() async => basePath;
  @override
  Future<String?> getApplicationDocumentsPath() async => basePath;
}

/// Integration test: import/export flows.
void main() {
  late Directory tempDir;
  late CharacterRepository characterRepo;
  late BaseRepository baseRepo;
  late CharacterSkillRepository skillRepo;
  late ImportService importService;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_import_export_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    baseRepo = BaseRepository(AppDatabase.instance);
    skillRepo = CharacterSkillRepository(AppDatabase.instance);
    importService = ImportService(
      characterRepo,
      baseRepo,
      characterSkillRepository: skillRepo,
    );
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    final db = await AppDatabase.instance.database;
    await db.delete('character_skills');
    await db.delete('bases');
    await db.delete('characters');
  });

  // ---------------------------------------------------------------
  // JSON import – merge
  // ---------------------------------------------------------------

  test('import from valid JSON in merge mode', () async {
    final now = DateTime.now();

    // Seed one character
    await characterRepo.create(Character(
      id: 'existing-1',
      name: 'Existing',
      region: 'EU',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    ));

    // Create a JSON backup file
    final exportData = {
      'version': '1.0.0',
      'exportDate': now.toIso8601String(),
      'characters': [
        {
          'id': 'imported-1',
          'name': 'Imported Paul',
          'region': 'NA',
          'serverType': 'Official',
          'world': 'Arrakis',
          'sietch': 'Tabr',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
      'bases': [
        {
          'id': 'imported-base-1',
          'characterId': 'imported-1',
          'name': 'Imported Base',
          'powerExpirationTime':
              now.add(const Duration(hours: 48)).toIso8601String(),
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
    };

    final jsonFile = File('${tempDir.path}/backup.json');
    await jsonFile
        .writeAsString(const JsonEncoder.withIndent('  ').convert(exportData));

    final result =
        await importService.importData(jsonFile.path, ImportMode.merge);
    expect(result.success, isTrue);
    expect(result.charactersImported, 1);
    expect(result.basesImported, 1);

    // Existing character should still be there
    final allChars = await characterRepo.getAll();
    expect(allChars.length, 2);
  });

  test('import restores character skill planner rows', () async {
    final now = DateTime.now();

    final exportData = {
      'version': '1.3.0-beta',
      'exportDate': now.toIso8601String(),
      'databaseVersion': 12,
      'characters': [
        {
          'id': 'skill-char',
          'name': 'Skill Planner',
          'region': 'NA',
          'serverType': 'Official',
          'world': 'Arrakis',
          'sietch': 'Tabr',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
      'bases': [],
      'characterSkills': [
        {
          'id': 'skill-row-1',
          'characterId': 'skill-char',
          'skillId': 'benegesserit-bindu-dodge',
          'currentRank': 2,
          'targetRank': 3,
          'isEquipped': true,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
    };

    final jsonFile = File('${tempDir.path}/skills.json');
    await jsonFile.writeAsString(json.encode(exportData));

    final result =
        await importService.importData(jsonFile.path, ImportMode.replace);
    expect(result.success, isTrue);

    final restored = await skillRepo.getByCharacterId('skill-char');
    expect(restored, hasLength(1));
    expect(restored.single.skillId, 'benegesserit-bindu-dodge');
    expect(restored.single.currentRank, 2);
    expect(restored.single.targetRank, 3);
    expect(restored.single.isEquipped, isTrue);
  });

  // ---------------------------------------------------------------
  // JSON import – replace
  // ---------------------------------------------------------------

  test('import from valid JSON in replace mode', () async {
    final now = DateTime.now();

    await characterRepo.create(Character(
      id: 'to-be-replaced',
      name: 'Old',
      region: 'EU',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    ));

    final exportData = {
      'version': '1.0.0',
      'exportDate': now.toIso8601String(),
      'characters': [
        {
          'id': 'replacement-1',
          'name': 'New',
          'region': 'NA',
          'serverType': 'Official',
          'world': 'Arrakis',
          'sietch': 'Tabr',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
      'bases': [],
    };

    final jsonFile = File('${tempDir.path}/replace.json');
    await jsonFile.writeAsString(json.encode(exportData));

    final result =
        await importService.importData(jsonFile.path, ImportMode.replace);
    expect(result.success, isTrue);

    final allChars = await characterRepo.getAll();
    expect(allChars.length, 1);
    expect(allChars.first.name, 'New');
  });

  // ---------------------------------------------------------------
  // ZIP import with data.json
  // ---------------------------------------------------------------

  test('import from ZIP with data.json', () async {
    final now = DateTime.now();

    final exportData = {
      'version': '1.1.0',
      'exportDate': now.toIso8601String(),
      'format': 'zip',
      'characters': [
        {
          'id': 'zip-char',
          'name': 'Zip Paul',
          'region': 'NA',
          'serverType': 'Official',
          'world': 'Arrakis',
          'sietch': 'Tabr',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      ],
      'bases': [],
    };

    final archive = Archive();
    final jsonBytes = utf8.encode(json.encode(exportData));
    archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));
    final zipData = ZipEncoder().encode(archive)!;

    final zipFile = File('${tempDir.path}/backup.zip');
    await zipFile.writeAsBytes(zipData);

    final result =
        await importService.importData(zipFile.path, ImportMode.replace);
    expect(result.success, isTrue);
    expect(result.charactersImported, 1);
  });

  // ---------------------------------------------------------------
  // Edge cases
  // ---------------------------------------------------------------

  test('import rejects missing file', () async {
    final result = await importService.importData(
      '${tempDir.path}/nonexistent.json',
      ImportMode.merge,
    );
    expect(result.success, isFalse);
    expect(result.error, contains('File not found'));
  });

  test('import rejects invalid JSON structure', () async {
    final badFile = File('${tempDir.path}/bad.json');
    await badFile.writeAsString(json.encode({'foo': 'bar'}));

    final result =
        await importService.importData(badFile.path, ImportMode.merge);
    expect(result.success, isFalse);
  });
}
