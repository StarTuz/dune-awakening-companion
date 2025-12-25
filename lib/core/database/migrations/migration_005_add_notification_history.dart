import 'package:sqflite/sqflite.dart';

/// Migration 005: Add notification_history table
class Migration005AddNotificationHistory {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notification_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        base_id TEXT,
        base_name TEXT,
        character_name TEXT,
        severity TEXT NOT NULL,
        sent_at TEXT NOT NULL,
        read INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Index for faster queries by date
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notification_history_sent_at 
      ON notification_history(sent_at DESC)
    ''');
  }

  static Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS notification_history');
  }
}
