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

  // The tracker header carries a region filter chip per known region.
  // With 7+ chips it can wrap to two rows, pushing the first list row
  // below the default 800x600 widget-test surface. Tall-viewport helper
  // for tests that need to see a specific checklist entry.
  Future<void> useTallSurface(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

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
          'Add a character first, then track unique schematic discoveries.'),
      findsOneWidget,
    );
  });

  testWidgets('renders seeded multi-region checklist', (tester) async {
    await useTallSurface(tester);
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

    // Default region filter is "All Regions" until a character pref is set.
    expect(find.text('All Regions'), findsOneWidget);
    expect(find.text("Kaleff's Drinker"), findsOneWidget);
    expect(find.text('0 / 145 collected'), findsOneWidget);
  });

  testWidgets('marks seeded checklist rows collected per character',
      (tester) async {
    await useTallSurface(tester);
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
            unlockedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Kaleff's Drinker"), findsOneWidget);
    expect(find.text('1 / 145 collected'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Checkbox && widget.value == true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('keeps respawn timer optional for collected blueprints',
      (tester) async {
    await useTallSurface(tester);
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
            unlockedAt: DateTime.now(),
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Respawn timer'), findsOneWidget);
    expect(find.textContaining('Respawns in'), findsNothing);
  });

  testWidgets('shows respawn countdown when timer is enabled', (tester) async {
    await useTallSurface(tester);
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
            unlockedAt: DateTime.now(),
            respawnTimerEnabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Respawns in'), findsOneWidget);
  });
}
