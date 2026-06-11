import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/models/activity_event.dart';
import 'package:dune_awakening_companion/core/providers/activity_log_provider.dart';
import 'package:dune_awakening_companion/core/repositories/activity_log_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/dashboard/screens/dashboard_screen.dart';
import 'package:dune_awakening_companion/features/journal/models/journal_entry.dart';
import 'package:dune_awakening_companion/features/journal/providers/journal_provider.dart';
import 'package:dune_awakening_companion/features/journal/services/journal_repository.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// End-to-end: a user action goes through the real notifier, which logs an
// activity event, which appears on the dashboard without a manual refresh.
// ---------------------------------------------------------------------------

class FakeCharacterRepository implements CharacterRepository {
  final List<Character> data;
  FakeCharacterRepository([this.data = const []]);

  @override
  Future<List<Character>> getAll() async => data;
  @override
  Future<Character?> getById(String id) async => data
      .cast<Character?>()
      .firstWhere((c) => c?.id == id, orElse: () => null);
  @override
  Future<List<Character>> getByServerId(String serverId) async => [];
  @override
  Future<String> create(Character character) async => character.id;
  @override
  Future<void> update(Character character) async {}
  @override
  Future<void> delete(String id) async {}
}

class FakeBaseRepository implements BaseRepository {
  @override
  Future<List<Base>> getAll() async => [];
  @override
  Future<Base?> getById(String id) async => null;
  @override
  Future<List<Base>> getByCharacterId(String characterId) async => [];
  @override
  Future<List<Base>> getExpiringSoon() async => [];
  @override
  Future<String> create(Base base) async => base.id;
  @override
  Future<void> update(Base base) async {}
  @override
  Future<void> delete(String id) async {}
}

class FakeJournalRepository implements JournalRepository {
  @override
  Future<List<JournalEntry>> getByCharacterId(String characterId) async => [];
  @override
  Future<List<JournalEntry>> getRecent({int limit = 5}) async => [];
  @override
  Future<void> upsert(JournalEntry entry) async {}
  @override
  Future<void> delete(String id) async {}
}

/// In-memory store so logged events really come back from getRecent.
class MutableActivityLogRepository implements ActivityLogRepository {
  final List<ActivityEvent> store = [];

  @override
  Future<List<ActivityEvent>> getRecent({int limit = 5}) async =>
      store.take(limit).toList();

  @override
  Future<void> log(ActivityEventType type, String subject,
      {String? characterName}) async {
    store.insert(
      0,
      ActivityEvent(
        id: 'e${store.length}',
        type: type,
        subject: subject,
        characterName: characterName,
        createdAt: DateTime.now(),
      ),
    );
  }
}

void main() {
  final now = DateTime.now();

  final paul = Character(
    id: 'c1',
    name: 'Paul',
    region: 'NA',
    serverType: 'Official',
    world: 'Arrakis',
    sietch: 'Tabr',
    createdAt: now,
    updatedAt: now,
  );

  Widget buildDashboard() {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider
            .overrideWithValue(FakeCharacterRepository([paul])),
        baseRepositoryProvider.overrideWithValue(FakeBaseRepository()),
        journalRepositoryProvider.overrideWithValue(FakeJournalRepository()),
        activityLogRepositoryProvider
            .overrideWithValue(MutableActivityLogRepository()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DashboardScreen(),
      ),
    );
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(DashboardScreen)));

  testWidgets('saving a Chronicle entry surfaces it in Recent Activity',
      (tester) async {
    await tester.pumpWidget(buildDashboard());
    await tester.pumpAndSettle();

    await containerOf(tester).read(journalEditorProvider).save(JournalEntry(
          id: 'j1',
          characterId: 'c1',
          title: 'Found a spice field',
          body: '',
          tags: const [],
          entryDate: now,
          createdAt: now,
          updatedAt: now,
        ));
    await tester.pumpAndSettle();

    expect(find.text('Chronicle: Found a spice field'), findsOneWidget);
    expect(find.textContaining('Paul •'), findsOneWidget);
  });

  testWidgets('creating a character surfaces it in Recent Activity',
      (tester) async {
    await tester.pumpWidget(buildDashboard());
    await tester.pumpAndSettle();

    await containerOf(tester).read(charactersProvider.notifier).createCharacter(
        'Chani', 'NA', 'Official', null, 'Arrakis', 'Tabr', null);
    await tester.pumpAndSettle();

    expect(find.text('Created character Chani'), findsOneWidget);
  });

  testWidgets('creating a base surfaces it with the owner character name',
      (tester) async {
    await tester.pumpWidget(buildDashboard());
    await tester.pumpAndSettle();

    await containerOf(tester)
        .read(basesProvider.notifier)
        .createBase('c1', 'Sietch Camp', now.add(const Duration(hours: 72)));
    await tester.pumpAndSettle();

    expect(find.text('Added base Sietch Camp'), findsOneWidget);
    expect(find.textContaining('Paul •'), findsOneWidget);
  });
}
