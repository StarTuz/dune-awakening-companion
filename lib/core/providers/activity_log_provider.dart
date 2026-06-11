import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/activity_event.dart';
import '../repositories/activity_log_repository.dart';

final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  return ActivityLogRepository(AppDatabase.instance);
});

final recentActivityProvider = FutureProvider<List<ActivityEvent>>((ref) async {
  final repository = ref.watch(activityLogRepositoryProvider);
  return repository.getRecent();
});

final activityLoggerProvider = Provider<ActivityLogger>((ref) {
  return ActivityLogger(ref.watch(activityLogRepositoryProvider), ref);
});

/// Records an app action and refreshes the dashboard feed.
///
/// Failures are swallowed on purpose: the activity log is decoration and
/// must never break the action being logged.
class ActivityLogger {
  ActivityLogger(this._repository, this._ref);

  final ActivityLogRepository _repository;
  final Ref _ref;

  Future<void> log(
    ActivityEventType type,
    String subject, {
    String? characterName,
  }) async {
    try {
      await _repository.log(type, subject, characterName: characterName);
      _ref.invalidate(recentActivityProvider);
    } catch (_) {
      // Non-fatal by design.
    }
  }
}
