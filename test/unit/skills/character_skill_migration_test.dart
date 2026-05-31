import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dune_awakening_companion/core/database/migrations/migration_012_add_character_skills.dart';

/// Schema smoke test for migration 012 (character_skills table).
///
/// Uses sqflite_common_ffi against an in-memory database — no AppDatabase,
/// no path_provider, no platform plugins required.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openFresh() async {
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await Migration012AddCharacterSkills.up(db);
    return db;
  }

  test('migration creates character_skills table with expected columns',
      () async {
    final db = await openFresh();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(character_skills)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(
        names,
        containsAll(<String>{
          'id',
          'character_id',
          'skill_id',
          'current_rank',
          'target_rank',
          'is_equipped',
          'updated_at',
        }));
  });

  test('migration creates the character_id index', () async {
    final db = await openFresh();
    addTearDown(db.close);

    final indexes = await db.rawQuery(
      'SELECT name FROM sqlite_master '
      "WHERE type='index' AND tbl_name='character_skills'",
    );
    final names = indexes.map((i) => i['name'] as String).toSet();
    expect(names, contains('idx_character_skills_character_id'));
  });

  test('insert + read round-trip preserves data', () async {
    final db = await openFresh();
    addTearDown(db.close);

    final now = DateTime.utc(2026, 5, 21).millisecondsSinceEpoch;
    await db.insert('character_skills', {
      'id': 'cs-1',
      'character_id': 'char-1',
      'skill_id': 'benegesserit-bindu-dodge',
      'current_rank': 2,
      'target_rank': 3,
      'is_equipped': 1,
      'updated_at': now,
    });

    final rows = await db.query('character_skills');
    expect(rows, hasLength(1));
    final row = rows.single;
    expect(row['id'], 'cs-1');
    expect(row['current_rank'], 2);
    expect(row['target_rank'], 3);
    expect(row['is_equipped'], 1);
    expect(row['updated_at'], now);
  });

  test('UNIQUE(character_id, skill_id) prevents duplicate skill rows',
      () async {
    final db = await openFresh();
    addTearDown(db.close);

    final now = DateTime.utc(2026, 5, 21).millisecondsSinceEpoch;
    Map<String, Object?> row(String id) => {
          'id': id,
          'character_id': 'char-1',
          'skill_id': 'benegesserit-bindu-dodge',
          'current_rank': 1,
          'target_rank': null,
          'is_equipped': 0,
          'updated_at': now,
        };

    await db.insert('character_skills', row('cs-1'));
    expect(
      () => db.insert('character_skills', row('cs-2')),
      throwsA(isA<DatabaseException>()),
    );
  });
}
