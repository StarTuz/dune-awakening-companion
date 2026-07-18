import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';
import 'package:dune_awakening_companion/features/bases/providers/base_provider.dart';
import 'package:dune_awakening_companion/features/bases/services/base_repository.dart';
import 'package:dune_awakening_companion/features/field_timers/models/field_timer_session.dart';
import 'package:dune_awakening_companion/features/field_timers/providers/field_timer_provider.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_audio_service.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_notification_service.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_os_alarm_service.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_service.dart';
import 'package:dune_awakening_companion/shared/navigation/navigation_rail_footer.dart';
import 'package:dune_awakening_companion/shared/navigation/navigation_rail_settings.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

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

/// Exposes the protected [state] setter so tests can pin a session.
class FakeFieldTimerService extends FieldTimerService {
  FakeFieldTimerService(this.session)
      : super(FieldTimerAudioService(), FieldTimerNotificationService(),
            FieldTimerOsAlarmService());

  final FieldTimerSession session;

  void apply() => state = session;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  final now = DateTime.now();

  Base baseExpiringIn(double hours) => Base(
        id: 'b-$hours',
        characterId: 'c1',
        name: 'Base',
        powerExpirationTime: now.add(Duration(minutes: (hours * 60).round())),
        createdAt: now,
        updatedAt: now,
      );

  Widget buildFooter({
    bool extended = true,
    List<Base> bases = const [],
    FieldTimerSession? session,
    VoidCallback? onFieldTimerTap,
    VoidCallback? onBaseExpiryTap,
  }) {
    // Always override the timer provider: the real one initializes
    // platform notification/audio plugins that don't exist in tests.
    final effectiveSession = session ?? const FieldTimerSession.idle();
    return ProviderScope(
      overrides: [
        baseRepositoryProvider.overrideWithValue(FakeBaseRepository(bases)),
        fieldTimerProvider.overrideWith(
          (ref) => FakeFieldTimerService(effectiveSession)..apply(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NavigationRailFooter(
            extended: extended,
            onFieldTimerTap: onFieldTimerTap ?? () {},
            onBaseExpiryTap: onBaseExpiryTap ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('idle with no expiring bases shows only version and toggle',
      (tester) async {
    await tester.pumpWidget(buildFooter());
    await tester.pumpAndSettle();

    expect(find.textContaining('v1.4'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.text('Field timer'), findsNothing);
    expect(find.text('Next expiry'), findsNothing);
  });

  testWidgets('shows the next base expiry inside the 48 h window',
      (tester) async {
    await tester.pumpWidget(buildFooter(bases: [
      baseExpiringIn(72), // outside window — ignored
      baseExpiringIn(10.5),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Next expiry'), findsOneWidget);
    expect(find.text('10h'), findsOneWidget);
  });

  testWidgets('hides the expiry row when all bases are beyond 48 h',
      (tester) async {
    await tester.pumpWidget(buildFooter(bases: [baseExpiringIn(72)]));
    await tester.pumpAndSettle();

    expect(find.text('Next expiry'), findsNothing);
  });

  testWidgets('tapping the expiry row invokes the callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildFooter(
      bases: [baseExpiringIn(10)],
      onBaseExpiryTap: () => tapped = true,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next expiry'));
    expect(tapped, isTrue);
  });

  testWidgets('shows the armed field timer countdown', (tester) async {
    const session = FieldTimerSession(
      state: FieldTimerState.armed,
      totalDuration: Duration(minutes: 3),
      elapsed: Duration(seconds: 35),
      cues: [],
      escalationCount: 0,
    );
    await tester.pumpWidget(buildFooter(session: session));
    await tester.pumpAndSettle();

    expect(find.text('Field timer'), findsOneWidget);
    expect(find.text('2:25'), findsOneWidget);
  });

  testWidgets('collapsed footer hides labels and version but keeps status',
      (tester) async {
    await tester.pumpWidget(buildFooter(
      extended: false,
      bases: [baseExpiringIn(10.5)],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Next expiry'), findsNothing); // label → tooltip only
    expect(find.text('10h'), findsOneWidget);
    expect(find.textContaining('v1.4'), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('the toggle flips and persists the expanded preference',
      (tester) async {
    await tester.pumpWidget(buildFooter());
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
        tester.element(find.byType(NavigationRailFooter)));
    expect(container.read(navigationRailExpandedProvider), isTrue);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(container.read(navigationRailExpandedProvider), isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('navigation_rail_expanded'), isFalse);
  });
}
