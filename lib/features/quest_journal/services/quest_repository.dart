import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/quest.dart';
import '../models/quest_step.dart';

class QuestRepository {
  final AppDatabase _database;

  QuestRepository(this._database);

  Future<List<Quest>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('quests', orderBy: 'updated_at DESC');
    return maps.map(_questFromMap).toList();
  }

  Future<List<Quest>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'quests',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
    );
    return maps.map(_questFromMap).toList();
  }

  Future<List<QuestStep>> getSteps(String questId) async {
    final db = await _database.database;
    final maps = await db.query(
      'quest_steps',
      where: 'quest_id = ?',
      whereArgs: [questId],
      orderBy: 'sort_order ASC, created_at ASC',
    );
    return maps.map(_stepFromMap).toList();
  }

  Future<void> upsertQuest(Quest quest) async {
    final db = await _database.database;
    await db.insert(
      'quests',
      _questToMap(quest),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertStep(QuestStep step) async {
    final db = await _database.database;
    await db.insert(
      'quest_steps',
      _stepToMap(step),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteQuest(String id) async {
    final db = await _database.database;
    await db.delete('quests', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteStep(String id) async {
    final db = await _database.database;
    await db.delete('quest_steps', where: 'id = ?', whereArgs: [id]);
  }

  /// Updates [sort_order] for each step to match list order (0..n-1).
  Future<void> updateStepsSortOrder(List<QuestStep> stepsInOrder) async {
    final db = await _database.database;
    await db.transaction((txn) async {
      for (var i = 0; i < stepsInOrder.length; i++) {
        await txn.update(
          'quest_steps',
          {'sort_order': i},
          where: 'id = ?',
          whereArgs: [stepsInOrder[i].id],
        );
      }
    });
  }

  Map<String, dynamic> _questToMap(Quest quest) {
    return {
      'id': quest.id,
      'character_id': quest.characterId,
      'title': quest.title,
      'description': quest.description,
      'notes': quest.notes,
      'status': quest.status,
      'quest_type': quest.questType,
      'mission_type': quest.missionType,
      'is_landsraad_contract': quest.isLandsraadContract ? 1 : 0,
      'is_repeatable': quest.isRepeatable ? 1 : 0,
      'specialization_xp_gained': quest.specializationXpGained,
      'reminder_at': quest.reminderAt?.millisecondsSinceEpoch,
      'created_at': quest.createdAt.millisecondsSinceEpoch,
      'updated_at': quest.updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> _stepToMap(QuestStep step) {
    return {
      'id': step.id,
      'quest_id': step.questId,
      'title': step.title,
      'notes': step.notes,
      'sort_order': step.sortOrder,
      'is_completed': step.isCompleted ? 1 : 0,
      'completed_at': step.completedAt?.millisecondsSinceEpoch,
      'created_at': step.createdAt.millisecondsSinceEpoch,
    };
  }

  Quest _questFromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      notes: map['notes'] as String?,
      status: map['status'] as String? ?? 'active',
      questType: map['quest_type'] as String? ?? 'general',
      missionType: map['mission_type'] as String?,
      isLandsraadContract: (map['is_landsraad_contract'] as int? ?? 0) == 1,
      isRepeatable: (map['is_repeatable'] as int? ?? 0) == 1,
      specializationXpGained: map['specialization_xp_gained'] as int?,
      reminderAt: map['reminder_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['reminder_at'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  QuestStep _stepFromMap(Map<String, dynamic> map) {
    return QuestStep(
      id: map['id'] as String,
      questId: map['quest_id'] as String,
      title: map['title'] as String,
      notes: map['notes'] as String?,
      sortOrder: map['sort_order'] as int? ?? 0,
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      completedAt: map['completed_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}
