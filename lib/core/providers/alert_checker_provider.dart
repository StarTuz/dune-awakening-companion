import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/alert_checker_service.dart';
import '../../features/bases/providers/base_provider.dart';
import '../../features/characters/providers/character_provider.dart';

/// Provider for AlertCheckerService
final alertCheckerServiceProvider = Provider<AlertCheckerService>((ref) {
  final baseRepository = ref.watch(baseRepositoryProvider);
  final characterRepository = ref.watch(characterRepositoryProvider);
  return AlertCheckerService(baseRepository, characterRepository);
});

/// Provider for current alert count (critical only)
final criticalAlertCountProvider = FutureProvider<int>((ref) async {
  final alertChecker = ref.watch(alertCheckerServiceProvider);
  return await alertChecker.getCriticalAlertCount();
});
