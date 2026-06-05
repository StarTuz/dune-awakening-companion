import 'package:sqflite/sqflite.dart';

/// Migration 016: Base Calculator Phase 3 — persisted build plans.
///
/// See `docs/RESEARCH_BASE_CALCULATOR.md` (Phase 3).
class Migration016AddBaseCalculatorPlans {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE base_calculator_plans (
        id TEXT PRIMARY KEY,
        character_id TEXT,
        base_id TEXT,
        name TEXT NOT NULL,
        deep_desert_discount_enabled INTEGER NOT NULL DEFAULT 0,
        item_quantities TEXT NOT NULL DEFAULT '{}',
        storage_quantities TEXT NOT NULL DEFAULT '{}',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE SET NULL,
        FOREIGN KEY (base_id) REFERENCES bases(id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_base_calculator_plans_updated_at
      ON base_calculator_plans(updated_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_base_calculator_plans_character_id
      ON base_calculator_plans(character_id)
    ''');
  }
}
