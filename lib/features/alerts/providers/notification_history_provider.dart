import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/notification_history_repository.dart';
import '../../../core/models/notification_history_entry.dart';

/// State for notification history
class NotificationHistoryState {
  final List<NotificationHistoryEntry> entries;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationHistoryState({
    this.entries = const [],
    this.unreadCount = 0,
    this.isLoading = true,
    this.error,
  });

  NotificationHistoryState copyWith({
    List<NotificationHistoryEntry>? entries,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationHistoryState(
      entries: entries ?? this.entries,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for notification history
class NotificationHistoryNotifier extends StateNotifier<NotificationHistoryState> {
  final NotificationHistoryRepository _repository = 
      NotificationHistoryRepository.instance;

  NotificationHistoryNotifier() : super(const NotificationHistoryState()) {
    loadHistory();
  }

  /// Load notification history
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final entries = await _repository.getAll(limit: 100);
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(
        entries: entries,
        unreadCount: unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Mark a single notification as read
  Future<void> markAsRead(int id) async {
    await _repository.markAsRead(id);
    await loadHistory();
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    await loadHistory();
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _repository.clearAll();
    await loadHistory();
  }

  /// Delete old entries
  Future<void> deleteOlderThan(int days) async {
    await _repository.deleteOlderThan(days);
    await loadHistory();
  }
}

/// Provider for notification history
final notificationHistoryProvider = 
    StateNotifierProvider<NotificationHistoryNotifier, NotificationHistoryState>((ref) {
  return NotificationHistoryNotifier();
});
