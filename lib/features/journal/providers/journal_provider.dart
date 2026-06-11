import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/activity_event.dart';
import '../../../core/providers/activity_log_provider.dart';
import '../../characters/providers/character_provider.dart';
import '../models/journal_entry.dart';
import '../services/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(AppDatabase.instance);
});

final characterJournalProvider =
    FutureProvider.family<List<JournalEntry>, String>((ref, characterId) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getByCharacterId(characterId);
});

final recentJournalEntriesProvider =
    FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getRecent();
});

final journalEditorProvider = Provider((ref) {
  return JournalEditor(ref.watch(journalRepositoryProvider), ref);
});

class JournalEditor {
  final JournalRepository _repository;
  final Ref _ref;

  JournalEditor(this._repository, this._ref);

  Future<void> save(JournalEntry entry) async {
    await _repository.upsert(entry.copyWith(updatedAt: DateTime.now()));
    _ref.invalidate(characterJournalProvider(entry.characterId));
    _ref.invalidate(recentJournalEntriesProvider);
    String? characterName;
    final characters = _ref.read(charactersProvider).value;
    if (characters != null) {
      for (final c in characters) {
        if (c.id == entry.characterId) {
          characterName = c.name;
          break;
        }
      }
    }
    await _ref.read(activityLoggerProvider).log(
          ActivityEventType.journalEntryWritten,
          entry.title,
          characterName: characterName,
        );
  }

  Future<void> delete(String id, String characterId) async {
    await _repository.delete(id);
    _ref.invalidate(characterJournalProvider(characterId));
    _ref.invalidate(recentJournalEntriesProvider);
  }
}
