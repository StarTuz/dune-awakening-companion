import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/class_quest_progress.dart';

class ClassQuestRepository {
  final AppDatabase _database;

  ClassQuestRepository(this._database);

  Future<List<ClassQuestProgress>> getAllProgress() async {
    final db = await _database.database;
    final maps = await db.query(
      'character_class_quests',
      orderBy: 'updated_at DESC',
    );
    return maps.map(_progressFromMap).toList();
  }

  Future<List<ClassQuestProgress>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'character_class_quests',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
    );
    return maps.map(_progressFromMap).toList();
  }

  Future<ClassQuestProgress?> getByCharacterAndQuest(
    String characterId,
    String questId,
  ) async {
    final db = await _database.database;
    final maps = await db.query(
      'character_class_quests',
      where: 'character_id = ? AND quest_id = ?',
      whereArgs: [characterId, questId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _progressFromMap(maps.first);
  }

  Future<void> upsertProgress(ClassQuestProgress progress) async {
    final db = await _database.database;
    await db.insert(
      'character_class_quests',
      _progressToMap(progress),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ClassQuestStepProgress>> getSteps(String progressId) async {
    final db = await _database.database;
    final maps = await db.query(
      'character_class_quest_steps',
      where: 'class_quest_progress_id = ?',
      whereArgs: [progressId],
    );
    return maps.map(_stepFromMap).toList();
  }

  Future<List<ClassQuestStepProgress>> getAllSteps() async {
    final db = await _database.database;
    final maps = await db.query('character_class_quest_steps');
    return maps.map(_stepFromMap).toList();
  }

  Future<void> upsertStep(ClassQuestStepProgress step) async {
    final db = await _database.database;
    await db.insert(
      'character_class_quest_steps',
      _stepToMap(step),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> _progressToMap(ClassQuestProgress progress) {
    return {
      'id': progress.id,
      'character_id': progress.characterId,
      'quest_id': progress.questId,
      'status': progress.status,
      'notes': progress.notes,
      'started_at': progress.startedAt?.millisecondsSinceEpoch,
      'completed_at': progress.completedAt?.millisecondsSinceEpoch,
      'updated_at': progress.updatedAt.millisecondsSinceEpoch,
    };
  }

  ClassQuestProgress _progressFromMap(Map<String, dynamic> map) {
    return ClassQuestProgress(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      questId: map['quest_id'] as String,
      status: map['status'] as String? ?? ClassQuestStatus.notStarted,
      notes: map['notes'] as String?,
      startedAt: map['started_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int),
      completedAt: map['completed_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  Map<String, dynamic> _stepToMap(ClassQuestStepProgress step) {
    return {
      'id': step.id,
      'class_quest_progress_id': step.classQuestProgressId,
      'step_id': step.stepId,
      'is_completed': step.isCompleted ? 1 : 0,
      'completed_at': step.completedAt?.millisecondsSinceEpoch,
    };
  }

  ClassQuestStepProgress _stepFromMap(Map<String, dynamic> map) {
    return ClassQuestStepProgress(
      id: map['id'] as String,
      classQuestProgressId: map['class_quest_progress_id'] as String,
      stepId: map['step_id'] as String,
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      completedAt: map['completed_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int),
    );
  }
}
