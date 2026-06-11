import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../models/activity_event.dart';

class ActivityLogRepository {
  ActivityLogRepository(this._database);

  final AppDatabase _database;

  /// Cap kept low: the feed only ever shows a handful of rows, and pruning
  /// on every insert keeps the table from growing unbounded.
  static const _maxEvents = 50;

  Future<List<ActivityEvent>> getRecent({int limit = 5}) async {
    final db = await _database.database;
    final maps = await db.query(
      'activity_events',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> log(
    ActivityEventType type,
    String subject, {
    String? characterName,
  }) async {
    final db = await _database.database;
    await db.insert('activity_events', {
      'id': const Uuid().v4(),
      'type': type.name,
      'subject': subject,
      'character_name': characterName,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
    await db.delete(
      'activity_events',
      where: 'id NOT IN (SELECT id FROM activity_events '
          'ORDER BY created_at DESC LIMIT ?)',
      whereArgs: [_maxEvents],
    );
  }

  ActivityEvent _fromMap(Map<String, dynamic> map) => ActivityEvent(
        id: map['id'] as String,
        type: ActivityEventType.fromName(map['type'] as String),
        subject: map['subject'] as String,
        characterName: map['character_name'] as String?,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );
}
