import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/quest_journal/models/quest.dart';
import 'package:dune_awakening_companion/features/quest_journal/models/quest_step.dart';
import 'package:dune_awakening_companion/features/quest_journal/providers/quest_provider.dart';
import 'package:dune_awakening_companion/features/quest_journal/screens/quest_journal_screen.dart';
import 'package:dune_awakening_companion/features/quest_journal/services/quest_repository.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class _FakeCharacterRepo implements CharacterRepository {
  _FakeCharacterRepo(this.characters);

  final List<Character> characters;

  @override
  Future<String> create(Character character) async => character.id;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Character>> getAll() async => characters;

  @override
  Future<Character?> getById(String id) async => characters
      .cast<Character?>()
      .firstWhere((character) => character?.id == id, orElse: () => null);

  @override
  Future<List<Character>> getByServerId(String serverId) async => [];

  @override
  Future<void> update(Character character) async {}
}

class _FakeQuestRepo implements QuestRepository {
  _FakeQuestRepo(this.quests);

  final List<Quest> quests;

  @override
  Future<void> deleteQuest(String id) async {}

  @override
  Future<void> deleteStep(String id) async {}

  @override
  Future<List<Quest>> getAll() async => quests;

  @override
  Future<List<Quest>> getByCharacterId(String characterId) async =>
      quests.where((quest) => quest.characterId == characterId).toList();

  @override
  Future<List<QuestStep>> getSteps(String questId) async => [];

  @override
  Future<void> upsertQuest(Quest quest) async {}

  @override
  Future<void> upsertStep(QuestStep step) async {}

  @override
  Future<void> updateStepsSortOrder(List<QuestStep> stepsInOrder) async {}
}

void main() {
  final now = DateTime.now();

  Widget buildScreen({
    List<Character> characters = const [],
    List<Quest> quests = const [],
  }) {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider.overrideWithValue(
          _FakeCharacterRepo(characters),
        ),
        questRepositoryProvider.overrideWithValue(_FakeQuestRepo(quests)),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: QuestJournalScreen(),
      ),
    );
  }

  testWidgets('shows empty quest state', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Quest Journal'), findsOneWidget);
    expect(
      find.text('No quests tracked yet. Add one to start your journal.'),
      findsOneWidget,
    );
  });

  testWidgets('renders quest cards with character context', (tester) async {
    await tester.pumpWidget(
      buildScreen(
        characters: [
          Character(
            id: 'c1',
            name: 'Paul',
            region: 'NA',
            serverType: 'Official',
            world: 'Arrakis',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        quests: [
          Quest(
            id: 'q1',
            characterId: 'c1',
            title: 'Planetologist Trial',
            questType: 'challenge',
            status: 'active',
            missionType: 'Exploration',
            isLandsraadContract: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Planetologist Trial'), findsOneWidget);
    expect(find.text('Paul'), findsOneWidget);
    expect(find.text('Landsraad Contract'), findsOneWidget);
  });
}
