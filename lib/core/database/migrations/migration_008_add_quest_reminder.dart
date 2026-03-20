import 'package:sqflite/sqflite.dart';

/// Migration 008: Optional one-shot quest reminder timestamp.
class Migration008AddQuestReminder {
  static Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE quests ADD COLUMN reminder_at INTEGER
    ''');
  }
}
