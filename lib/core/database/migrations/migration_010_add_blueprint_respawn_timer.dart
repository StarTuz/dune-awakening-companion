import 'package:sqflite/sqflite.dart';

/// Migration 010: Optional respawn timer flag for blueprint checklist rows.
class Migration010AddBlueprintRespawnTimer {
  static Future<void> up(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(blueprints)');
    final exists =
        columns.any((column) => column['name'] == 'respawn_timer_enabled');
    if (exists) return;

    await db.execute('''
      ALTER TABLE blueprints
      ADD COLUMN respawn_timer_enabled INTEGER NOT NULL DEFAULT 0
    ''');
  }
}
