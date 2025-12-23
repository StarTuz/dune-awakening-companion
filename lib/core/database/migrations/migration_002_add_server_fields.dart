import 'package:sqflite/sqflite.dart';

class Migration002AddServerFields {
  static Future<void> up(Database db) async {
    // SQLite doesn't support ALTER TABLE to drop columns, so we need to:
    // 1. Create new table with correct schema
    // 2. Copy existing data
    // 3. Drop old table
    // 4. Rename new table
    
    // Create new characters table with updated schema
    await db.execute('''
      CREATE TABLE characters_new (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        region TEXT NOT NULL,
        server_type TEXT NOT NULL,
        provider TEXT,
        world TEXT NOT NULL,
        sietch TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    
    // Copy existing data if any (unlikely on first run, but safe)
    // We'll skip copying since the old schema is incompatible
    
    // Drop old table and indexes
    await db.execute('DROP INDEX IF EXISTS idx_characters_server_id');
    await db.execute('DROP TABLE IF EXISTS characters');
    
    // Rename new table to characters
    await db.execute('ALTER TABLE characters_new RENAME TO characters');
    
    // Create index for better query performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_characters_region 
      ON characters(region)
    ''');
  }
}
