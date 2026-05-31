import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dune_awakening_companion/core/database/migrations/migration_013_add_journal_entries.dart';

/// Schema smoke test for migration 013 (journal_entries table).
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
    await Migration013AddJournalEntries.up(db);
    return db;
  }

  test('migration creates journal_entries table with expected columns',
      () async {
    final db = await openFresh();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(journal_entries)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(
        names,
        containsAll(<String>{
          'id',
          'character_id',
          'title',
          'body',
          'tags',
          'entry_date',
          'created_at',
          'updated_at',
        }));
  });

  test('migration creates the character_id index', () async {
    final db = await openFresh();
    addTearDown(db.close);

    final indexes = await db.rawQuery(
      'SELECT name FROM sqlite_master '
      "WHERE type='index' AND tbl_name='journal_entries'",
    );
    final names = indexes.map((i) => i['name'] as String).toSet();
    expect(names, contains('idx_journal_entries_character_id'));
  });

  test('insert + read round-trip preserves data', () async {
    final db = await openFresh();
    addTearDown(db.close);

    final now = DateTime.utc(2026, 5, 30).millisecondsSinceEpoch;
    await db.insert('journal_entries', {
      'id': 'je-1',
      'character_id': 'char-1',
      'title': 'First landing',
      'body': 'Notes about the sietch.',
      'tags': 'arrival,hagga',
      'entry_date': now,
      'created_at': now,
      'updated_at': now,
    });

    final rows = await db.query('journal_entries');
    expect(rows, hasLength(1));
    final row = rows.single;
    expect(row['id'], 'je-1');
    expect(row['title'], 'First landing');
    expect(row['tags'], 'arrival,hagga');
    expect(row['entry_date'], now);
  });
}
