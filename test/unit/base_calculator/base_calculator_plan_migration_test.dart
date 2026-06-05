import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dune_awakening_companion/core/database/migrations/migration_016_add_base_calculator_plans.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_plan.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openFresh() async {
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await Migration016AddBaseCalculatorPlans.up(db);
    return db;
  }

  test('migration creates base_calculator_plans table with expected columns',
      () async {
    final db = await openFresh();
    addTearDown(db.close);

    final cols = await db.rawQuery('PRAGMA table_info(base_calculator_plans)');
    final names = cols.map((c) => c['name'] as String).toSet();

    expect(
      names,
      containsAll(<String>{
        'id',
        'character_id',
        'base_id',
        'name',
        'deep_desert_discount_enabled',
        'item_quantities',
        'storage_quantities',
        'created_at',
        'updated_at',
      }),
    );
  });

  test('insert + read round-trip preserves encoded quantities', () async {
    final db = await openFresh();
    addTearDown(db.close);

    final now = DateTime.utc(2026, 6, 5, 12).millisecondsSinceEpoch;
    await db.insert('base_calculator_plans', {
      'id': 'plan-1',
      'character_id': 'char-1',
      'base_id': null,
      'name': 'Deep Desert starter',
      'deep_desert_discount_enabled': 1,
      'item_quantities': BaseCalculatorPlan.encodeQuantities(
        const {'fuel_powered_generator': 2},
      ),
      'storage_quantities': BaseCalculatorPlan.encodeQuantities(
        const {'player_inventory': 1},
      ),
      'created_at': now,
      'updated_at': now,
    });

    final rows = await db.query('base_calculator_plans');
    expect(rows, hasLength(1));
    final row = rows.single;
    expect(row['name'], 'Deep Desert starter');
    expect(
      BaseCalculatorPlan.decodeQuantities(row['item_quantities'] as String),
      {'fuel_powered_generator': 2},
    );
    expect(
      BaseCalculatorPlan.decodeQuantities(row['storage_quantities'] as String),
      {'player_inventory': 1},
    );
  });
}
