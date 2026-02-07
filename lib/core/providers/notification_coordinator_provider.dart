import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_coordinator.dart';
import './notification_provider.dart';
import './alert_checker_provider.dart';
import '../repositories/notification_history_repository.dart';

/// Provider for NotificationCoordinator
final notificationCoordinatorProvider =
    Provider<NotificationCoordinator>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final alertCheckerService = ref.watch(alertCheckerServiceProvider);
  final historyRepository = NotificationHistoryRepository.instance;

  final coordinator = NotificationCoordinator(
    notificationService,
    alertCheckerService,
    historyRepository,
  );

  // Clean up when provider is disposed
  ref.onDispose(coordinator.dispose);

  return coordinator;
});
