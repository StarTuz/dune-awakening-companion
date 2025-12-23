import 'package:sqflite/sqflite.dart';

/// Initial database migration
/// Creates all core tables for the application
class Migration001Initial {
  static Future<void> up(Database db) async {
    // Servers table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS servers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Characters table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS characters (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        server_id TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (server_id) REFERENCES servers(id) ON DELETE CASCADE
      )
    ''');

    // Bases table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bases (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        name TEXT NOT NULL,
        power_expiration_time INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    // Alerts table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS alerts (
        id TEXT PRIMARY KEY,
        base_id TEXT NOT NULL,
        threshold_hours INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        acknowledged_at INTEGER,
        dismissed_at INTEGER,
        FOREIGN KEY (base_id) REFERENCES bases(id) ON DELETE CASCADE
      )
    ''');

    // Alert settings table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS alert_settings (
        id TEXT PRIMARY KEY,
        warning_thresholds TEXT NOT NULL,  -- JSON array
        check_interval_minutes INTEGER NOT NULL,
        repeat_interval_minutes INTEGER NOT NULL,
        enable_sound INTEGER NOT NULL,  -- 0 or 1
        enable_notifications INTEGER NOT NULL,  -- 0 or 1
        minimize_to_tray INTEGER NOT NULL  -- 0 or 1
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_characters_server_id 
      ON characters(server_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_bases_character_id 
      ON bases(character_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_bases_power_expiration 
      ON bases(power_expiration_time)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_alerts_base_id 
      ON alerts(base_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_alerts_created_at 
      ON alerts(created_at)
    ''');

    // Insert default alert settings
    await db.insert('alert_settings', {
      'id': 'default',
      'warning_thresholds': '[24]',
      'check_interval_minutes': 1,
      'repeat_interval_minutes': 0,
      'enable_sound': 0,
      'enable_notifications': 1,
      'minimize_to_tray': 1,
    });
  }

  static Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS alerts');
    await db.execute('DROP TABLE IF EXISTS alert_settings');
    await db.execute('DROP TABLE IF EXISTS bases');
    await db.execute('DROP TABLE IF EXISTS characters');
    await db.execute('DROP TABLE IF EXISTS servers');
  }
}

