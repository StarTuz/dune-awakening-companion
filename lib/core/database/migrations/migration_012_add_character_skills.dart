import 'package:sqflite/sqflite.dart';

/// Migration 012: Add character skill-tree planning tables.
class Migration012AddCharacterSkills {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_skills (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        current_rank INTEGER NOT NULL DEFAULT 0,
        target_rank INTEGER,
        is_equipped INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL,
        UNIQUE(character_id, skill_id),
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_character_skills_character_id
      ON character_skills(character_id)
    ''');
  }
}
