import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/journal/models/journal_entry.dart';
import 'package:dune_awakening_companion/features/journal/providers/journal_provider.dart';
import 'package:dune_awakening_companion/features/journal/screens/journal_hub_screen.dart';
import 'package:dune_awakening_companion/features/quest_journal/models/quest.dart';
import 'package:dune_awakening_companion/features/quest_journal/providers/quest_provider.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class _FakeCharacterRepo implements CharacterRepository {
  final List<Character> data;
  _FakeCharacterRepo([this.data = const []]);
  @override
  Future<List<Character>> getAll() async => data;
  @override
  Future<Character?> getById(String id) async => null;
  @override
  Future<List<Character>> getByServerId(String serverId) async => [];
  @override
  Future<String> create(Character c) async => c.id;
  @override
  Future<void> update(Character c) async {}
  @override
  Future<void> delete(String id) async {}
}

void main() {
  final now = DateTime.now();

  Character character(String id, String name) => Character(
        id: id,
        name: name,
        region: 'NA',
        serverType: 'Official',
        world: 'Arrakis',
        sietch: 'Tabr',
        createdAt: now,
        updatedAt: now,
      );

  Widget buildHub({List<Character> characters = const []}) {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider
            .overrideWithValue(_FakeCharacterRepo(characters)),
        questsProvider.overrideWith((ref) async => <Quest>[]),
        characterJournalProvider
            .overrideWith((ref, characterId) async => <JournalEntry>[]),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JournalHubScreen(),
      ),
    );
  }

  testWidgets('hub shows Quests and Chronicle tabs with Quests active first',
      (tester) async {
    await tester.pumpWidget(buildHub());
    await tester.pumpAndSettle();

    expect(find.text('Journal'), findsOneWidget); // hub title
    expect(find.text('Quests'), findsOneWidget);
    expect(find.text('Chronicle'), findsOneWidget);
  });

  testWidgets('Chronicle tab is one tap away and shows the journal',
      (tester) async {
    await tester.pumpWidget(buildHub(
      characters: [character('c1', 'Valeria Corrin')],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chronicle'));
    await tester.pumpAndSettle();

    // Character picker defaults to the first character, journal renders.
    expect(find.text('Valeria Corrin'), findsOneWidget);
    expect(find.text('Biography'), findsOneWidget);
  });

  testWidgets('Chronicle picker switches between characters', (tester) async {
    await tester.pumpWidget(buildHub(
      characters: [
        character('c1', 'Valeria Corrin'),
        character('c2', 'Duncan'),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chronicle'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Valeria Corrin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duncan').last);
    await tester.pumpAndSettle();

    expect(find.text('Duncan'), findsOneWidget);
    expect(find.text('Biography'), findsOneWidget);
  });

  testWidgets('Chronicle tab shows empty hint without characters',
      (tester) async {
    await tester.pumpWidget(buildHub());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chronicle'));
    await tester.pumpAndSettle();

    expect(find.text('No characters yet. Add one to get started.'),
        findsOneWidget);
  });
}
