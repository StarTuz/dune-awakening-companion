import 'package:sqflite/sqflite.dart';

/// Migration 017: per-character acknowledgement of the closed-world migration
/// notice, so a user who has already transferred can dismiss the badge.
///
/// See `docs/RESEARCH_SERVER_MIGRATIONS.md` (Phase 3b).
class Migration017AddClosedWorldAck {
  static Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE characters
      ADD COLUMN closed_world_acknowledged INTEGER NOT NULL DEFAULT 0;
    ''');
  }

  static Future<void> down(Database db) async {
    // SQLite doesn't support DROP COLUMN without table recreation; no-op since
    // we don't downgrade.
  }
}
