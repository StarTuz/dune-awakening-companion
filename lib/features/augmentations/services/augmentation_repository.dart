import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/augmentation.dart';

class AugmentationRepository {
  final AppDatabase _database;

  AugmentationRepository(this._database);

  Future<List<Augmentation>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'augmentations',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> upsert(Augmentation augmentation) async {
    final db = await _database.database;
    await db.insert(
      'augmentations',
      _toMap(augmentation),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete('augmentations', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(Augmentation augmentation) {
    return {
      'id': augmentation.id,
      'character_id': augmentation.characterId,
      'name': augmentation.name,
      'slot': augmentation.slot,
      'source_boss': augmentation.sourceBoss,
      'notes': augmentation.notes,
      'is_equipped': augmentation.isEquipped ? 1 : 0,
      'acquired_at': augmentation.acquiredAt?.millisecondsSinceEpoch,
      'updated_at': augmentation.updatedAt.millisecondsSinceEpoch,
    };
  }

  Augmentation _fromMap(Map<String, dynamic> map) {
    return Augmentation(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      name: map['name'] as String,
      slot: map['slot'] as String,
      sourceBoss: map['source_boss'] as String?,
      notes: map['notes'] as String?,
      isEquipped: (map['is_equipped'] as int? ?? 0) == 1,
      acquiredAt: map['acquired_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['acquired_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
