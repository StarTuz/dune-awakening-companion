import 'package:sqflite/sqflite.dart';

/// Migration 015: RPG journal Phase 3.
///
/// Adds an optional link from a journal entry to a tracked quest and a local
/// screenshot/image path. See `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phase 3).
class Migration015AddJournalPhase3 {
  static Future<void> up(Database db) async {
    await db.execute('ALTER TABLE journal_entries ADD COLUMN quest_id TEXT');
    await db.execute('ALTER TABLE journal_entries ADD COLUMN image_path TEXT');
  }
}
