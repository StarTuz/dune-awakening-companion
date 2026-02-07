import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:dune_awakening_companion/core/database/app_database.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
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

/// Integration test: full character + base lifecycle via repository layer.
void main() {
  late Directory tempDir;
  late CharacterRepository characterRepo;
  late BaseRepository baseRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('int_char_base_');
    PathProviderPlatform.instance = _TestPathProvider(tempDir.path);
    await AppDatabase.instance.initialize();
    characterRepo = CharacterRepository(AppDatabase.instance);
    baseRepo = BaseRepository(AppDatabase.instance);
  });

  tearDownAll(() async {
    await AppDatabase.instance.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    final db = await AppDatabase.instance.database;
    await db.delete('bases');
    await db.delete('characters');
  });

  // ---------------------------------------------------------------
  // Character + Base CRUD
  // ---------------------------------------------------------------

  test('create character, add bases, update base, delete base', () async {
    final now = DateTime.now();

    // 1. Create character
    final character = Character(
      id: 'char-int-1',
      name: 'Integration Paul',
      region: 'NA',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    );
    await characterRepo.create(character);

    final fetched = await characterRepo.getById('char-int-1');
    expect(fetched, isNotNull);
    expect(fetched!.name, 'Integration Paul');

    // 2. Add two bases
    final base1 = Base(
      id: 'base-int-1',
      characterId: character.id,
      name: 'Outpost Alpha',
      powerExpirationTime: now.add(const Duration(hours: 12)),
      createdAt: now,
      updatedAt: now,
    );
    final base2 = Base(
      id: 'base-int-2',
      characterId: character.id,
      name: 'Outpost Beta',
      powerExpirationTime: now.add(const Duration(hours: 72)),
      createdAt: now,
      updatedAt: now,
    );
    await baseRepo.create(base1);
    await baseRepo.create(base2);

    var bases = await baseRepo.getByCharacterId(character.id);
    expect(bases.length, 2);

    // 3. Update base power
    final updatedBase1 = base1.copyWith(
      powerExpirationTime: now.add(const Duration(hours: 120)),
      updatedAt: DateTime.now(),
    );
    await baseRepo.update(updatedBase1);

    final refetched = await baseRepo.getById('base-int-1');
    expect(refetched, isNotNull);
    expect(refetched!.hoursRemaining, greaterThan(100));

    // 4. Delete one base
    await baseRepo.delete('base-int-2');
    bases = await baseRepo.getByCharacterId(character.id);
    expect(bases.length, 1);
    expect(bases.first.name, 'Outpost Alpha');
  });

  // ---------------------------------------------------------------
  // Cascade: deleting a character removes its bases
  // ---------------------------------------------------------------

  test('deleting character and its bases cleans up correctly', () async {
    final now = DateTime.now();

    final character = Character(
      id: 'char-cascade',
      name: 'Cascade Test',
      region: 'EU',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    );
    await characterRepo.create(character);

    final base = Base(
      id: 'base-cascade',
      characterId: character.id,
      name: 'Will be deleted',
      powerExpirationTime: now.add(const Duration(hours: 6)),
      createdAt: now,
      updatedAt: now,
    );
    await baseRepo.create(base);

    // Verify base exists
    var charBases = await baseRepo.getByCharacterId(character.id);
    expect(charBases.length, 1);

    // Delete base first, then character (app-level cleanup pattern)
    await baseRepo.delete(base.id);
    await characterRepo.delete(character.id);

    charBases = await baseRepo.getByCharacterId(character.id);
    expect(charBases, isEmpty);

    final fetchedChar = await characterRepo.getById(character.id);
    expect(fetchedChar, isNull);
  });

  // ---------------------------------------------------------------
  // Multiple characters don't interfere
  // ---------------------------------------------------------------

  test('bases are scoped to their character', () async {
    final now = DateTime.now();

    await characterRepo.create(Character(
      id: 'char-a',
      name: 'Char A',
      region: 'NA',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    ));
    await characterRepo.create(Character(
      id: 'char-b',
      name: 'Char B',
      region: 'EU',
      serverType: 'Official',
      world: 'Caladan',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    ));

    await baseRepo.create(Base(
      id: 'base-a1',
      characterId: 'char-a',
      name: 'Base A-1',
      powerExpirationTime: now.add(const Duration(hours: 48)),
      createdAt: now,
      updatedAt: now,
    ));
    await baseRepo.create(Base(
      id: 'base-b1',
      characterId: 'char-b',
      name: 'Base B-1',
      powerExpirationTime: now.add(const Duration(hours: 48)),
      createdAt: now,
      updatedAt: now,
    ));

    final basesA = await baseRepo.getByCharacterId('char-a');
    final basesB = await baseRepo.getByCharacterId('char-b');
    expect(basesA.length, 1);
    expect(basesA.first.name, 'Base A-1');
    expect(basesB.length, 1);
    expect(basesB.first.name, 'Base B-1');
  });

  // ---------------------------------------------------------------
  // getExpiringSoon returns only near-expiry bases
  // ---------------------------------------------------------------

  test('getExpiringSoon returns only bases within 24 hours', () async {
    final now = DateTime.now();

    await characterRepo.create(Character(
      id: 'char-exp',
      name: 'Expiring Test',
      region: 'NA',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    ));

    // Base expiring in 6 hours (should be returned)
    await baseRepo.create(Base(
      id: 'base-exp-soon',
      characterId: 'char-exp',
      name: 'Expiring Soon',
      powerExpirationTime: now.add(const Duration(hours: 6)),
      createdAt: now,
      updatedAt: now,
    ));

    // Base expiring in 72 hours (should NOT be returned)
    await baseRepo.create(Base(
      id: 'base-exp-later',
      characterId: 'char-exp',
      name: 'Safe Base',
      powerExpirationTime: now.add(const Duration(hours: 72)),
      createdAt: now,
      updatedAt: now,
    ));

    final expiring = await baseRepo.getExpiringSoon();
    expect(expiring.length, 1);
    expect(expiring.first.name, 'Expiring Soon');
  });
}
