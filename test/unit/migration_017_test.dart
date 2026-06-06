import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dune_awakening_companion/core/database/migrations/migration_017_add_closed_world_ack.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('migration 017 adds closed_world_acknowledged defaulting to 0',
      () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);

    // Simulate a pre-17 characters table with an existing row.
    await db.execute('CREATE TABLE characters (id TEXT PRIMARY KEY)');
    await db.insert('characters', {'id': 'c1'});

    await Migration017AddClosedWorldAck.up(db);

    final rows =
        await db.query('characters', where: 'id = ?', whereArgs: ['c1']);
    // Existing rows backfill to 0 (not acknowledged) via the column default.
    expect(rows.single['closed_world_acknowledged'], 0);

    // New writes round-trip the flag.
    await db.insert('characters', {'id': 'c2', 'closed_world_acknowledged': 1});
    final ack =
        await db.query('characters', where: 'id = ?', whereArgs: ['c2']);
    expect(ack.single['closed_world_acknowledged'], 1);
  });
}
