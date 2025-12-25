// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Приладна дошка';

  @override
  String get charactersTitle => 'Персонажі';

  @override
  String get basesTitle => 'Бази';

  @override
  String get expiringSoonTitle => 'Скоро закінчується';

  @override
  String get activeAlertsTitle => 'Активні сповіщення';

  @override
  String get error => 'Помилка';

  @override
  String get navDashboard => 'Дошка';

  @override
  String get navCharacters => 'Персонажі';

  @override
  String get navAlerts => 'Сповіщення';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get alertsTitle => 'Сповіщення';

  @override
  String get refreshTooltip => 'Оновити';

  @override
  String get allBasesSafeTitle => 'Усі бази в безпеці!';

  @override
  String get allBasesSafeMessage =>
      'Жодна база не закінчується протягом наступних 48 годин.';

  @override
  String get timeRemainingPower => 'Час, що залишився: Енергія';

  @override
  String get timeRemainingTaxes => 'Час, що залишився: Податки';

  @override
  String get expiresLabel => 'Закінчується';

  @override
  String get dueLabel => 'Термін';

  @override
  String get tapToManage => 'Натисніть, щоб керувати базами';

  @override
  String get loading => 'Завантаження...';

  @override
  String get notificationHistoryTooltip => 'Історія сповіщень';

  @override
  String get addBaseTooltip => 'Додати базу';

  @override
  String get updateCountdownTooltip => 'Оновити зворотний відлік';
}
