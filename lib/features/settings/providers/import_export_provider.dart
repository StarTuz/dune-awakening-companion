import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/export_service.dart';
import '../services/import_service.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  final characterRepo = ref.watch(characterRepositoryProvider);
  final baseRepo = ref.watch(baseRepositoryProvider);
  return ExportService(characterRepo, baseRepo);
});

final importServiceProvider = Provider<ImportService>((ref) {
  final characterRepo = ref.watch(characterRepositoryProvider);
  final baseRepo = ref.watch(baseRepositoryProvider);
  return ImportService(characterRepo, baseRepo);
});
