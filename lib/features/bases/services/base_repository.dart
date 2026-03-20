import '../../../core/database/app_database.dart';
import '../models/base.dart';

class BaseRepository {
  final AppDatabase _database;

  BaseRepository(this._database);

  Future<List<Base>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('bases', orderBy: 'created_at DESC');
    return maps.map(_fromMap).toList();
  }

  Future<Base?> getById(String id) async {
    final db = await _database.database;
    final maps = await db.query(
      'bases',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<List<Base>> getByCharacterId(String characterId) async {
    final db = await _database.database;
    final maps = await db.query(
      'bases',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'power_expiration_time ASC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<List<Base>> getExpiringSoon() async {
    final db = await _database.database;
    final now = DateTime.now();
    final threshold = now.add(const Duration(hours: 24));
    final maps = await db.query(
      'bases',
      where: 'power_expiration_time <= ? AND power_expiration_time > ?',
      whereArgs: [
        threshold.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      ],
      orderBy: 'power_expiration_time ASC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<String> create(Base base) async {
    final db = await _database.database;
    await db.insert('bases', _toMap(base));
    return base.id;
  }

  Future<void> update(Base base) async {
    final db = await _database.database;
    await db.update(
      'bases',
      _toMap(base),
      where: 'id = ?',
      whereArgs: [base.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      'bases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Base base) {
    return {
      'id': base.id,
      'character_id': base.characterId,
      'name': base.name,
      'power_expiration_time': base.powerExpirationTime.millisecondsSinceEpoch,
      'notifications_enabled': base.notificationsEnabled ? 1 : 0,
      'warning_threshold_hours': base.warningThresholdHours,
      'critical_threshold_hours': base.criticalThresholdHours,
      'created_at': base.createdAt.millisecondsSinceEpoch,
      'updated_at': base.updatedAt.millisecondsSinceEpoch,
    };
  }

  Base _fromMap(Map<String, dynamic> map) {
    return Base(
      id: map['id'] as String,
      characterId: map['character_id'] as String,
      name: map['name'] as String,
      powerExpirationTime: DateTime.fromMillisecondsSinceEpoch(
        map['power_expiration_time'] as int,
      ),
      notificationsEnabled: (map['notifications_enabled'] as int? ?? 1) == 1,
      warningThresholdHours: map['warning_threshold_hours'] as int?,
      criticalThresholdHours: map['critical_threshold_hours'] as int?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] as int,
      ),
    );
  }
}
