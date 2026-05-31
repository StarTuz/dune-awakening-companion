import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/journal/services/journal_repository.dart';
import 'package:dune_awakening_companion/features/settings/services/import_service.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this.basePath);
  final String basePath;
  @override
  Future<String?> getApplicationSupportPath() async => basePath;
  @override
  Future<String?> getApplicationDocumentsPath() async => basePath;
}

/// Integration test: Phase 4 journal screenshots bundled into a ZIP backup are
/// extracted and their stored path is remapped to the new local location.
void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_journal_img_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('bundled journal screenshot is extracted and remapped on import',
      () async {
    final character = Character(
      id: 'char-1',
      name: 'Muad\'Dib',
      region: 'Hagga Basin',
      serverType: 'Official',
      world: 'World 1',
      sietch: 'Sietch Tabr',
      createdAt: DateTime.utc(2026, 5, 30),
      updatedAt: DateTime.utc(2026, 5, 30),
    );

    final exportData = {
      'version': '1.3.0-beta',
      'exportDate': DateTime.utc(2026, 5, 30).toIso8601String(),
      'databaseVersion': 15,
      'format': 'zip',
      'characters': [character.toJson()],
      'bases': <dynamic>[],
      'journalEntries': [
        {
          'id': 'je-1',
          'characterId': character.id,
          'title': 'Bundled shot',
          'body': 'See screenshot',
          'tags': ['session'],
          'entryDate': DateTime.utc(2026, 5, 30).toIso8601String(),
          'imagePath': 'journal_images/je-1.jpg',
          'createdAt': DateTime.utc(2026, 5, 30).toIso8601String(),
          'updatedAt': DateTime.utc(2026, 5, 30).toIso8601String(),
        },
      ],
    };

    final archive = Archive();
    final imageBytes = utf8.encode('fake-jpeg-bytes');
    archive.addFile(
      ArchiveFile('journal_images/je-1.jpg', imageBytes.length, imageBytes),
    );
    final jsonBytes = utf8.encode(json.encode(exportData));
    archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));
    final zipBytes = ZipEncoder().encode(archive)!;

    final zipPath = path.join(tempDir.path, 'backup.zip');
    await File(zipPath).writeAsBytes(zipBytes);

    final journalRepo = JournalRepository(AppDatabase.instance);
    final importService = ImportService(
      CharacterRepository(AppDatabase.instance),
      BaseRepository(AppDatabase.instance),
      journalRepository: journalRepo,
    );

    final result = await importService.importData(zipPath, ImportMode.replace);
    expect(result.success, isTrue);

    final entries = await journalRepo.getByCharacterId(character.id);
    expect(entries, hasLength(1));
    final restored = entries.single;

    // Path should be remapped to the extracted location (not the archive path).
    expect(restored.imagePath, isNotNull);
    expect(restored.imagePath, isNot('journal_images/je-1.jpg'));
    expect(restored.imagePath, contains('journal_images'));
    expect(File(restored.imagePath!).existsSync(), isTrue);
  });
}
