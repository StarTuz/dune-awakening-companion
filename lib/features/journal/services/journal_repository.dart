import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  final AppDatabase _database;

  JournalRepository(this._database);

  Future<List<JournalEntry>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'journal_entries',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'entry_date DESC, created_at DESC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> upsert(JournalEntry entry) async {
    final db = await _database.database;
    await db.insert(
      'journal_entries',
      _toMap(entry),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(JournalEntry entry) {
    return {
      'id': entry.id,
      'character_id': entry.characterId,
      'title': entry.title,
      'body': entry.body,
      'tags': _encodeTags(entry.tags),
      'entry_date': entry.entryDate.millisecondsSinceEpoch,
      'location': entry.location,
      'mood': entry.mood,
      'quest_id': entry.questId,
      'image_path': entry.imagePath,
      'created_at': entry.createdAt.millisecondsSinceEpoch,
      'updated_at': entry.updatedAt.millisecondsSinceEpoch,
    };
  }

  JournalEntry _fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      tags: _decodeTags(map['tags'] as String?),
      entryDate:
          DateTime.fromMillisecondsSinceEpoch(map['entry_date'] as int? ?? 0),
      location: map['location'] as String?,
      mood: map['mood'] as String?,
      questId: map['quest_id'] as String?,
      imagePath: map['image_path'] as String?,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int? ?? 0),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int? ?? 0),
    );
  }

  static String _encodeTags(List<String> tags) {
    return tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .join(',');
  }

  static List<String> _decodeTags(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
