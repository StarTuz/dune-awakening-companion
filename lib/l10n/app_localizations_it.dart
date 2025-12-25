// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Cruscotto';

  @override
  String get charactersTitle => 'Personaggi';

  @override
  String get basesTitle => 'Basi';

  @override
  String get expiringSoonTitle => 'In Scadenza';

  @override
  String get activeAlertsTitle => 'Avvisi Attivi';

  @override
  String get error => 'Errore';

  @override
  String get navDashboard => 'Cruscotto';

  @override
  String get navCharacters => 'Personaggi';

  @override
  String get navAlerts => 'Avvisi';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get alertsTitle => 'Avvisi';

  @override
  String get refreshTooltip => 'Aggiorna';

  @override
  String get allBasesSafeTitle => 'Tutte le basi sono al sicuro!';

  @override
  String get allBasesSafeMessage => 'Nessuna base scade nelle prossime 48 ore.';

  @override
  String get timeRemainingPower => 'Tempo Rimanente: Energia';

  @override
  String get timeRemainingTaxes => 'Tempo Rimanente: Tasse';

  @override
  String get expiresLabel => 'Scade';

  @override
  String get dueLabel => 'Scadenza';

  @override
  String get tapToManage => 'Tocca per gestire le basi';

  @override
  String get loading => 'Caricamento...';

  @override
  String get notificationHistoryTooltip => 'Cronologia Notifiche';

  @override
  String get addBaseTooltip => 'Aggiungi Base';

  @override
  String get updateCountdownTooltip => 'Aggiorna conto alla rovescia';
}
