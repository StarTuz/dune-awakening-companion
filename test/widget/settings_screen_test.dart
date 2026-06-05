import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/settings/screens/settings_screen.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class _FakeCharacterRepo implements CharacterRepository {
  @override
  Future<List<Character>> getAll() async => [];
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

void main() {
  Widget buildSettings() {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider.overrideWithValue(_FakeCharacterRepo()),
        baseRepositoryProvider.overrideWithValue(_FakeBaseRepo()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    );
  }

  testWidgets('renders settings screen with about section', (tester) async {
    await tester.pumpWidget(buildSettings());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsScreen));
    final l10n = AppLocalizations.of(context)!;

    // About section is at the top, always visible
    expect(find.text(l10n.sectionAbout), findsOneWidget);
    expect(find.text(l10n.settingsTitle), findsOneWidget);
  });

  testWidgets('shows version and database info', (tester) async {
    await tester.pumpWidget(buildSettings());
    await tester.pumpAndSettle();

    expect(find.text('1.3.0-beta'), findsOneWidget);
    expect(find.text('v16'), findsAtLeastNWidgets(1));
  });

  testWidgets('shows appearance section after scrolling', (tester) async {
    await tester.pumpWidget(buildSettings());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsScreen));
    final l10n = AppLocalizations.of(context)!;

    // Appearance section is near the top
    expect(find.text(l10n.sectionAppearance), findsOneWidget);
  });

  testWidgets('can scroll to data management section', (tester) async {
    await tester.pumpWidget(buildSettings());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsScreen));
    final l10n = AppLocalizations.of(context)!;

    // Scroll down to find the data management section
    await tester.scrollUntilVisible(
      find.text(l10n.exportData),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text(l10n.exportData), findsOneWidget);
  });
}
