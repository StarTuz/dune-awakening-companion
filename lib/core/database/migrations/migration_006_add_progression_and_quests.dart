import 'package:sqflite/sqflite.dart';

/// Migration 006: Add progression and quest tracking tables.
class Migration006AddProgressionAndQuests {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_specializations (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL UNIQUE,
        combat_level INTEGER NOT NULL DEFAULT 0,
        crafting_level INTEGER NOT NULL DEFAULT 0,
        gathering_level INTEGER NOT NULL DEFAULT 0,
        exploration_level INTEGER NOT NULL DEFAULT 0,
        sabotage_level INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS faction_progress (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        faction_name TEXT NOT NULL,
        current_rank INTEGER NOT NULL DEFAULT 1,
        reputation_points INTEGER,
        contracts_completed INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS augmentations (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        name TEXT NOT NULL,
        slot TEXT NOT NULL,
        source_boss TEXT,
        notes TEXT,
        is_equipped INTEGER NOT NULL DEFAULT 0,
        acquired_at INTEGER,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS quests (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        notes TEXT,
        status TEXT NOT NULL DEFAULT 'active',
        quest_type TEXT NOT NULL DEFAULT 'general',
        mission_type TEXT,
        is_landsraad_contract INTEGER NOT NULL DEFAULT 0,
        is_repeatable INTEGER NOT NULL DEFAULT 0,
        specialization_xp_gained INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS quest_steps (
        id TEXT PRIMARY KEY,
        quest_id TEXT NOT NULL,
        title TEXT NOT NULL,
        notes TEXT,
        sort_order INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (quest_id) REFERENCES quests(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_character_specializations_character_id
      ON character_specializations(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_faction_progress_character_id
      ON faction_progress(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_augmentations_character_id
      ON augmentations(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quests_character_id
      ON quests(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quests_status
      ON quests(status)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_quest_steps_quest_id
      ON quest_steps(quest_id)
    ''');
  }

  static Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS quest_steps');
    await db.execute('DROP TABLE IF EXISTS quests');
    await db.execute('DROP TABLE IF EXISTS augmentations');
    await db.execute('DROP TABLE IF EXISTS faction_progress');
    await db.execute('DROP TABLE IF EXISTS character_specializations');
  }
}
