// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get charactersTitle => 'Characters';

  @override
  String get basesTitle => 'Bases';

  @override
  String get expiringSoonTitle => 'Expiring Soon';

  @override
  String get activeAlertsTitle => 'Active Alerts';

  @override
  String get error => 'Error';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCharacters => 'Characters';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navSettings => 'Settings';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get allBasesSafeTitle => 'All bases are safe!';

  @override
  String get allBasesSafeMessage => 'No bases expire in the next 48 hours.';

  @override
  String get timeRemainingPower => 'Time Remaining: Power';

  @override
  String get timeRemainingTaxes => 'Time Remaining: Taxes';

  @override
  String get expiresLabel => 'Expires';

  @override
  String get dueLabel => 'Due';

  @override
  String get tapToManage => 'Tap to manage this character\'s bases';

  @override
  String get loading => 'Loading...';

  @override
  String get notificationHistoryTooltip => 'Notification History';

  @override
  String get addBaseTooltip => 'Add Base';

  @override
  String get updateCountdownTooltip => 'Update countdown';
}
