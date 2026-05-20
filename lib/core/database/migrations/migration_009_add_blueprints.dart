import 'package:sqflite/sqflite.dart';

/// Migration 009: Per-character blueprint/schematic tracker.
class Migration009AddBlueprints {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS blueprints (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        region TEXT NOT NULL DEFAULT 'Hagga Basin South',
        source_type TEXT,
        source_location TEXT,
        required_materials TEXT NOT NULL DEFAULT '[]',
        notes TEXT,
        is_unlocked INTEGER NOT NULL DEFAULT 0,
        unlocked_at INTEGER,
        quest_id TEXT,
        map_pin_id TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_blueprints_character_id
      ON blueprints(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_blueprints_region
      ON blueprints(region)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_blueprints_unlocked
      ON blueprints(is_unlocked)
    ''');
  }
}
