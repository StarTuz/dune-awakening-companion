import 'package:sqflite/sqflite.dart';

/// Migration 018: Auto event log backing the dashboard's Recent Activity.
///
/// Events are app actions (character/base created or deleted, Chronicle
/// entry written). `subject` is a display-name snapshot so events survive
/// the deletion of what they reference — hence no foreign keys.
class Migration018AddActivityEvents {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS activity_events (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        subject TEXT NOT NULL,
        character_name TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_activity_events_created_at
      ON activity_events(created_at DESC)
    ''');
  }
}
