import 'package:sqflite_common/sqlite_api.dart';

class Migration004AddPortraits {
  static Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE characters ADD COLUMN portraitPath TEXT;
    ''');
  }

  static Future<void> down(Database db) async {
    // SQLite doesn't support DROP COLUMN, would need table recreation
    // For simplicity, we'll leave it as no-op since we don't downgrade
  }
}
