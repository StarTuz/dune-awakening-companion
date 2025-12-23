import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_manager.dart';
import './notification_provider.dart';
import './notification_coordinator_provider.dart';

/// Provider for NotificationManager
final notificationManagerProvider = Provider<NotificationManager>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final coordinator = ref.watch(notificationCoordinatorProvider);

  final manager = NotificationManager(notificationService, coordinator);

  // Clean up when provider is disposed
  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});
