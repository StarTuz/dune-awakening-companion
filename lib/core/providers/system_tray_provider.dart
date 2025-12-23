import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/system_tray_service.dart';

/// Provider for SystemTrayService singleton
final systemTrayServiceProvider = Provider<SystemTrayService>((ref) {
  return SystemTrayService.instance;
});
