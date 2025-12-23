import '../../../core/database/app_database.dart';
import '../models/base.dart';

class BaseRepository {
  final AppDatabase _database;

  BaseRepository(this._database);

  Future<List<Base>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('bases', orderBy: 'created_at DESC');
    return maps.map((map) => _fromMap(map)).toList();
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
    return maps.map((map) => _fromMap(map)).toList();
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
    return maps.map((map) => _fromMap(map)).toList();
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
      'created_at': base.createdAt.millisecondsSinceEpoch,
      'updated_at': base.updatedAt.millisecondsSinceEpoch,
      'is_advanced_fief': base.isAdvancedFief ? 1 : 0,
      'tax_per_cycle': base.taxPerCycle,
      'next_tax_due_date': base.nextTaxDueDate?.millisecondsSinceEpoch,
      'current_owed': base.currentOwed,
      'overdue_owed': base.overdueOwed,
      'defaulted_owed': base.defaultedOwed,
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
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] as int,
      ),
      isAdvancedFief: (map['is_advanced_fief'] as int?) == 1,
      taxPerCycle: map['tax_per_cycle'] as int?,
      nextTaxDueDate: map['next_tax_due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['next_tax_due_date'] as int)
          : null,
      currentOwed: map['current_owed'] as int?,
      overdueOwed: map['overdue_owed'] as int?,
      defaultedOwed: map['defaulted_owed'] as int?,
    );
  }
}
