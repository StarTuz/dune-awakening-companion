import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:dune_awakening_companion/core/utils/constants.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/characters/screens/character_management_screen.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
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

class _FakeBaseRepo implements BaseRepository {
  _FakeBaseRepo();
  @override
  Future<List<Base>> getAll() async => [];
  @override
  Future<Base?> getById(String id) async => null;
  @override
  Future<List<Base>> getByCharacterId(String cid) async => [];
  @override
  Future<List<Base>> getExpiringSoon() async => [];
  @override
  Future<String> create(Base b) async => b.id;
  @override
  Future<void> update(Base b) async {}
  @override
  Future<void> delete(String id) async {}
}

class _FakeUrlLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final List<String> launched = [];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }
}

void main() {
  final now = DateTime.now();

  Widget buildCharacterScreen({
    List<Character> characters = const [],
  }) {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider
            .overrideWithValue(_FakeCharacterRepo(characters)),
        baseRepositoryProvider.overrideWithValue(_FakeBaseRepo()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CharacterManagementScreen(),
      ),
    );
  }

  testWidgets('shows empty state when no characters exist', (tester) async {
    await tester.pumpWidget(buildCharacterScreen());
    await tester.pumpAndSettle();

    expect(find.text('No characters yet. Add one to get started.'),
        findsOneWidget);
  });

  testWidgets('shows character list with names and details', (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Paul Atreides',
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
            serverType: 'Private',
            provider: 'GPORTAL',
            world: 'Custom World',
            sietch: 'Desert Wind',
            createdAt: now,
            updatedAt: now),
        Character(
            id: 'c3',
            name: 'Duncan',
            region: 'North America',
            serverType: 'Self Hosted',
            provider: 'Self Hosted',
            world: 'House Idaho',
            sietch: 'Training Yard',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Paul Atreides'), findsOneWidget);
    expect(find.text('Chani'), findsOneWidget);
    expect(find.text('Duncan'), findsOneWidget);
    // Subtitle shows region - world - sietch
    expect(find.textContaining('NA'), findsOneWidget);
    expect(find.textContaining('GPORTAL'), findsOneWidget);
    expect(find.textContaining('Self Hosted'), findsOneWidget);
  });

  testWidgets('flags a character whose world closed in the migration',
      (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost', // closing world
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('World closed'), findsOneWidget);
  });

  testWidgets('tapping the closed-world badge opens the migration guide',
      (tester) async {
    final fakeLauncher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = fakeLauncher;

    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost', // closed world
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('World closed'));
    await tester.pumpAndSettle();

    expect(
        fakeLauncher.launched, contains(AppConstants.serverMigrationGuideUrl));
  });

  testWidgets('closed-world badge shows a dismiss affordance', (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost',
            sietch: 'Tabr',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('World closed'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('acknowledged closed world hides the badge', (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Stilgar',
            region: 'Asia',
            serverType: 'Official',
            world: 'Bifrost',
            sietch: 'Tabr',
            closedWorldAcknowledged: true,
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('World closed'), findsNothing);
  });

  testWidgets('does not flag a character on a surviving world', (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
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

    expect(find.text('World closed'), findsNothing);
  });

  testWidgets(
      'edit dialog opens in custom mode for an existing legacy/off-list world',
      (tester) async {
    // 'Octane' is the pre-correction spelling of the closing world 'Octans';
    // it is no longer in the dropdown, so the dialog must fall back to the
    // free-text custom field instead of crashing on a value-not-in-items.
    await tester.pumpWidget(buildCharacterScreen(
      characters: [
        Character(
            id: 'c1',
            name: 'Feyd',
            region: 'Europe',
            serverType: 'Official',
            world: 'Octane',
            sietch: 'Giedi',
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // No exception thrown, and the custom-world field is shown pre-filled.
    expect(tester.takeException(), isNull);
    expect(find.text('Custom world'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Octane'), findsOneWidget);
  });

  testWidgets('shows FAB for adding new character', (tester) async {
    await tester.pumpWidget(buildCharacterScreen());
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('shows edit and delete buttons for each character',
      (tester) async {
    await tester.pumpWidget(buildCharacterScreen(
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
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.text('Bases'), findsOneWidget);
  });
}
