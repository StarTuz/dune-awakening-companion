// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get charactersTitle => 'Charaktere';

  @override
  String get basesTitle => 'Basen';

  @override
  String get expiringSoonTitle => 'Bald ablaufend';

  @override
  String get activeAlertsTitle => 'Aktive Warnungen';

  @override
  String get error => 'Fehler';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCharacters => 'Charaktere';

  @override
  String get navAlerts => 'Warnungen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get alertsTitle => 'Warnungen';

  @override
  String get refreshTooltip => 'Aktualisieren';

  @override
  String get allBasesSafeTitle => 'Alle Basen sind sicher!';

  @override
  String get allBasesSafeMessage =>
      'Keine Basen laufen in den nächsten 48 Stunden ab.';

  @override
  String get timeRemainingPower => 'Verbleibende Zeit: Energie';

  @override
  String get timeRemainingTaxes => 'Verbleibende Zeit: Steuern';

  @override
  String get expiresLabel => 'Läuft ab';

  @override
  String get dueLabel => 'Fällig';

  @override
  String get tapToManage => 'Tippen zum Verwalten';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get notificationHistoryTooltip => 'Benachrichtigungsverlauf';

  @override
  String get addBaseTooltip => 'Basis hinzufügen';

  @override
  String get updateCountdownTooltip => 'Countdown aktualisieren';
}
