import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/field_timer_session.dart';
import '../services/field_timer_audio_service.dart';
import '../services/field_timer_notification_service.dart';
import '../services/field_timer_os_alarm_service.dart';
import '../services/field_timer_service.dart';

final fieldTimerAudioServiceProvider = Provider<FieldTimerAudioService>((ref) {
  final service = FieldTimerAudioService();
  ref.onDispose(service.dispose);
  service.initialize();
  return service;
});

final fieldTimerNotificationServiceProvider =
    Provider<FieldTimerNotificationService>((ref) {
  final service = FieldTimerNotificationService();
  service.initialize();
  return service;
});

final fieldTimerOsAlarmServiceProvider =
    Provider<FieldTimerOsAlarmService>((ref) {
  final service = FieldTimerOsAlarmService();
  service.initialize();
  return service;
});

final fieldTimerProvider =
    StateNotifierProvider<FieldTimerService, FieldTimerSession>((ref) {
  final audio = ref.watch(fieldTimerAudioServiceProvider);
  final notifications = ref.watch(fieldTimerNotificationServiceProvider);
  final osAlarms = ref.watch(fieldTimerOsAlarmServiceProvider);
  return FieldTimerService(audio, notifications, osAlarms);
});
