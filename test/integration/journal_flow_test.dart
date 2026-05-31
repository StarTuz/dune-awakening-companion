import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/journal/models/journal_entry.dart';
import 'package:dune_awakening_companion/features/journal/services/journal_repository.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this.basePath);
  final String basePath;
  @override
  Future<String?> getApplicationSupportPath() async => basePath;
  @override
  Future<String?> getApplicationDocumentsPath() async => basePath;
}

/// Integration test: per-character RPG journal lifecycle via repository layer.
void main() {
  late Directory tempDir;
  late CharacterRepository characterRepo;
  late JournalRepository journalRepo;

  Character buildCharacter(String id) => Character(
        id: id,
        name: 'Muad\'Dib',
        region: 'Hagga Basin',
        serverType: 'Official',
        world: 'World 1',
        sietch: 'Sietch Tabr',
        createdAt: DateTime.utc(2026, 5, 30),
        updatedAt: DateTime.utc(2026, 5, 30),
      );

  JournalEntry buildEntry(String id, String characterId) => JournalEntry(
        id: id,
        characterId: characterId,
        title: 'Entry $id',
        body: 'Body for $id',
        tags: const ['test'],
        entryDate: DateTime.utc(2026, 5, 30),
        createdAt: DateTime.utc(2026, 5, 30),
        updatedAt: DateTime.utc(2026, 5, 30),
      );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_journal_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    journalRepo = JournalRepository(AppDatabase.instance);
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    final db = await AppDatabase.instance.database;
    await db.delete('journal_entries');
    await db.delete('characters');
  });

  test('create, read, update and delete a journal entry', () async {
    final character = buildCharacter('char-1');
    await characterRepo.create(character);

    await journalRepo.upsert(buildEntry('je-1', character.id));
    var entries = await journalRepo.getByCharacterId(character.id);
    expect(entries, hasLength(1));
    expect(entries.single.title, 'Entry je-1');
    expect(entries.single.tags, const ['test']);

    final updated = entries.single.copyWith(title: 'Renamed');
    await journalRepo.upsert(updated);
    entries = await journalRepo.getByCharacterId(character.id);
    expect(entries.single.title, 'Renamed');

    await journalRepo.delete('je-1');
    entries = await journalRepo.getByCharacterId(character.id);
    expect(entries, isEmpty);
  });

  test('entries are returned newest entry_date first', () async {
    final character = buildCharacter('char-1');
    await characterRepo.create(character);

    await journalRepo.upsert(
      buildEntry('older', character.id)
          .copyWith(entryDate: DateTime.utc(2026, 1, 1)),
    );
    await journalRepo.upsert(
      buildEntry('newer', character.id)
          .copyWith(entryDate: DateTime.utc(2026, 5, 30)),
    );

    final entries = await journalRepo.getByCharacterId(character.id);
    expect(entries.map((e) => e.id).toList(), ['newer', 'older']);
  });

  test('deleting a character cascades to their journal entries', () async {
    final character = buildCharacter('char-1');
    await characterRepo.create(character);
    await journalRepo.upsert(buildEntry('je-1', character.id));

    await characterRepo.delete(character.id);

    final entries = await journalRepo.getByCharacterId(character.id);
    expect(entries, isEmpty);
  });

  test('Phase 2/3 fields persist through the repository', () async {
    final character = buildCharacter('char-1');
    await characterRepo.create(character);

    final entry = buildEntry('je-1', character.id).copyWith(
      location: 'Hagga Basin',
      mood: 'Hopeful',
      questId: 'quest-1',
      imagePath: '/tmp/shot.png',
    );
    await journalRepo.upsert(entry);

    final restored = (await journalRepo.getByCharacterId(character.id)).single;
    expect(restored.location, 'Hagga Basin');
    expect(restored.mood, 'Hopeful');
    expect(restored.questId, 'quest-1');
    expect(restored.imagePath, '/tmp/shot.png');

    final cleared = restored.copyWith(questId: null, imagePath: null);
    await journalRepo.upsert(cleared);
    final after = (await journalRepo.getByCharacterId(character.id)).single;
    expect(after.questId, isNull);
    expect(after.imagePath, isNull);
  });

  test('character biography persists through the repository', () async {
    final character = buildCharacter('char-1');
    await characterRepo.create(character);

    await characterRepo.update(
      character.copyWith(biography: 'A ghola with recovered memories.'),
    );

    final restored = await characterRepo.getById(character.id);
    expect(restored?.biography, 'A ghola with recovered memories.');
  });
}
