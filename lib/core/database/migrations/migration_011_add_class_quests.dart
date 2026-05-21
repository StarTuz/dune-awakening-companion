import 'package:sqflite/sqflite.dart';

/// Migration 011: Starting class and class trainer quest tracking.
class Migration011AddClassQuests {
  static Future<void> up(Database db) async {
    await _addColumnIfMissing(
      db,
      'characters',
      'primary_class',
      'TEXT',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_class_quests (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        quest_id TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'not_started',
        notes TEXT,
        started_at INTEGER,
        completed_at INTEGER,
        updated_at INTEGER NOT NULL,
        UNIQUE(character_id, quest_id),
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_class_quest_steps (
        id TEXT PRIMARY KEY,
        class_quest_progress_id TEXT NOT NULL,
        step_id TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        UNIQUE(class_quest_progress_id, step_id),
        FOREIGN KEY (class_quest_progress_id)
          REFERENCES character_class_quests(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_character_class_quests_character_id
      ON character_class_quests(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_character_class_quest_steps_progress_id
      ON character_class_quest_steps(class_quest_progress_id)
    ''');
  }

  static Future<void> _addColumnIfMissing(
    Database db,
    String tableName,
    String columnName,
    String columnDefinition,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    final exists = columns.any((column) => column['name'] == columnName);
    if (exists) return;

    await db.execute(
      'ALTER TABLE $tableName ADD COLUMN $columnName $columnDefinition',
    );
  }
}
