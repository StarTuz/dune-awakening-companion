import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../models/alert.dart';
import '../models/alert_settings.dart';

class AlertRepository {
  final AppDatabase _database;

  AlertRepository(this._database);

  Future<List<Alert>> getAll() async {
    final db = await _database.database;
    final maps = await db.query('alerts', orderBy: 'created_at DESC');
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<Alert?> getById(String id) async {
    final db = await _database.database;
    final maps = await db.query(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<List<Alert>> getByBaseId(String baseId) async {
    final db = await _database.database;
    final maps = await db.query(
      'alerts',
      where: 'base_id = ?',
      whereArgs: [baseId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<List<Alert>> getActive() async {
    final db = await _database.database;
    final maps = await db.query(
      'alerts',
      where: 'acknowledged_at IS NULL AND dismissed_at IS NULL',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<String> create(Alert alert) async {
    final db = await _database.database;
    await db.insert('alerts', _toMap(alert));
    return alert.id;
  }

  Future<void> update(Alert alert) async {
    final db = await _database.database;
    await db.update(
      'alerts',
      _toMap(alert),
      where: 'id = ?',
      whereArgs: [alert.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.database;
    await db.delete(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> acknowledge(String id) async {
    final db = await _database.database;
    await db.update(
      'alerts',
      {'acknowledged_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> dismiss(String id) async {
    final db = await _database.database;
    await db.update(
      'alerts',
      {'dismissed_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Alert alert) {
    return {
      'id': alert.id,
      'base_id': alert.baseId,
      'threshold_hours': alert.thresholdHours,
      'created_at': alert.createdAt.millisecondsSinceEpoch,
      'acknowledged_at': alert.acknowledgedAt?.millisecondsSinceEpoch,
      'dismissed_at': alert.dismissedAt?.millisecondsSinceEpoch,
    };
  }

  Alert _fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'] as String,
      baseId: map['base_id'] as String,
      thresholdHours: map['threshold_hours'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      acknowledgedAt: map['acknowledged_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['acknowledged_at'] as int)
          : null,
      dismissedAt: map['dismissed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dismissed_at'] as int)
          : null,
    );
  }
}

class AlertSettingsRepository {
  final AppDatabase _database;

  AlertSettingsRepository(this._database);

  Future<AlertSettings> get() async {
    final db = await _database.database;
    final maps = await db.query(
      'alert_settings',
      where: 'id = ?',
      whereArgs: ['default'],
      limit: 1,
    );
    if (maps.isEmpty) {
      return AlertSettings();
    }
    return _fromMap(maps.first);
  }

  Future<void> update(AlertSettings settings) async {
    final db = await _database.database;
    await db.update(
      'alert_settings',
      _toMap(settings),
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }

  Map<String, dynamic> _toMap(AlertSettings settings) {
    return {
      'id': 'default',
      'warning_thresholds': jsonEncode(settings.warningThresholds),
      'check_interval_minutes': settings.checkIntervalMinutes,
      'repeat_interval_minutes': settings.repeatIntervalMinutes,
      'enable_sound': settings.enableSound ? 1 : 0,
      'enable_notifications': settings.enableNotifications ? 1 : 0,
      'minimize_to_tray': settings.minimizeToTray ? 1 : 0,
    };
  }

  AlertSettings _fromMap(Map<String, dynamic> map) {
    return AlertSettings(
      warningThresholds: List<int>.from(
        jsonDecode(map['warning_thresholds'] as String),
      ),
      checkIntervalMinutes: map['check_interval_minutes'] as int,
      repeatIntervalMinutes: map['repeat_interval_minutes'] as int,
      enableSound: (map['enable_sound'] as int) == 1,
      enableNotifications: (map['enable_notifications'] as int) == 1,
      minimizeToTray: (map['minimize_to_tray'] as int) == 1,
    );
  }
}
