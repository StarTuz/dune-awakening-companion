import 'package:sqflite/sqflite.dart';

/// Migration 007: Add per-base notification overrides.
class Migration007AddBaseNotificationOverrides {
  static Future<void> up(Database db) async {
    await _addColumnIfMissing(
      db,
      'notifications_enabled',
      'INTEGER NOT NULL DEFAULT 1',
    );

    await _addColumnIfMissing(
      db,
      'warning_threshold_hours',
      'INTEGER',
    );

    await _addColumnIfMissing(
      db,
      'critical_threshold_hours',
      'INTEGER',
    );
  }

  static Future<void> down(Database db) async {
    // SQLite does not support dropping columns without recreating the table.
  }

  static Future<void> _addColumnIfMissing(
    Database db,
    String columnName,
    String columnDefinition,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info(bases)');
    final exists = columns.any((column) => column['name'] == columnName);
    if (exists) return;

    await db
        .execute('ALTER TABLE bases ADD COLUMN $columnName $columnDefinition');
  }
}
