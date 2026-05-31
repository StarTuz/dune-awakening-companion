import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dune_awakening_companion/core/database/migrations/migration_013_add_journal_entries.dart';
import 'package:dune_awakening_companion/core/database/migrations/migration_014_add_journal_phase2.dart';
import 'package:dune_awakening_companion/core/database/migrations/migration_015_add_journal_phase3.dart';

/// Schema smoke test for journal migrations 014 (Phase 2) and 015 (Phase 3).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openMigrated() async {
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    // Minimal characters table so migration 014's ALTER has a target.
    await db.execute('''
      CREATE TABLE characters (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
    await Migration013AddJournalEntries.up(db);
    await Migration014AddJournalPhase2.up(db);
    await Migration015AddJournalPhase3.up(db);
    return db;
  }

  test('journal_entries gains location, mood, quest_id and image_path',
      () async {
    final db = await openMigrated();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(journal_entries)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(
        names,
        containsAll(<String>{
          'location',
          'mood',
          'quest_id',
          'image_path',
        }));
  });

  test('characters gains a biography column', () async {
    final db = await openMigrated();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(characters)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(names, contains('biography'));
  });

  test('insert with Phase 2/3 fields round-trips', () async {
    final db = await openMigrated();
    addTearDown(db.close);

    final now = DateTime.utc(2026, 5, 30).millisecondsSinceEpoch;
    await db.insert('journal_entries', {
      'id': 'je-1',
      'character_id': 'char-1',
      'title': 'Storm watch',
      'body': 'Tracked a Coriolis storm.',
      'tags': 'storm,deep-desert',
      'entry_date': now,
      'location': 'Deep Desert',
      'mood': 'Tense',
      'quest_id': 'quest-9',
      'image_path': '/tmp/storm.png',
      'created_at': now,
      'updated_at': now,
    });

    final row = (await db.query('journal_entries')).single;
    expect(row['location'], 'Deep Desert');
    expect(row['mood'], 'Tense');
    expect(row['quest_id'], 'quest-9');
    expect(row['image_path'], '/tmp/storm.png');
  });
}
