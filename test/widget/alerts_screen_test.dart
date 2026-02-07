import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';
import 'package:dune_awakening_companion/features/characters/providers/character_provider.dart';
import 'package:dune_awakening_companion/features/characters/services/character_repository.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/alerts/screens/alerts_screen.dart';
import 'package:dune_awakening_companion/features/alerts/providers/notification_history_provider.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// Reuse fake repos from dashboard test
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
  final List<Base> data;
  _FakeBaseRepo([this.data = const []]);
  @override
  Future<List<Base>> getAll() async => data;
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

class _FakeHistoryNotifier extends NotificationHistoryNotifier {
  _FakeHistoryNotifier(this._initial) : super() {
    state = _initial;
  }
  final NotificationHistoryState _initial;
  @override
  Future<void> loadHistory() async {}
}

void main() {
  final now = DateTime.now();

  Widget buildAlerts({
    List<Character> characters = const [],
    List<Base> bases = const [],
  }) {
    return ProviderScope(
      overrides: [
        characterRepositoryProvider
            .overrideWithValue(_FakeCharacterRepo(characters)),
        baseRepositoryProvider.overrideWithValue(_FakeBaseRepo(bases)),
        notificationHistoryProvider.overrideWith(
          (ref) => _FakeHistoryNotifier(const NotificationHistoryState(
            entries: [],
            unreadCount: 0,
            isLoading: false,
          )),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AlertsScreen(),
      ),
    );
  }

  testWidgets('shows "all safe" when no bases are expiring', (tester) async {
    await tester.pumpWidget(buildAlerts(
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

    final context = tester.element(find.byType(AlertsScreen));
    final l10n = AppLocalizations.of(context)!;

    expect(find.text(l10n.allBasesSafeTitle), findsOneWidget);
    expect(find.text(l10n.allBasesSafeMessage), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('shows alert card for base expiring within 48h', (tester) async {
    await tester.pumpWidget(buildAlerts(
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
      bases: [
        Base(
            id: 'b1',
            characterId: 'c1',
            name: 'Danger Base',
            powerExpirationTime: now.add(const Duration(hours: 6)),
            createdAt: now,
            updatedAt: now),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Danger Base'), findsOneWidget);
    expect(find.text('Paul'), findsOneWidget);
  });

  testWidgets('shows "all safe" when no bases exist', (tester) async {
    await tester.pumpWidget(buildAlerts());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(AlertsScreen));
    final l10n = AppLocalizations.of(context)!;

    expect(find.text(l10n.allBasesSafeTitle), findsOneWidget);
  });
}
