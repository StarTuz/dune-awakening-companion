import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../core/services/notification_service.dart';
import '../models/quest.dart';
import 'quest_repository.dart';

/// Syncs optional quest reminders with the OS scheduler and handles due
/// reminders when the app runs (desktop and fallback).
class QuestReminderService {
  QuestReminderService({NotificationService? notificationService})
      : _notifications = notificationService ?? NotificationService.instance;

  final NotificationService _notifications;

  static int notificationIdForQuest(String questId) {
    final h = questId.hashCode & 0x7fffffff;
    return h == 0 ? 1 : h;
  }

  Future<void> syncAfterQuestSave(Quest quest) async {
    final id = notificationIdForQuest(quest.id);
    await _notifications.cancelNotification(id);

    if (!_notifications.notificationsEnabled) return;

    final r = quest.reminderAt;
    if (r == null || !r.isAfter(DateTime.now())) return;

    if (Platform.isAndroid || Platform.isIOS) {
      await _notifications.scheduleQuestReminder(
        id: id,
        questTitle: quest.title,
        scheduledTime: r,
      );
    }
  }

  Future<void> cancelForQuest(String questId) async {
    await _notifications.cancelNotification(notificationIdForQuest(questId));
  }

  /// Shows notifications for overdue reminders and clears them in the DB.
  Future<void> processDueReminders(QuestRepository repo) async {
    if (!_notifications.notificationsEnabled) return;
    final quests = await repo.getAll();
    final now = DateTime.now();
    for (final q in quests) {
      final rem = q.reminderAt;
      if (rem == null || rem.isAfter(now)) continue;

      try {
        await _notifications.showSimpleNotification(
          title: 'Quest reminder',
          message: q.title,
        );
      } catch (e) {
        debugPrint('[QuestReminders] show due: $e');
      }

      await repo.upsertQuest(
        q.copyWith(reminderAt: null, updatedAt: DateTime.now()),
      );
      await cancelForQuest(q.id);
    }
  }

  /// Re-register future OS schedules (e.g. after reboot).
  Future<void> resyncAllScheduled(QuestRepository repo) async {
    if (!_notifications.notificationsEnabled) return;
    final quests = await repo.getAll();
    final now = DateTime.now();
    for (final q in quests) {
      await cancelForQuest(q.id);
      final r = q.reminderAt;
      if (r != null && r.isAfter(now)) {
        await syncAfterQuestSave(q);
      }
    }
  }
}
