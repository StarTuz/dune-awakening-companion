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
  String get navDashboard => 'Dashboard';

  @override
  String get navCharacters => 'Characters';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navSettings => 'Settings';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get charactersTitle => 'Characters';

  @override
  String get basesTitle => 'Bases';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get expiringSoonTitle => 'Expiring Soon';

  @override
  String get activeAlertsTitle => 'Active Alerts';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get notificationHistoryTooltip => 'Notification History';

  @override
  String get addBaseTooltip => 'Add Base';

  @override
  String get updateCountdownTooltip => 'Update countdown';

  @override
  String get addCharacterTooltip => 'Add Character';

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
  String get severityCritical => 'CRITICAL';

  @override
  String get severityWarning => 'WARNING';

  @override
  String taxOverdueLabel(String time) {
    return 'Overdue: $time';
  }

  @override
  String get daysAbbr => 'd';

  @override
  String get hoursAbbr => 'h';

  @override
  String get minutesAbbr => 'm';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get sectionDataManagement => 'Data Management';

  @override
  String get sectionAccessibility => 'Accessibility';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get sectionLegal => 'Legal & Acknowledgments';

  @override
  String get version => 'Version';

  @override
  String get databaseVersion => 'Database Version';

  @override
  String get build => 'Build';

  @override
  String get features => 'Features';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get desertNightTheme => 'Desert Night theme';

  @override
  String get desertDayTheme => 'Desert Day theme';

  @override
  String get factionTheme => 'Faction Theme';

  @override
  String get chooseFaction => 'Choose Your Faction';

  @override
  String get factionDesert => 'Desert (Default)';

  @override
  String get factionDesertDesc => 'Warm sand & spice gold';

  @override
  String get factionAtreides => 'House Atreides';

  @override
  String get factionAtreidesDesc => 'Green & black - The noble house';

  @override
  String get factionHarkonnen => 'House Harkonnen';

  @override
  String get factionHarkonnenDesc => 'Red & black - The brutal rulers';

  @override
  String get factionFremen => 'Fremen';

  @override
  String get factionFremenDesc => 'Tan & blue - The desert warriors';

  @override
  String get factionSmuggler => 'Smuggler';

  @override
  String get factionSmugglerDesc => 'Purple & bronze - The shadow traders';

  @override
  String get language => 'Language';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataDesc => 'Backup all characters and bases';

  @override
  String get importData => 'Import Data';

  @override
  String get importDataDesc => 'Restore from backup';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataDesc => 'Delete all characters and bases';

  @override
  String get textSize => 'Text Size';

  @override
  String get textSizeSmall => 'Small';

  @override
  String get textSizeMedium => 'Medium';

  @override
  String get textSizeLarge => 'Large';

  @override
  String get textSizeXL => 'Extra Large';

  @override
  String get textWeight => 'Text Weight';

  @override
  String get textWeightLight => 'Light';

  @override
  String get textWeightRegular => 'Regular';

  @override
  String get textWeightBold => 'Bold';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get highContrastEnabled => 'Enhanced color contrast';

  @override
  String get highContrastDisabled => 'Standard color contrast';

  @override
  String get reduceMotion => 'Reduce Motion';

  @override
  String get reduceMotionEnabled => 'Animations disabled';

  @override
  String get reduceMotionDisabled => 'Animations enabled';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationsEnabled => 'Alerts will be sent';

  @override
  String get notificationsDisabled => 'No alerts will be sent';

  @override
  String get checkInterval => 'Check Interval';

  @override
  String get checkIntervalDesc => 'How often to check for alerts';

  @override
  String get minutes => 'minutes';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get quietHoursEnabled => 'Do not disturb enabled';

  @override
  String get quietHoursDisabled => 'Notifications at all hours';

  @override
  String get quietHoursStart => 'Start Time';

  @override
  String get quietHoursEnd => 'End Time';

  @override
  String get sound => 'Sound';

  @override
  String get soundEnabled => 'Notification sounds enabled';

  @override
  String get soundDisabled => 'Notification sounds disabled';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationEnabled => 'Haptic feedback enabled';

  @override
  String get vibrationDisabled => 'Haptic feedback disabled';

  @override
  String get notificationHistory => 'Notification History';

  @override
  String get viewHistory => 'View History';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noHistoryTitle => 'No notification history';

  @override
  String get noHistorySubtitle => 'Notifications will appear here when sent';

  @override
  String entriesUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String get allRead => 'All read';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get deleteOlderThan7Days => 'Delete older than 7 days';

  @override
  String get clearAllHistory => 'Clear all history';

  @override
  String get clearHistoryMessage => 'Delete all notification history?';

  @override
  String get deletedOldNotifications =>
      'Deleted notifications older than 7 days';

  @override
  String errorLoadingHistory(String error) {
    return 'Error loading history: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get testAlerts => 'Test Alerts';

  @override
  String get checkingAlerts => 'Checking for alerts...';

  @override
  String get checkComplete =>
      '✅ Check complete! Notifications sent if bases need attention.';

  @override
  String get importantDisclaimer => 'Important Disclaimer';

  @override
  String get disclaimerText =>
      'This is an unofficial, fan-made companion app. NOT affiliated with, endorsed by, or supported by Funcom. Funcom had no input in development. Dune Awakening is a trademark of Funcom. Dune and related elements are trademarks of Herbert Properties LLC.';

  @override
  String get acknowledgments => 'Acknowledgments';

  @override
  String get ackHerbert => 'Herbert Estate for the Dune universe';

  @override
  String get ackFuncom => 'Funcom for Dune Awakening';

  @override
  String get ackCommunity => 'Dune Awakening community';

  @override
  String get ackFlutter => 'Flutter framework';

  @override
  String get characterName => 'Character Name';

  @override
  String get enterCharacterName => 'Enter character name';

  @override
  String get provider => 'Provider';

  @override
  String get worldServerName => 'World/Server Name';

  @override
  String get enterPrivateServerName => 'Enter private server name';

  @override
  String get enterSietchName => 'Enter sietch name';

  @override
  String get remove => 'Remove';

  @override
  String get region => 'Region';

  @override
  String get serverType => 'Server Type';

  @override
  String get official => 'Official';

  @override
  String get private => 'Private';

  @override
  String get world => 'World';

  @override
  String get sietch => 'Sietch';

  @override
  String get portrait => 'Portrait';

  @override
  String get addPortrait => 'Add Portrait';

  @override
  String get removePortrait => 'Remove Portrait';

  @override
  String get addCharacter => 'Add Character';

  @override
  String get editCharacter => 'Edit Character';

  @override
  String get deleteCharacter => 'Delete Character';

  @override
  String get deleteCharacterConfirm =>
      'Delete this character? This will also delete all their bases.';

  @override
  String deleteCharacterMessage(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String characterBasesTitle(String name) {
    return '$name - Bases';
  }

  @override
  String get noBasesMessage => 'No bases yet. Add one using the + button!';

  @override
  String powerRemaining(String time) {
    return 'Power: $time remaining';
  }

  @override
  String get powerExpired => 'Power: Expired';

  @override
  String get noCharactersMessage =>
      'No characters yet. Add one to get started.';

  @override
  String get basesButton => 'Bases';

  @override
  String get baseName => 'Base Name';

  @override
  String get powerDays => 'Days';

  @override
  String get powerHours => 'Hours';

  @override
  String get powerMinutes => 'Minutes';

  @override
  String get advancedFief => 'Advanced Fief';

  @override
  String get advancedFiefDesc => 'Enable for tax tracking';

  @override
  String get addBase => 'Add Base';

  @override
  String get editBase => 'Edit Base';

  @override
  String get deleteBase => 'Delete Base';

  @override
  String get deleteBaseConfirm => 'Delete this base?';

  @override
  String get power => 'Power';

  @override
  String get taxes => 'Taxes';

  @override
  String get taxPerCycle => 'Tax Per Cycle';

  @override
  String get currentOwed => 'Current Owed';

  @override
  String get overdueOwed => 'Overdue Owed';

  @override
  String get defaultedOwed => 'Defaulted Owed';

  @override
  String get statusPaid => 'PAID';

  @override
  String get statusDue => 'DUE';

  @override
  String get statusOverdue => 'OVERDUE';

  @override
  String get statusDefaulted => 'DEFAULTED';

  @override
  String get statusCritical => 'CRITICAL';

  @override
  String get statusWarning => 'WARNING';

  @override
  String get statusSafe => 'SAFE';

  @override
  String get noCharacters => 'No characters yet';

  @override
  String get noCharactersDesc => 'Tap + to add your first character';

  @override
  String get noBases => 'No bases yet';

  @override
  String get noBasesDesc => 'Tap + to add a base';

  @override
  String get powerCritical => 'Power Critical!';

  @override
  String get taxOverdue => 'Tax Overdue!';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importFailed => 'Import failed';

  @override
  String get exportingData => 'Exporting data...';

  @override
  String dataExportedTo(String path) {
    return 'Data exported to:\n$path';
  }

  @override
  String get exportFailedTryAgain => 'Export failed. Please try again.';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get backupContains => 'Backup contains:';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters',
      one: '1 character',
    );
    return '$_temp0';
  }

  @override
  String basesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bases',
      one: '1 base',
    );
    return '$_temp0';
  }

  @override
  String portraitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portraits',
      one: '1 portrait',
    );
    return '$_temp0';
  }

  @override
  String get formatZip => 'ZIP (with portraits)';

  @override
  String get formatLegacyJson => 'Legacy JSON';

  @override
  String get chooseImportMode => 'Choose import mode:';

  @override
  String get replaceAllDataTitle => 'Replace All Data?';

  @override
  String get replaceAllDataContent =>
      'This will DELETE all existing characters and bases, then import the backup data.\n\nThis action cannot be undone!';

  @override
  String get replaceEverything => 'Replace Everything';

  @override
  String get importingData => 'Importing data...';

  @override
  String get importSuccessful => 'Import successful!';

  @override
  String importSummary(int characters, int bases, String portraits) {
    return '$characters characters, $bases bases$portraits imported';
  }

  @override
  String get importMode => 'Import Mode';

  @override
  String get importMerge => 'Merge';

  @override
  String get importMergeDesc => 'Add to existing data';

  @override
  String get importReplace => 'Replace';

  @override
  String get importReplaceDesc => 'Clear all data first';

  @override
  String get clearDataConfirm => 'Clear all data?';

  @override
  String get clearDataConfirmDesc =>
      'This will delete all characters and bases. This cannot be undone.';

  @override
  String get dataCleared => 'All data cleared';

  @override
  String get deleteEverything => 'Delete Everything';

  @override
  String errorClearingData(String error) {
    return 'Error clearing data: $error';
  }

  @override
  String get receiveAlertsForExpiring => 'Receive alerts for expiring bases';

  @override
  String get notificationsDisabledDesc => 'Notifications disabled';

  @override
  String checkEveryMinutes(int minutes) {
    return 'Check every $minutes minutes';
  }

  @override
  String get warningNotifications => 'Warning Notifications';

  @override
  String get alertFor48h => 'Alert for < 48h (warnings + critical)';

  @override
  String get alertFor24hOnly => 'Alert for < 24h only (critical)';

  @override
  String get notificationSound => 'Notification Sound';

  @override
  String get playSoundWithNotifications => 'Play sound with notifications';

  @override
  String get silentNotifications => 'Silent notifications';

  @override
  String get vibrateWithNotifications => 'Vibrate with notifications';

  @override
  String get noVibration => 'No vibration';

  @override
  String get startMinimizedToTray => 'Start Minimized to Tray';

  @override
  String get launchAppInTray => 'Launch app in system tray';

  @override
  String noNotificationsFromTo(String start, String end) {
    return 'No notifications $start - $end';
  }

  @override
  String get notificationsAlwaysEnabled => 'Notifications always enabled';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String get test => 'Test';

  @override
  String get copyrightNotices => 'Copyright Notices';

  @override
  String get copyrightApp => '© 2025 Dune Awakening Companion App';

  @override
  String get copyrightFuncom =>
      'Dune Awakening is a trademark of Funcom. All rights reserved.';

  @override
  String get copyrightHerbert =>
      'Dune and related elements are trademarks or registered trademarks of Herbert Properties LLC. All rights reserved.';

  @override
  String get specialThanks => 'Special Thanks';

  @override
  String get thanksHerbert =>
      'To the Herbert Estate for creating the incredible Dune universe that has inspired generations of fans.';

  @override
  String get thanksFuncom =>
      'To Funcom for developing Dune Awakening and bringing Arrakis to life in an immersive gaming experience.';

  @override
  String get thanksCommunity =>
      'To the Dune Awakening community for their passion and support.';

  @override
  String get thanksAI =>
      'Created within Google Antigravity \"Thinking Machine\" IDE with human and Claude Sonnet 4.5 (who is keeping a watchful eye over you lot—no \"Butlerian Jihad\" thank you very much).';

  @override
  String get openSourceLicense => 'Open Source License';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get mitLicenseBody =>
      'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.';

  @override
  String get madeWithLove => 'Made with ❤️ for Dune Awakening players';
}
