import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/faction_progress.dart';

class FactionProgressRepository {
  final AppDatabase _database;

  FactionProgressRepository(this._database);

  Future<List<FactionProgress>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'faction_progress',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> upsert(FactionProgress progress) async {
    final db = await _database.database;
    await db.insert(
      'faction_progress',
      _toMap(progress),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete('faction_progress', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(FactionProgress progress) {
    return {
      'id': progress.id,
      'character_id': progress.characterId,
      'faction_name': progress.factionName,
      'current_rank': progress.currentRank,
      'reputation_points': progress.reputationPoints,
      'contracts_completed': progress.contractsCompleted,
      'updated_at': progress.updatedAt.millisecondsSinceEpoch,
    };
  }

  FactionProgress _fromMap(Map<String, dynamic> map) {
    return FactionProgress(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      factionName: map['faction_name'] as String,
      currentRank: map['current_rank'] as int? ?? 1,
      reputationPoints: map['reputation_points'] as int?,
      contractsCompleted: map['contracts_completed'] as int? ?? 0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
