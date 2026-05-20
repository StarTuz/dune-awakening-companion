import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/blueprints/models/blueprint.dart';
import 'package:dune_awakening_companion/features/blueprints/providers/blueprint_provider.dart';
import 'package:dune_awakening_companion/features/blueprints/screens/blueprint_tracker_screen.dart';
import 'package:dune_awakening_companion/features/blueprints/services/blueprint_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
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

class _FakeBlueprintRepo implements BlueprintRepository {
  _FakeBlueprintRepo(this.blueprints);

  final List<Blueprint> blueprints;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Blueprint>> getAll() async => blueprints;

  @override
  Future<List<Blueprint>> getByCharacterAndRegion(
    String characterId,
    String region,
  ) async {
    return blueprints
        .where((blueprint) =>
            blueprint.characterId == characterId && blueprint.region == region)
        .toList();
  }

  @override
  Future<List<Blueprint>> getByCharacterId(String characterId) async {
    return blueprints
        .where((blueprint) => blueprint.characterId == characterId)
        .toList();
  }

  @override
  Future<void> upsert(Blueprint blueprint) async {}
}

void main() {
  final now = DateTime.now();

  Widget buildScreen({
    List<Character> characters = const [],
    List<Blueprint> blueprints = const [],
  }) {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider.overrideWithValue(
          _FakeCharacterRepo(characters),
        ),
        blueprintRepositoryProvider.overrideWithValue(
          _FakeBlueprintRepo(blueprints),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlueprintTrackerScreen(),
      ),
    );
  }

  testWidgets('asks for a character before tracking blueprints',
      (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Blueprints / Schematics'), findsOneWidget);
    expect(
      find.text(
          'Add a character first, then track Hagga Basin South blueprints.'),
      findsOneWidget,
    );
  });

  testWidgets('renders seeded Hagga Basin South checklist', (tester) async {
    await tester.pumpWidget(
      buildScreen(
        characters: [
          Character(
            id: 'c1',
            name: 'Chani',
            region: 'NA',
            serverType: 'Official',
            world: 'Arrakis',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(Blueprint.defaultRegion), findsOneWidget);
    expect(find.text("Kaleff's Drinker"), findsOneWidget);
    expect(find.text('Old Sparky Mk1'), findsOneWidget);
    expect(find.text('0 / 17 collected'), findsOneWidget);
  });

  testWidgets('marks seeded checklist rows collected per character',
      (tester) async {
    await tester.pumpWidget(
      buildScreen(
        characters: [
          Character(
            id: 'c1',
            name: 'Chani',
            region: 'NA',
            serverType: 'Official',
            world: 'Arrakis',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        blueprints: [
          Blueprint(
            id: 'bp1',
            characterId: 'c1',
            name: "Kaleff's Drinker",
            category: 'Weapon',
            sourceType: 'Chest',
            sourceLocation: 'Hagga Basin South, Wreck of the Alcyon',
            isUnlocked: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Kaleff's Drinker"), findsOneWidget);
    expect(find.text('1 / 17 collected'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Checkbox && widget.value == true,
      ),
      findsOneWidget,
    );
  });
}
