import '../database/app_database.dart';
import '../models/notification_history_entry.dart';

/// Repository for notification history operations
class NotificationHistoryRepository {
  static final NotificationHistoryRepository instance = 
      NotificationHistoryRepository._internal();

  NotificationHistoryRepository._internal();

  /// Add a notification to history
  Future<int> addEntry(NotificationHistoryEntry entry) async {
    final db = await AppDatabase.instance.database;
    final map = entry.toMap();
    map.remove('id'); // Let SQLite auto-generate
    return await db.insert('notification_history', map);
  }

  /// Get all notifications, most recent first
  Future<List<NotificationHistoryEntry>> getAll({int limit = 50}) async {
    final db = await AppDatabase.instance.database;
    final results = await db.query(
      'notification_history',
      orderBy: 'sent_at DESC',
      limit: limit,
    );
    return results.map((row) => NotificationHistoryEntry.fromMap(row)).toList();
  }

  /// Get unread notifications
  Future<List<NotificationHistoryEntry>> getUnread() async {
    final db = await AppDatabase.instance.database;
    final results = await db.query(
      'notification_history',
      where: 'read = ?',
      whereArgs: [0],
      orderBy: 'sent_at DESC',
    );
    return results.map((row) => NotificationHistoryEntry.fromMap(row)).toList();
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notification_history WHERE read = 0'
    );
    return result.first['count'] as int;
  }

  /// Mark a notification as read
  Future<void> markAsRead(int id) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'notification_history',
      {'read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final db = await AppDatabase.instance.database;
    await db.update('notification_history', {'read': 1});
  }

  /// Delete old notifications (keep last N days)
  Future<int> deleteOlderThan(int days) async {
    final db = await AppDatabase.instance.database;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return await db.delete(
      'notification_history',
      where: 'sent_at < ?',
      whereArgs: [cutoff.toIso8601String()],
    );
  }

  /// Clear all history
  Future<void> clearAll() async {
    final db = await AppDatabase.instance.database;
    await db.delete('notification_history');
  }
}
