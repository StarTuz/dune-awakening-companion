import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/shared/navigation/main_navigation.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

void main() {
  group('mobileNavSelectedIndex', () {
    test('direct destinations map to themselves', () {
      expect(mobileNavSelectedIndex(navIndexDashboard), navIndexDashboard);
      expect(mobileNavSelectedIndex(navIndexCharacters), navIndexCharacters);
      expect(mobileNavSelectedIndex(navIndexJournal), navIndexJournal);
      expect(mobileNavSelectedIndex(navIndexFieldTimers), navIndexFieldTimers);
    });

    test('overflow destinations highlight the More slot', () {
      expect(mobileNavSelectedIndex(navIndexBlueprints), mobileMoreSlot);
      expect(mobileNavSelectedIndex(navIndexCalculator), mobileMoreSlot);
      expect(mobileNavSelectedIndex(navIndexAlerts), mobileMoreSlot);
      expect(mobileNavSelectedIndex(navIndexSettings), mobileMoreSlot);
    });
  });

  group('MoreNavigationSheet', () {
    Widget buildHost({int alertCount = 0}) {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (_) => MoreNavigationSheet(alertCount: alertCount),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('lists the four overflow destinations', (tester) async {
      await tester.pumpWidget(buildHost());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Blueprints'), findsOneWidget);
      expect(find.text('Calculator'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('tapping a destination closes the sheet and switches screens',
        (tester) async {
      await tester.pumpWidget(buildHost());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alerts'));
      await tester.pumpAndSettle();

      expect(find.text('Alerts'), findsNothing); // sheet dismissed
      final container =
          ProviderScope.containerOf(tester.element(find.byType(TextButton)));
      expect(container.read(navigationIndexProvider), navIndexAlerts);
    });

    testWidgets('shows the alert badge count when alerts are active',
        (tester) async {
      await tester.pumpWidget(buildHost(alertCount: 3));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });
  });
}
