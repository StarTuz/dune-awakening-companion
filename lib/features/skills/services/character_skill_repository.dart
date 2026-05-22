import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/character_skill.dart';

class CharacterSkillRepository {
  final AppDatabase _database;

  CharacterSkillRepository(this._database);

  Future<List<CharacterSkill>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'character_skills',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> upsert(CharacterSkill skill) async {
    final db = await _database.database;
    await db.insert(
      'character_skills',
      _toMap(skill),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete('character_skills', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(CharacterSkill skill) {
    return {
      'id': skill.id,
      'character_id': skill.characterId,
      'skill_id': skill.skillId,
      'current_rank': skill.currentRank,
      'target_rank': skill.targetRank,
      'is_equipped': skill.isEquipped ? 1 : 0,
      'updated_at': skill.updatedAt.millisecondsSinceEpoch,
    };
  }

  CharacterSkill _fromMap(Map<String, dynamic> map) {
    return CharacterSkill(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      skillId: map['skill_id'] as String,
      currentRank: map['current_rank'] as int? ?? 0,
      targetRank: map['target_rank'] as int?,
      isEquipped: (map['is_equipped'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
