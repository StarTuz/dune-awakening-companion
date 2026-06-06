import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/dashboard/screens/dashboard_screen.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Fake repositories that return in-memory data
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
  final List<Base> data;
  FakeBaseRepository([this.data = const []]);

  @override
  Future<List<Base>> getAll() async => data;
  @override
  Future<Base?> getById(String id) async => null;
  @override
  Future<List<Base>> getByCharacterId(String characterId) async =>
      data.where((b) => b.characterId == characterId).toList();
  @override
  Future<List<Base>> getExpiringSoon() async => [];
  @override
  Future<String> create(Base base) async => base.id;
  @override
  Future<void> update(Base base) async {}
  @override
  Future<void> delete(String id) async {}
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  final now = DateTime.now();

  Widget buildDashboard({
    List<Character> characters = const [],
    List<Base> bases = const [],
  }) {
    final charRepo = FakeCharacterRepository(characters);
    final baseRepo = FakeBaseRepository(bases);
    return ProviderScope(
      overrides: [
        characterRepositoryProvider.overrideWithValue(charRepo),
        baseRepositoryProvider.overrideWithValue(baseRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DashboardScreen(),
      ),
    );
  }

  testWidgets('shows correct character and base counts', (tester) async {
    await tester.pumpWidget(buildDashboard(
      characters: [
        Character(
            id: 'c1',
            name: 'Paul',
            region: 'NA',
            serverType: 'Official',
            world: 'Arrakis',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
        Character(
            id: 'c2',
            name: 'Chani',
            region: 'EU',
            serverType: 'Official',
            world: 'Caladan',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
      bases: [
        Base(
            id: 'b1',
            characterId: 'c1',
            name: 'Safe Base',
            powerExpirationTime: now.add(const Duration(hours: 72)),
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Characters'), findsOneWidget);
    expect(find.text('Bases'), findsOneWidget);
    expect(find.text('2'), findsAtLeastNWidgets(1));
    expect(find.text('1'), findsAtLeastNWidgets(1));
    expect(find.text('Characters by Region'), findsOneWidget);
    expect(find.text('Base Alert Distribution'), findsOneWidget);
  });

  testWidgets('shows zero counts when no data', (tester) async {
    await tester.pumpWidget(buildDashboard());
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNWidgets(4)); // chars, bases, expiring, alerts
  });

  testWidgets('renders stat card icons', (tester) async {
    await tester.pumpWidget(buildDashboard());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.warning), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
  });

  testWidgets('shows closed-worlds stat when a character is on a closed world',
      (tester) async {
    await tester.pumpWidget(buildDashboard(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost', // closed in the migration
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('On closed worlds'), findsOneWidget);
    expect(find.byIcon(Icons.public_off), findsOneWidget);
  });

  testWidgets('excludes acknowledged characters from the closed-worlds stat',
      (tester) async {
    await tester.pumpWidget(buildDashboard(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost', // closed, but acknowledged
            sietch: 'Tabr',
            closedWorldAcknowledged: true,
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('On closed worlds'), findsNothing);
  });

  testWidgets('hides closed-worlds stat when all worlds survive',
      (tester) async {
    await tester.pumpWidget(buildDashboard(
      characters: [
        Character(
            id: 'c1',
            name: 'Paul',
            region: 'NA',
            serverType: 'Official',
            world: 'Arrakis', // survivor
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('On closed worlds'), findsNothing);
    expect(find.byIcon(Icons.public_off), findsNothing);
  });
}
