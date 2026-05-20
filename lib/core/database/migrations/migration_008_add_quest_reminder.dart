import 'package:sqflite/sqflite.dart';

/// Migration 008: Optional one-shot quest reminder timestamp.
class Migration008AddQuestReminder {
  static Future<void> up(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(quests)');
    final exists = columns.any((column) => column['name'] == 'reminder_at');
    if (exists) return;

    await db.execute('ALTER TABLE quests ADD COLUMN reminder_at INTEGER');
  }
}
