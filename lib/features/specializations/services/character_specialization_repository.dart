import '../../../core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/character_specialization.dart';

class CharacterSpecializationRepository {
  final AppDatabase _database;

  CharacterSpecializationRepository(this._database);

  Future<List<CharacterSpecialization>> getAll() async {
    final db = await _database.database;
    final maps = await db.query(
      'character_specializations',
      orderBy: 'updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<CharacterSpecialization?> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'character_specializations',
      where: 'character_id = ?',
      whereArgs: [characterId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<void> upsert(CharacterSpecialization specialization) async {
    final db = await _database.database;
    await db.insert(
      'character_specializations',
      _toMap(specialization),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> _toMap(CharacterSpecialization specialization) {
    return {
      'id': specialization.id,
      'character_id': specialization.characterId,
      'combat_level': specialization.combatLevel,
      'crafting_level': specialization.craftingLevel,
      'gathering_level': specialization.gatheringLevel,
      'exploration_level': specialization.explorationLevel,
      'sabotage_level': specialization.sabotageLevel,
      'updated_at': specialization.updatedAt.millisecondsSinceEpoch,
    };
  }

  CharacterSpecialization _fromMap(Map<String, dynamic> map) {
    return CharacterSpecialization(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      combatLevel: map['combat_level'] as int? ?? 0,
      craftingLevel: map['crafting_level'] as int? ?? 0,
      gatheringLevel: map['gathering_level'] as int? ?? 0,
      explorationLevel: map['exploration_level'] as int? ?? 0,
      sabotageLevel: map['sabotage_level'] as int? ?? 0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
