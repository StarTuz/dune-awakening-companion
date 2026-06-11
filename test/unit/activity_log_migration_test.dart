import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dune_awakening_companion/core/database/migrations/migration_018_add_activity_events.dart';

/// Schema smoke test for migration 018 (activity event log).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openMigrated() async {
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await Migration018AddActivityEvents.up(db);
    return db;
  }

  test('creates the activity_events table with the expected columns', () async {
    final db = await openMigrated();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(activity_events)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(
        names,
        containsAll(<String>{
          'id',
          'type',
          'subject',
          'character_name',
          'created_at',
        }));
  });

  test('insert and ordered read round-trip', () async {
    final db = await openMigrated();
    addTearDown(db.close);

    await db.insert('activity_events', {
      'id': 'a',
      'type': 'baseCreated',
      'subject': 'Old Camp',
      'character_name': null,
      'created_at': 1,
    });
    await db.insert('activity_events', {
      'id': 'b',
      'type': 'characterCreated',
      'subject': 'Paul',
      'character_name': 'Paul',
      'created_at': 2,
    });

    final rows = await db.query('activity_events', orderBy: 'created_at DESC');
    expect(rows.first['subject'], 'Paul');
    expect(rows.first['character_name'], 'Paul');
    expect(rows.last['character_name'], isNull);
  });

  test('the repository prune statement keeps only the newest rows', () async {
    final db = await openMigrated();
    addTearDown(db.close);

    for (var i = 0; i < 60; i++) {
      await db.insert('activity_events', {
        'id': 'e$i',
        'type': 'baseCreated',
        'subject': 's$i',
        'created_at': i,
      });
    }
    // Same statement ActivityLogRepository.log runs after each insert.
    await db.delete(
      'activity_events',
      where: 'id NOT IN (SELECT id FROM activity_events '
          'ORDER BY created_at DESC LIMIT ?)',
      whereArgs: [50],
    );

    final rows = await db.query('activity_events');
    expect(rows.length, 50);
    final subjects = rows.map((r) => r['subject']).toSet();
    expect(subjects, isNot(contains('s9')));
    expect(subjects, contains('s59'));
  });
}
