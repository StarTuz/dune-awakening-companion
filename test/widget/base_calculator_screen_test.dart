import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/screens/base_calculator_screen.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

void main() {
  Widget buildScreen() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BaseCalculatorScreen(),
      ),
    );
  }

  // Large surface so every catalog row is built and hit-testable (the catalog
  // uses a lazy ListView) and the wide two-pane layout is exercised.
  Future<void> useLargeSurface(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('shows the empty prompt before anything is selected',
      (tester) async {
    await useLargeSurface(tester);
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Base Calculator'), findsOneWidget);
    expect(
      find.text('Add items below to calculate power and materials.'),
      findsOneWidget,
    );
  });

  testWidgets('adding a generator updates power and materials', (tester) async {
    await useLargeSurface(tester);
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    final row = find.widgetWithText(ListTile, 'Fuel-Powered Generator');
    expect(row, findsOneWidget);

    final addButton = find.descendant(
      of: row,
      matching: find.byIcon(Icons.add_circle_outline),
    );
    await tester.tap(addButton);
    await tester.pump();

    // Generated-power stat (+75) and the material it costs both appear.
    expect(find.text('Salvaged Metal'), findsOneWidget);
    expect(find.text('+75'), findsWidgets);
  });

  testWidgets('warns when the build needs more power', (tester) async {
    await useLargeSurface(tester);
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    final row = find.widgetWithText(ListTile, 'Windtrap');
    final addButton = find.descendant(
      of: row.first,
      matching: find.byIcon(Icons.add_circle_outline),
    );
    await tester.tap(addButton);
    await tester.pump();

    // Windtrap consumes 75 power with no generation -> deficit warning.
    expect(find.text('Needs 75 more power'), findsOneWidget);
  });

  testWidgets('estimates trips once storage is configured', (tester) async {
    await useLargeSurface(tester);
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    // Select a build item so the transport section appears.
    final itemRow = find.widgetWithText(ListTile, 'Fuel-Powered Generator');
    await tester.tap(find.descendant(
      of: itemRow,
      matching: find.byIcon(Icons.add_circle_outline),
    ));
    await tester.pump();

    // No storage yet -> hint instead of a trip count.
    expect(
      find.text('Add storage below to estimate trips.'),
      findsOneWidget,
    );

    // Add a storage container.
    final storageRow = find.widgetWithText(ListTile, 'Player (Inventory)');
    await tester.ensureVisible(storageRow);
    await tester.pump();
    await tester.tap(find.descendant(
      of: storageRow,
      matching: find.byIcon(Icons.add_circle_outline),
    ));
    await tester.pump();

    expect(find.text('Trips needed'), findsOneWidget);
    expect(find.text('Add storage below to estimate trips.'), findsNothing);
  });
}
