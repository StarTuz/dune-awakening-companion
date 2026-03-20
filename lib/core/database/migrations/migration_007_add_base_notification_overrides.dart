import 'package:sqflite/sqflite.dart';

/// Migration 007: Add per-base notification overrides.
class Migration007AddBaseNotificationOverrides {
  static Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE bases
      ADD COLUMN notifications_enabled INTEGER NOT NULL DEFAULT 1
    ''');

    await db.execute('''
      ALTER TABLE bases
      ADD COLUMN warning_threshold_hours INTEGER
    ''');

    await db.execute('''
      ALTER TABLE bases
      ADD COLUMN critical_threshold_hours INTEGER
    ''');
  }

  static Future<void> down(Database db) async {
    // SQLite does not support dropping columns without recreating the table.
  }
}
