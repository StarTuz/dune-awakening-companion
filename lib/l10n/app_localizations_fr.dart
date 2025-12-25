// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get charactersTitle => 'Personnages';

  @override
  String get basesTitle => 'Bases';

  @override
  String get expiringSoonTitle => 'Expire Bientôt';

  @override
  String get activeAlertsTitle => 'Alertes Actives';

  @override
  String get error => 'Erreur';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navCharacters => 'Personnages';

  @override
  String get navAlerts => 'Alertes';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get alertsTitle => 'Alertes';

  @override
  String get refreshTooltip => 'Actualiser';

  @override
  String get allBasesSafeTitle => 'Toutes les bases sont sûres !';

  @override
  String get allBasesSafeMessage =>
      'Aucune base n\'expire dans les prochaines 48 heures.';

  @override
  String get timeRemainingPower => 'Temps Restant : Énergie';

  @override
  String get timeRemainingTaxes => 'Temps Restant : Impôts';

  @override
  String get expiresLabel => 'Expire';

  @override
  String get dueLabel => 'Échéance';

  @override
  String get tapToManage => 'Appuyez pour gérer les bases';

  @override
  String get loading => 'Chargement...';
}
