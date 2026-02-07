import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/alerts/providers/notification_history_provider.dart';
import 'package:dune_awakening_companion/features/alerts/widgets/notification_history_widget.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class FakeNotificationHistoryNotifier extends NotificationHistoryNotifier {
  FakeNotificationHistoryNotifier(this.initialState) : super() {
    state = initialState;
  }

  final NotificationHistoryState initialState;

  @override
  Future<void> loadHistory() async {}
}

void main() {
  testWidgets('shows empty state when no history', (tester) async {
    const state = NotificationHistoryState(
      entries: [],
      unreadCount: 0,
      isLoading: false,
      error: null,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationHistoryProvider.overrideWith(
            (ref) => FakeNotificationHistoryNotifier(state),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: NotificationHistoryWidget(),
          ),
        ),
      ),
    );

    final context = tester.element(find.byType(NotificationHistoryWidget));
    final l10n = AppLocalizations.of(context)!;

    expect(find.text(l10n.noHistoryTitle), findsOneWidget);
    expect(find.text(l10n.noHistorySubtitle), findsOneWidget);
  });
}
