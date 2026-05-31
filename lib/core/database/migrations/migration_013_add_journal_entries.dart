import 'package:sqflite/sqflite.dart';

/// Migration 013: Add per-character RPG journal entries.
///
/// See `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phase 1).
class Migration013AddJournalEntries {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS journal_entries (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL DEFAULT '',
        tags TEXT NOT NULL DEFAULT '',
        entry_date INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_journal_entries_character_id
      ON journal_entries(character_id)
    ''');
  }
}
