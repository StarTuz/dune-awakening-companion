import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/base_calculator_plan.dart';

class BaseCalculatorPlanRepository {
  final AppDatabase _database;

  BaseCalculatorPlanRepository(this._database);

  Future<List<BaseCalculatorPlan>> getAll() async {
    final db = await _database.database;
    final maps = await db.query(
      'base_calculator_plans',
      orderBy: 'updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<BaseCalculatorPlan?> getById(String id) async {
    final db = await _database.database;
    final maps = await db.query(
      'base_calculator_plans',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.single);
  }

  Future<void> upsert(BaseCalculatorPlan plan) async {
    final db = await _database.database;
    await db.insert(
      'base_calculator_plans',
      _toMap(plan),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      'base_calculator_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(BaseCalculatorPlan plan) {
    return {
      'id': plan.id,
      'character_id': plan.characterId,
      'base_id': plan.baseId,
      'name': plan.name,
      'deep_desert_discount_enabled': plan.deepDesertDiscountEnabled ? 1 : 0,
      'item_quantities':
          BaseCalculatorPlan.encodeQuantities(plan.itemQuantities),
      'storage_quantities':
          BaseCalculatorPlan.encodeQuantities(plan.storageQuantities),
      'created_at': plan.createdAt.millisecondsSinceEpoch,
      'updated_at': plan.updatedAt.millisecondsSinceEpoch,
    };
  }

  BaseCalculatorPlan _fromMap(Map<String, dynamic> map) {
    return BaseCalculatorPlan(
      id: map['id'] as String,
      characterId: map['character_id'] as String?,
      baseId: map['base_id'] as String?,
      name: map['name'] as String,
      deepDesertDiscountEnabled:
          (map['deep_desert_discount_enabled'] as int? ?? 0) == 1,
      itemQuantities: BaseCalculatorPlan.decodeQuantities(
          map['item_quantities'] as String?),
      storageQuantities: BaseCalculatorPlan.decodeQuantities(
        map['storage_quantities'] as String?,
      ),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int? ?? 0),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int? ?? 0),
    );
  }
}
