import 'package:sqflite/sqflite.dart';

/// Migration to add tax tracking fields to bases table
class Migration003AddTaxFields {
  static Future<void> up(Database db) async {
    // Add tax tracking columns to bases table
    await db.execute('''
      ALTER TABLE bases ADD COLUMN is_advanced_fief INTEGER NOT NULL DEFAULT 0
    ''');
    
    await db.execute('''
      ALTER TABLE bases ADD COLUMN tax_per_cycle INTEGER
    ''');
    
    await db.execute('''
      ALTER TABLE bases ADD COLUMN next_tax_due_date INTEGER
    ''');
    
    await db.execute('''
      ALTER TABLE bases ADD COLUMN current_owed INTEGER
    ''');
    
    await db.execute('''
      ALTER TABLE bases ADD COLUMN overdue_owed INTEGER
    ''');
    
    await db.execute('''
      ALTER TABLE bases ADD COLUMN defaulted_owed INTEGER
    ''');
    
    // Create index for tax due dates to optimize tax alerts queries
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_bases_next_tax_due 
      ON bases(next_tax_due_date)
    ''');
  }
}
