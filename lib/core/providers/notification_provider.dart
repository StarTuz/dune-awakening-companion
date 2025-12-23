import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// Provider for the NotificationService singleton
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// Provider for notification enabled state
final notificationsEnabledProvider = StateProvider<bool>((ref) {
  return true; // Default enabled
});
