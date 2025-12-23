import '../../../core/database/app_database.dart';
import '../models/character.dart';

class CharacterRepository {
  final AppDatabase _database;

  CharacterRepository(this._database);

  Future<List<Character>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('characters', orderBy: 'created_at DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<Character?> getById(String id) async {
    final db = await _database.database;
    final maps = await db.query(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<List<Character>> getByServerId(String serverId) async {
    final db = await _database.database;
    final maps = await db.query(
      'characters',
      where: 'server_id = ?',
      whereArgs: [serverId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<String> create(Character character) async {
    final db = await _database.database;
    await db.insert('characters', _toMap(character));
    return character.id;
  }

  Future<void> update(Character character) async {
    final db = await _database.database;
    await db.update(
      'characters',
      _toMap(character),
      where: 'id = ?',
      whereArgs: [character.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Character character) {
    return {
      'id': character.id,
      'name': character.name,
      'region': character.region,
      'server_type': character.serverType,
      'provider': character.provider,
      'world': character.world,
      'sietch': character.sietch,
      'portraitPath': character.portraitPath,
      'created_at': character.createdAt.millisecondsSinceEpoch,
      'updated_at': character.updatedAt.millisecondsSinceEpoch,
    };
  }

  Character _fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as String,
      name: map['name'] as String,
      region: map['region'] as String,
      serverType: map['server_type'] as String,
      provider: map['provider'] as String?,
      world: map['world'] as String,
      sietch: map['sietch'] as String,
      portraitPath: map['portraitPath'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
