import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/blueprint.dart';

class BlueprintRepository {
  final AppDatabase _database;

  BlueprintRepository(this._database);

  Future<List<Blueprint>> getAll() async {
    final db = await _database.database;
    final maps = await db.query(
      'blueprints',
      orderBy: 'region ASC, is_unlocked ASC, updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<List<Blueprint>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'blueprints',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'region ASC, is_unlocked ASC, updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<List<Blueprint>> getByCharacterAndRegion(
    String characterId,
    String region,
  ) async {
    final db = await _database.database;
    final maps = await db.query(
      'blueprints',
      where: 'character_id = ? AND region = ?',
      whereArgs: [characterId, region],
      orderBy: 'is_unlocked ASC, category ASC, name ASC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> upsert(Blueprint blueprint) async {
    final db = await _database.database;
    await db.insert(
      'blueprints',
      _toMap(blueprint),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete('blueprints', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(Blueprint blueprint) {
    return {
      'id': blueprint.id,
      'character_id': blueprint.characterId,
      'name': blueprint.name,
      'category': blueprint.category,
      'region': blueprint.region,
      'source_type': blueprint.sourceType,
      'source_location': blueprint.sourceLocation,
      'required_materials': jsonEncode(blueprint.requiredMaterials),
      'notes': blueprint.notes,
      'is_unlocked': blueprint.isUnlocked ? 1 : 0,
      'unlocked_at': blueprint.unlockedAt?.millisecondsSinceEpoch,
      'quest_id': blueprint.questId,
      'map_pin_id': blueprint.mapPinId,
      'created_at': blueprint.createdAt.millisecondsSinceEpoch,
      'updated_at': blueprint.updatedAt.millisecondsSinceEpoch,
    };
  }

  Blueprint _fromMap(Map<String, dynamic> map) {
    return Blueprint(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      name: map['name'] as String,
      category: map['category'] as String? ?? 'Other',
      region: map['region'] as String? ?? Blueprint.defaultRegion,
      sourceType: map['source_type'] as String?,
      sourceLocation: map['source_location'] as String?,
      requiredMaterials: _decodeMaterials(map['required_materials'] as String?),
      notes: map['notes'] as String?,
      isUnlocked: (map['is_unlocked'] as int? ?? 0) == 1,
      unlockedAt: map['unlocked_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['unlocked_at'] as int),
      questId: map['quest_id'] as String?,
      mapPinId: map['map_pin_id'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  List<String> _decodeMaterials(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList();
  }
}
