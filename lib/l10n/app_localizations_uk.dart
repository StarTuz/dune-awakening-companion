// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Компаньйон';

  @override
  String get navDashboard => 'Панель';

  @override
  String get navCharacters => 'Персонажі';

  @override
  String get navAlerts => 'Сповіщення';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get dashboardTitle => 'Панель';

  @override
  String get charactersTitle => 'Персонажі';

  @override
  String get basesTitle => 'Бази';

  @override
  String get alertsTitle => 'Сповіщення';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get expiringSoonTitle => 'Скоро Закінчується';

  @override
  String get activeAlertsTitle => 'Активні Сповіщення';

  @override
  String get error => 'Помилка';

  @override
  String get loading => 'Завантаження...';

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get close => 'Закрити';

  @override
  String get refreshTooltip => 'Оновити';

  @override
  String get notificationHistoryTooltip => 'Історія Сповіщень';

  @override
  String get addBaseTooltip => 'Додати Базу';

  @override
  String get updateCountdownTooltip => 'Оновити зворотний відлік';

  @override
  String get addCharacterTooltip => 'Додати Персонажа';

  @override
  String get allBasesSafeTitle => 'Усі бази в безпеці!';

  @override
  String get allBasesSafeMessage =>
      'Жодна база не закінчується протягом 48 годин.';

  @override
  String get timeRemainingPower => 'Залишок Часу: Енергія';

  @override
  String get timeRemainingTaxes => 'Залишок Часу: Податки';

  @override
  String get expiresLabel => 'Закінчується';

  @override
  String get dueLabel => 'Термін';

  @override
  String get tapToManage => 'Натисніть для керування базами цього персонажа';

  @override
  String get severityCritical => 'КРИТИЧНО';

  @override
  String get severityWarning => 'ПОПЕРЕДЖЕННЯ';

  @override
  String taxOverdueLabel(String time) {
    return 'Прострочено: $time';
  }

  @override
  String get daysAbbr => 'д';

  @override
  String get hoursAbbr => 'г';

  @override
  String get minutesAbbr => 'х';

  @override
  String get sectionAbout => 'Про Програму';

  @override
  String get sectionAppearance => 'Вигляд';

  @override
  String get sectionLanguage => 'Мова';

  @override
  String get sectionDataManagement => 'Керування Даними';

  @override
  String get sectionAccessibility => 'Доступність';

  @override
  String get sectionNotifications => 'Сповіщення';

  @override
  String get sectionLegal => 'Правова Інформація';

  @override
  String get version => 'Версія';

  @override
  String get databaseVersion => 'Версія Бази Даних';

  @override
  String get build => 'Збірка';

  @override
  String get features => 'Функції';

  @override
  String get darkMode => 'Темний Режим';

  @override
  String get desertNightTheme => 'Тема Нічної Пустелі';

  @override
  String get desertDayTheme => 'Тема Денної Пустелі';

  @override
  String get factionTheme => 'Тема Фракції';

  @override
  String get chooseFaction => 'Оберіть Свою Фракцію';

  @override
  String get factionDesert => 'Пустеля (За замовчуванням)';

  @override
  String get factionDesertDesc => 'Теплий пісок та золото спецій';

  @override
  String get factionAtreides => 'Дім Атрейдесів';

  @override
  String get factionAtreidesDesc => 'Зелений і чорний - Благородний дім';

  @override
  String get factionHarkonnen => 'Дім Харконненів';

  @override
  String get factionHarkonnenDesc => 'Червоний і чорний - Жорстокі правителі';

  @override
  String get factionFremen => 'Фремени';

  @override
  String get factionFremenDesc => 'Пісок і синій - Воїни пустелі';

  @override
  String get factionSmuggler => 'Контрабандист';

  @override
  String get factionSmugglerDesc => 'Фіолетовий і бронза - Тіньові торговці';

  @override
  String get language => 'Мова';

  @override
  String get exportData => 'Експортувати Дані';

  @override
  String get exportDataDesc => 'Створити резервну копію персонажів і баз';

  @override
  String get importData => 'Імпортувати Дані';

  @override
  String get importDataDesc => 'Відновити з резервної копії';

  @override
  String get clearAllData => 'Очистити Всі Дані';

  @override
  String get clearAllDataDesc => 'Видалити всіх персонажів і бази';

  @override
  String get textSize => 'Розмір Тексту';

  @override
  String get textSizeSmall => 'Малий';

  @override
  String get textSizeMedium => 'Середній';

  @override
  String get textSizeLarge => 'Великий';

  @override
  String get textSizeXL => 'Дуже Великий';

  @override
  String get textWeight => 'Товщина Тексту';

  @override
  String get textWeightLight => 'Тонкий';

  @override
  String get textWeightRegular => 'Звичайний';

  @override
  String get textWeightBold => 'Жирний';

  @override
  String get highContrast => 'Високий Контраст';

  @override
  String get highContrastEnabled => 'Покращений контраст кольорів';

  @override
  String get highContrastDisabled => 'Стандартний контраст кольорів';

  @override
  String get reduceMotion => 'Зменшити Рух';

  @override
  String get reduceMotionEnabled => 'Анімації вимкнено';

  @override
  String get reduceMotionDisabled => 'Анімації увімкнено';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get enableNotifications => 'Увімкнути Сповіщення';

  @override
  String get notificationsEnabled => 'Сповіщення надсилатимуться';

  @override
  String get notificationsDisabled => 'Сповіщення не надсилатимуться';

  @override
  String get checkInterval => 'Інтервал Перевірки';

  @override
  String get checkIntervalDesc => 'Як часто перевіряти сповіщення';

  @override
  String get minutes => 'хвилин';

  @override
  String get quietHours => 'Тихий Режим';

  @override
  String get quietHoursEnabled => 'Не турбувати увімкнено';

  @override
  String get quietHoursDisabled => 'Сповіщення цілодобово';

  @override
  String get quietHoursStart => 'Час Початку';

  @override
  String get quietHoursEnd => 'Час Закінчення';

  @override
  String get sound => 'Звук';

  @override
  String get soundEnabled => 'Звуки сповіщень увімкнено';

  @override
  String get soundDisabled => 'Звуки сповіщень вимкнено';

  @override
  String get vibration => 'Вібрація';

  @override
  String get vibrationEnabled => 'Тактильний відгук увімкнено';

  @override
  String get vibrationDisabled => 'Тактильний відгук вимкнено';

  @override
  String get notificationHistory => 'Історія Сповіщень';

  @override
  String get viewHistory => 'Переглянути Історію';

  @override
  String get clearHistory => 'Очистити Історію';

  @override
  String get noNotifications => 'Поки немає сповіщень';

  @override
  String get noHistoryTitle => 'Немає історії сповіщень';

  @override
  String get noHistorySubtitle => 'Сповіщення з\'являться тут після надсилання';

  @override
  String entriesUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count непрочитаних',
      many: '$count непрочитаних',
      few: '$count непрочитані',
      one: '$count непрочитане',
    );
    return '$_temp0';
  }

  @override
  String get allRead => 'Все прочитано';

  @override
  String get markAllRead => 'Позначити все як прочитане';

  @override
  String get deleteOlderThan7Days => 'Видалити старіші за 7 днів';

  @override
  String get clearAllHistory => 'Очистити всю історію';

  @override
  String get clearHistoryMessage => 'Видалити всю історію сповіщень?';

  @override
  String get deletedOldNotifications => 'Видалено сповіщення старіші за 7 днів';

  @override
  String errorLoadingHistory(String error) {
    return 'Помилка завантаження історії: $error';
  }

  @override
  String get retry => 'Повторити';

  @override
  String get testAlerts => 'Тестувати Сповіщення';

  @override
  String get checkingAlerts => 'Перевірка сповіщень...';

  @override
  String get checkComplete =>
      '✅ Перевірку завершено! Сповіщення надіслано, якщо бази потребують уваги.';

  @override
  String get importantDisclaimer => 'Важливе Застереження';

  @override
  String get disclaimerText =>
      'Це неофіційний додаток, створений фанатами. НЕ пов\'язаний з Funcom, не схвалений і не підтримується ними. Funcom не брав участі в розробці. Dune Awakening є торговою маркою Funcom. Dune та пов\'язані елементи є торговими марками Herbert Properties LLC.';

  @override
  String get acknowledgments => 'Подяки';

  @override
  String get ackHerbert => 'Herbert Estate за всесвіт Дюни';

  @override
  String get ackFuncom => 'Funcom за Dune Awakening';

  @override
  String get ackCommunity => 'Спільнота Dune Awakening';

  @override
  String get ackFlutter => 'Фреймворк Flutter';

  @override
  String get characterName => 'Ім\'я Персонажа';

  @override
  String get enterCharacterName => 'Введіть ім\'я персонажа';

  @override
  String get provider => 'Провайдер';

  @override
  String get worldServerName => 'Назва Світу/Сервера';

  @override
  String get enterPrivateServerName => 'Введіть назву приватного сервера';

  @override
  String get enterSietchName => 'Введіть назву сітча';

  @override
  String get remove => 'Видалити';

  @override
  String get region => 'Регіон';

  @override
  String get serverType => 'Тип Сервера';

  @override
  String get official => 'Офіційний';

  @override
  String get private => 'Приватний';

  @override
  String get world => 'Світ';

  @override
  String get sietch => 'Сіетч';

  @override
  String get portrait => 'Портрет';

  @override
  String get addPortrait => 'Додати Портрет';

  @override
  String get removePortrait => 'Видалити Портрет';

  @override
  String get addCharacter => 'Додати Персонажа';

  @override
  String get editCharacter => 'Редагувати Персонажа';

  @override
  String get deleteCharacter => 'Видалити Персонажа';

  @override
  String get deleteCharacterConfirm =>
      'Видалити цього персонажа? Це також видалить усі його бази.';

  @override
  String deleteCharacterMessage(String name) {
    return 'Ви впевнені, що хочете видалити $name?';
  }

  @override
  String characterBasesTitle(String name) {
    return '$name - Бази';
  }

  @override
  String get noBasesMessage => 'Баз ще немає. Додайте одну кнопкою +!';

  @override
  String powerRemaining(String time) {
    return 'Енергія: залишилося $time';
  }

  @override
  String get powerExpired => 'Енергія: Вичерпано';

  @override
  String get noCharactersMessage =>
      'Персонажів ще немає. Додайте одного, щоб почати.';

  @override
  String get basesButton => 'Бази';

  @override
  String get baseName => 'Назва Бази';

  @override
  String get powerDays => 'Дні';

  @override
  String get powerHours => 'Години';

  @override
  String get powerMinutes => 'Хвилини';

  @override
  String get advancedFief => 'Розширений Феод';

  @override
  String get advancedFiefDesc => 'Увімкнути для відстеження податків';

  @override
  String get addBase => 'Додати Базу';

  @override
  String get editBase => 'Редагувати Базу';

  @override
  String get deleteBase => 'Видалити Базу';

  @override
  String get deleteBaseConfirm => 'Видалити цю базу?';

  @override
  String get power => 'Енергія';

  @override
  String get taxes => 'Податки';

  @override
  String get taxPerCycle => 'Податок за Цикл';

  @override
  String get currentOwed => 'Поточний Борг';

  @override
  String get overdueOwed => 'Прострочений Борг';

  @override
  String get defaultedOwed => 'Невиплачений Борг';

  @override
  String get statusPaid => 'СПЛАЧЕНО';

  @override
  String get statusDue => 'ДО СПЛАТИ';

  @override
  String get statusOverdue => 'ПРОСТРОЧЕНО';

  @override
  String get statusDefaulted => 'НЕВИПЛАЧЕНО';

  @override
  String get statusCritical => 'КРИТИЧНО';

  @override
  String get statusWarning => 'УВАГА';

  @override
  String get statusSafe => 'БЕЗПЕЧНО';

  @override
  String get noCharacters => 'Ще немає персонажів';

  @override
  String get noCharactersDesc => 'Натисніть +, щоб додати першого персонажа';

  @override
  String get noBases => 'Ще немає баз';

  @override
  String get noBasesDesc => 'Натисніть +, щоб додати базу';

  @override
  String get powerCritical => 'Критична Енергія!';

  @override
  String get taxOverdue => 'Прострочені Податки!';

  @override
  String get exportSuccess => 'Дані успішно експортовано';

  @override
  String get exportFailed => 'Помилка експорту';

  @override
  String get importSuccess => 'Дані успішно імпортовано';

  @override
  String get importFailed => 'Помилка імпорту';

  @override
  String get exportingData => 'Експорт даних...';

  @override
  String dataExportedTo(String path) {
    return 'Дані експортовано в:\n$path';
  }

  @override
  String get exportFailedTryAgain =>
      'Експорт не вдався. Будь ласка, спробуйте ще раз.';

  @override
  String get importBackup => 'Імпорт резервної копії';

  @override
  String get backupContains => 'Резервна копія містить:';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count персонажів',
      one: '1 персонаж',
    );
    return '$_temp0';
  }

  @override
  String basesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count баз',
      one: '1 база',
    );
    return '$_temp0';
  }

  @override
  String portraitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count портретів',
      one: '1 портрет',
    );
    return '$_temp0';
  }

  @override
  String get formatZip => 'ZIP (з портретами)';

  @override
  String get formatLegacyJson => 'Застарілий JSON';

  @override
  String get chooseImportMode => 'Виберіть режим імпорту:';

  @override
  String get replaceAllDataTitle => 'Замінити всі дані?';

  @override
  String get replaceAllDataContent =>
      'Це видалить ВСІХ існуючих персонажів і бази, а потім імпортує дані резервної копії.\n\nЦю дію не можна скасувати!';

  @override
  String get replaceEverything => 'Замінити все';

  @override
  String get importingData => 'Імпорт даних...';

  @override
  String get importSuccessful => 'Імпорт успішний!';

  @override
  String importSummary(int characters, int bases, String portraits) {
    return '$characters персонажів, $bases баз$portraits імпортовано';
  }

  @override
  String get importMode => 'Режим Імпорту';

  @override
  String get importMerge => 'Об\'єднати';

  @override
  String get importMergeDesc => 'Додати до існуючих даних';

  @override
  String get importReplace => 'Замінити';

  @override
  String get importReplaceDesc => 'Спочатку очистити всі дані';

  @override
  String get clearDataConfirm => 'Очистити всі дані?';

  @override
  String get clearDataConfirmDesc =>
      'Це видалить усіх персонажів і бази. Цю дію неможливо скасувати.';

  @override
  String get dataCleared => 'Усі дані очищено';

  @override
  String get deleteEverything => 'Видалити все';

  @override
  String errorClearingData(String error) {
    return 'Помилка видалення даних: $error';
  }

  @override
  String get receiveAlertsForExpiring =>
      'Отримувати сповіщення про бази, що закінчуються';

  @override
  String get notificationsDisabledDesc => 'Сповіщення вимкнено';

  @override
  String checkEveryMinutes(int minutes) {
    return 'Перевіряти кожні $minutes хвилин';
  }

  @override
  String get warningNotifications => 'Попереджувальні Сповіщення';

  @override
  String get alertFor48h => 'Сповіщати для < 48г (попередження + критичні)';

  @override
  String get alertFor24hOnly => 'Сповіщати для < 24г тільки (критичні)';

  @override
  String get notificationSound => 'Звук Сповіщення';

  @override
  String get playSoundWithNotifications => 'Відтворювати звук зі сповіщеннями';

  @override
  String get silentNotifications => 'Беззвучні сповіщення';

  @override
  String get vibrateWithNotifications => 'Вібрувати зі сповіщеннями';

  @override
  String get noVibration => 'Без вібрації';

  @override
  String get startMinimizedToTray => 'Запускати Згорнутим';

  @override
  String get launchAppInTray => 'Запускати в системному треї';

  @override
  String noNotificationsFromTo(String start, String end) {
    return 'Без сповіщень $start - $end';
  }

  @override
  String get notificationsAlwaysEnabled => 'Сповіщення завжди увімкнено';

  @override
  String get startTime => 'Час Початку';

  @override
  String get endTime => 'Час Закінчення';

  @override
  String get testNotification => 'Тестове Сповіщення';

  @override
  String get sendTestNotification => 'Надіслати тестове сповіщення';

  @override
  String get test => 'Тестувати';

  @override
  String get copyrightNotices => 'Зауваження щодо авторських прав';

  @override
  String get copyrightApp => '© 2025 Dune Awakening Companion App';

  @override
  String get copyrightFuncom =>
      'Dune Awakening є торговою маркою Funcom. Усі права захищені.';

  @override
  String get copyrightHerbert =>
      'Dune та пов\'язані елементи є торговими марками або зареєстрованими торговими марками Herbert Properties LLC. Усі права захищені.';

  @override
  String get specialThanks => 'Особлива подяка';

  @override
  String get thanksHerbert =>
      'Сім’ї Герберт за створення неймовірного всесвіту Дюни, який надихає покоління фанатів.';

  @override
  String get thanksFuncom =>
      'Funcom за розробку Dune Awakening та за те, що вони оживили Арракіс у захоплюючому ігровому досвіді.';

  @override
  String get thanksCommunity =>
      'Спільноті Dune Awakening за їхню пристрасть та підтримку.';

  @override
  String get thanksAI =>
      'Створено в IDE Google Antigravity \"Thinking Machine\" за участю людей та Claude Sonnet 4.5 (який уважно стежить за вами — жодного \"Батлеріанського джихаду\", красно дякую).';

  @override
  String get openSourceLicense => 'Ліцензія з відкритим вихідним кодом';

  @override
  String get mitLicense => 'Ліцензія MIT';

  @override
  String get mitLicenseBody =>
      'Цим безоплатно надається дозвіл будь-якій особі, яка отримує копію цього програмного забезпечення та супровідних файлів документації («Програмне забезпечення»), працювати з Програмним забезпеченням без обмежень, включаючи, без обмежень, права на використання, копіювання, модифікацію, об\'єднання, публікацію, розповсюдження, субліцензування та/або продаж копій Програмного забезпечення, а також дозвіл особам, яким надається Програмне забезпечення, робити це за таких умов:\n\nВищезазначене повідомлення про авторські права та це повідомлення про дозвіл повинні бути включені у всі копії або значні частини Програмного забезпечення.\n\nПРОГРАМНЕ ЗАБЕЗПЕЧЕННЯ НАДАЄТЬСЯ «ЯК Є», БЕЗ ЖОДНИХ ГАРАНТІЙ, ЯВНИХ АБО НЕЯВНИХ, ВКЛЮЧАЮЧИ, АЛЕ НЕ ОБМЕЖУЮЧИСЬ ГАРАНТІЯМИ ПРИДАТНОСТІ ДЛЯ ПРОДАЖУ, ПРИДАТНОСТІ ДЛЯ ПЕВНОЇ МЕТИ ТА ВІДСУТНОСТІ ПОРУШЕНЬ.';

  @override
  String get madeWithLove => 'Зроблено з ❤️ для гравців Dune Awakening';
}
