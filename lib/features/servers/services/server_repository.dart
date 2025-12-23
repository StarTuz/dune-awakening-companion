import '../../../core/database/app_database.dart';
import '../models/server.dart';

class ServerRepository {
  final AppDatabase _database;

  ServerRepository(this._database);

  Future<List<Server>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('servers', orderBy: 'created_at DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<Server?> getById(String id) async {
    final db = await _database.database;
    final maps = await db.query(
      'servers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<String> create(Server server) async {
    final db = await _database.database;
    await db.insert('servers', _toMap(server));
    return server.id;
  }

  Future<void> update(Server server) async {
    final db = await _database.database;
    await db.update(
      'servers',
      _toMap(server),
      where: 'id = ?',
      whereArgs: [server.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      'servers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Server server) {
    return {
      'id': server.id,
      'name': server.name,
      'created_at': server.createdAt.millisecondsSinceEpoch,
    };
  }

  Server _fromMap(Map<String, dynamic> map) {
    return Server(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
    );
  }
}
