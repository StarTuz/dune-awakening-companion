import 'package:sqflite/sqflite.dart';

/// Migration 014: RPG journal Phase 2.
///
/// Adds a character biography and optional per-entry location/mood fields.
/// See `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phase 2).
class Migration014AddJournalPhase2 {
  static Future<void> up(Database db) async {
    await db.execute('ALTER TABLE characters ADD COLUMN biography TEXT');
    await db.execute('ALTER TABLE journal_entries ADD COLUMN location TEXT');
    await db.execute('ALTER TABLE journal_entries ADD COLUMN mood TEXT');
  }
}
