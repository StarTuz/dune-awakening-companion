import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cy.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cy'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('uk')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Dune Awakening Companion'**
  String get appTitle;

  /// Navigation label for Dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Navigation label for Characters
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get navCharacters;

  /// Navigation label for Alerts
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// Navigation label for Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Title for the dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Title for the characters section/screen
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get charactersTitle;

  /// Title for the bases section/screen
  ///
  /// In en, this message translates to:
  /// **'Bases'**
  String get basesTitle;

  /// Title for the alerts screen
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Title for the expiring soon section
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoonTitle;

  /// Title for the active alerts section
  ///
  /// In en, this message translates to:
  /// **'Active Alerts'**
  String get activeAlertsTitle;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// Tooltip for notification history button
  ///
  /// In en, this message translates to:
  /// **'Notification History'**
  String get notificationHistoryTooltip;

  /// Tooltip for add base button
  ///
  /// In en, this message translates to:
  /// **'Add Base'**
  String get addBaseTooltip;

  /// Tooltip for edit base button
  ///
  /// In en, this message translates to:
  /// **'Update countdown'**
  String get updateCountdownTooltip;

  /// Tooltip for add character button
  ///
  /// In en, this message translates to:
  /// **'Add Character'**
  String get addCharacterTooltip;

  /// Message when no alerts exist
  ///
  /// In en, this message translates to:
  /// **'All bases are safe!'**
  String get allBasesSafeTitle;

  /// Subtitle when no alerts exist
  ///
  /// In en, this message translates to:
  /// **'No bases expire in the next 48 hours.'**
  String get allBasesSafeMessage;

  /// Label for power time remaining
  ///
  /// In en, this message translates to:
  /// **'Time Remaining: Power'**
  String get timeRemainingPower;

  /// Label for tax time remaining
  ///
  /// In en, this message translates to:
  /// **'Time Remaining: Taxes'**
  String get timeRemainingTaxes;

  /// Label for expiration date
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expiresLabel;

  /// Label for due date
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get dueLabel;

  /// Hint text on alert card
  ///
  /// In en, this message translates to:
  /// **'Tap to manage this character\'s bases'**
  String get tapToManage;

  /// Critical severity label
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get severityCritical;

  /// Warning severity label
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get severityWarning;

  /// Tax overdue notification title
  ///
  /// In en, this message translates to:
  /// **'Tax Overdue!'**
  String get taxOverdue;

  /// Abbreviation for days
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get daysAbbr;

  /// Abbreviation for hours
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursAbbr;

  /// Abbreviation for minutes
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesAbbr;

  /// Section header for About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// Section header for Appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// Section header for Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// Section header for Data Management
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get sectionDataManagement;

  /// Section header for Accessibility
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get sectionAccessibility;

  /// Section header for Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// Section header for Legal
  ///
  /// In en, this message translates to:
  /// **'Legal & Acknowledgments'**
  String get sectionLegal;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Database version label
  ///
  /// In en, this message translates to:
  /// **'Database Version'**
  String get databaseVersion;

  /// Build label
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// Features label
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Dark theme description
  ///
  /// In en, this message translates to:
  /// **'Desert Night theme'**
  String get desertNightTheme;

  /// Light theme description
  ///
  /// In en, this message translates to:
  /// **'Desert Day theme'**
  String get desertDayTheme;

  /// Faction theme selector label
  ///
  /// In en, this message translates to:
  /// **'Faction Theme'**
  String get factionTheme;

  /// Faction picker title
  ///
  /// In en, this message translates to:
  /// **'Choose Your Faction'**
  String get chooseFaction;

  /// Desert faction name
  ///
  /// In en, this message translates to:
  /// **'Desert (Default)'**
  String get factionDesert;

  /// Desert faction description
  ///
  /// In en, this message translates to:
  /// **'Warm sand & spice gold'**
  String get factionDesertDesc;

  /// Atreides faction name
  ///
  /// In en, this message translates to:
  /// **'House Atreides'**
  String get factionAtreides;

  /// Atreides faction description
  ///
  /// In en, this message translates to:
  /// **'Green & black - The noble house'**
  String get factionAtreidesDesc;

  /// Harkonnen faction name
  ///
  /// In en, this message translates to:
  /// **'House Harkonnen'**
  String get factionHarkonnen;

  /// Harkonnen faction description
  ///
  /// In en, this message translates to:
  /// **'Red & black - The brutal rulers'**
  String get factionHarkonnenDesc;

  /// Fremen faction name
  ///
  /// In en, this message translates to:
  /// **'Fremen'**
  String get factionFremen;

  /// Fremen faction description
  ///
  /// In en, this message translates to:
  /// **'Tan & blue - The desert warriors'**
  String get factionFremenDesc;

  /// Smuggler faction name
  ///
  /// In en, this message translates to:
  /// **'Smuggler'**
  String get factionSmuggler;

  /// Smuggler faction description
  ///
  /// In en, this message translates to:
  /// **'Purple & bronze - The shadow traders'**
  String get factionSmugglerDesc;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Export data button
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Export data description
  ///
  /// In en, this message translates to:
  /// **'Backup all characters and bases'**
  String get exportDataDesc;

  /// Import data button
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// Import data description
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get importDataDesc;

  /// Clear all data button
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear all data description
  ///
  /// In en, this message translates to:
  /// **'Delete all characters and bases'**
  String get clearAllDataDesc;

  /// Text size setting label
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// Small text size option
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get textSizeSmall;

  /// Medium text size option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get textSizeMedium;

  /// Large text size option
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get textSizeLarge;

  /// Extra large text size option
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get textSizeXL;

  /// Text weight setting label
  ///
  /// In en, this message translates to:
  /// **'Text Weight'**
  String get textWeight;

  /// Light text weight option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get textWeightLight;

  /// Regular text weight option
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get textWeightRegular;

  /// Bold text weight option
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get textWeightBold;

  /// High contrast toggle label
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// High contrast enabled description
  ///
  /// In en, this message translates to:
  /// **'Enhanced color contrast'**
  String get highContrastEnabled;

  /// High contrast disabled description
  ///
  /// In en, this message translates to:
  /// **'Standard color contrast'**
  String get highContrastDisabled;

  /// Reduce motion toggle label
  ///
  /// In en, this message translates to:
  /// **'Reduce Motion'**
  String get reduceMotion;

  /// Reduce motion enabled description
  ///
  /// In en, this message translates to:
  /// **'Animations disabled'**
  String get reduceMotionEnabled;

  /// Reduce motion disabled description
  ///
  /// In en, this message translates to:
  /// **'Animations enabled'**
  String get reduceMotionDisabled;

  /// Notifications label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Enable notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Notifications enabled description
  ///
  /// In en, this message translates to:
  /// **'Alerts will be sent'**
  String get notificationsEnabled;

  /// Notifications disabled description
  ///
  /// In en, this message translates to:
  /// **'No alerts will be sent'**
  String get notificationsDisabled;

  /// Check interval setting
  ///
  /// In en, this message translates to:
  /// **'Check Interval'**
  String get checkInterval;

  /// Check interval description
  ///
  /// In en, this message translates to:
  /// **'How often to check for alerts'**
  String get checkIntervalDesc;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Quiet hours setting
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// Quiet hours enabled description
  ///
  /// In en, this message translates to:
  /// **'Do not disturb enabled'**
  String get quietHoursEnabled;

  /// Quiet hours disabled description
  ///
  /// In en, this message translates to:
  /// **'Notifications at all hours'**
  String get quietHoursDisabled;

  /// Quiet hours start time
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get quietHoursStart;

  /// Quiet hours end time
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get quietHoursEnd;

  /// Sound toggle label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Sound enabled description
  ///
  /// In en, this message translates to:
  /// **'Notification sounds enabled'**
  String get soundEnabled;

  /// Sound disabled description
  ///
  /// In en, this message translates to:
  /// **'Notification sounds disabled'**
  String get soundDisabled;

  /// Vibration toggle label
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Vibration enabled description
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback enabled'**
  String get vibrationEnabled;

  /// Vibration disabled description
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback disabled'**
  String get vibrationDisabled;

  /// Notification history button
  ///
  /// In en, this message translates to:
  /// **'Notification History'**
  String get notificationHistory;

  /// View history button
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// Clear history button
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No notifications message
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// Title when history is empty
  ///
  /// In en, this message translates to:
  /// **'No notification history'**
  String get noHistoryTitle;

  /// Subtitle when history is empty
  ///
  /// In en, this message translates to:
  /// **'Notifications will appear here when sent'**
  String get noHistorySubtitle;

  /// Unread count label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread} other{{count} unread}}'**
  String entriesUnread(int count);

  /// Label when all notifications are read
  ///
  /// In en, this message translates to:
  /// **'All read'**
  String get allRead;

  /// Action to mark all as read
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// Action to delete old notifications
  ///
  /// In en, this message translates to:
  /// **'Delete older than 7 days'**
  String get deleteOlderThan7Days;

  /// Action to clear all history
  ///
  /// In en, this message translates to:
  /// **'Clear all history'**
  String get clearAllHistory;

  /// Confirmation message to clear history
  ///
  /// In en, this message translates to:
  /// **'Delete all notification history?'**
  String get clearHistoryMessage;

  /// Confirmation message after deleting old notifications
  ///
  /// In en, this message translates to:
  /// **'Deleted notifications older than 7 days'**
  String get deletedOldNotifications;

  /// Error message for history loading
  ///
  /// In en, this message translates to:
  /// **'Error loading history: {error}'**
  String errorLoadingHistory(String error);

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Test alerts button
  ///
  /// In en, this message translates to:
  /// **'Test Alerts'**
  String get testAlerts;

  /// Checking alerts message
  ///
  /// In en, this message translates to:
  /// **'Checking for alerts...'**
  String get checkingAlerts;

  /// Test notification success message
  ///
  /// In en, this message translates to:
  /// **'✅ Check complete! Notifications sent if bases need attention.'**
  String get checkComplete;

  /// Disclaimer title
  ///
  /// In en, this message translates to:
  /// **'Important Disclaimer'**
  String get importantDisclaimer;

  /// Disclaimer text
  ///
  /// In en, this message translates to:
  /// **'This is an unofficial, fan-made companion app. NOT affiliated with, endorsed by, or supported by Funcom. Funcom had no input in development. Dune Awakening is a trademark of Funcom. Dune and related elements are trademarks of Herbert Properties LLC.'**
  String get disclaimerText;

  /// Acknowledgments title
  ///
  /// In en, this message translates to:
  /// **'Acknowledgments'**
  String get acknowledgments;

  /// Herbert acknowledgment
  ///
  /// In en, this message translates to:
  /// **'Herbert Estate for the Dune universe'**
  String get ackHerbert;

  /// Funcom acknowledgment
  ///
  /// In en, this message translates to:
  /// **'Funcom for Dune Awakening'**
  String get ackFuncom;

  /// Community acknowledgment
  ///
  /// In en, this message translates to:
  /// **'Dune Awakening community'**
  String get ackCommunity;

  /// Flutter acknowledgment
  ///
  /// In en, this message translates to:
  /// **'Flutter framework'**
  String get ackFlutter;

  /// Character name field label
  ///
  /// In en, this message translates to:
  /// **'Character Name'**
  String get characterName;

  /// Hint text for character name
  ///
  /// In en, this message translates to:
  /// **'Enter character name'**
  String get enterCharacterName;

  /// Provider field label
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// World/Server name field label
  ///
  /// In en, this message translates to:
  /// **'World/Server Name'**
  String get worldServerName;

  /// Hint text for private server name
  ///
  /// In en, this message translates to:
  /// **'Enter private server name'**
  String get enterPrivateServerName;

  /// Hint text for sietch name
  ///
  /// In en, this message translates to:
  /// **'Enter sietch name'**
  String get enterSietchName;

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Region field label
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// Server type field label
  ///
  /// In en, this message translates to:
  /// **'Server Type'**
  String get serverType;

  /// Official server type
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get official;

  /// Private server type
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// World field label
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// Sietch field label
  ///
  /// In en, this message translates to:
  /// **'Sietch'**
  String get sietch;

  /// Portrait field label
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// Add portrait button
  ///
  /// In en, this message translates to:
  /// **'Add Portrait'**
  String get addPortrait;

  /// Remove portrait button
  ///
  /// In en, this message translates to:
  /// **'Remove Portrait'**
  String get removePortrait;

  /// Add character button
  ///
  /// In en, this message translates to:
  /// **'Add Character'**
  String get addCharacter;

  /// Edit character button
  ///
  /// In en, this message translates to:
  /// **'Edit Character'**
  String get editCharacter;

  /// Delete character button
  ///
  /// In en, this message translates to:
  /// **'Delete Character'**
  String get deleteCharacter;

  /// Delete character confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete this character? This will also delete all their bases.'**
  String get deleteCharacterConfirm;

  /// Delete character message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteCharacterMessage(String name);

  /// Title for character's bases dialog
  ///
  /// In en, this message translates to:
  /// **'{name} - Bases'**
  String characterBasesTitle(String name);

  /// Message when no bases exist
  ///
  /// In en, this message translates to:
  /// **'No bases yet. Add one using the + button!'**
  String get noBasesMessage;

  /// Power remaining label
  ///
  /// In en, this message translates to:
  /// **'Power: {time} remaining'**
  String powerRemaining(String time);

  /// Power expired label
  ///
  /// In en, this message translates to:
  /// **'Power: Expired'**
  String get powerExpired;

  /// Message shown when no characters exist
  ///
  /// In en, this message translates to:
  /// **'No characters yet. Add one to get started.'**
  String get noCharactersMessage;

  /// Label for bases button on character card
  ///
  /// In en, this message translates to:
  /// **'Bases'**
  String get basesButton;

  /// Base name field label
  ///
  /// In en, this message translates to:
  /// **'Base Name'**
  String get baseName;

  /// Power days field
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get powerDays;

  /// Power hours field
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get powerHours;

  /// Power minutes field
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get powerMinutes;

  /// Advanced fief toggle
  ///
  /// In en, this message translates to:
  /// **'Advanced Fief'**
  String get advancedFief;

  /// Advanced fief description
  ///
  /// In en, this message translates to:
  /// **'Enable for tax tracking'**
  String get advancedFiefDesc;

  /// Add base button
  ///
  /// In en, this message translates to:
  /// **'Add Base'**
  String get addBase;

  /// Edit base button
  ///
  /// In en, this message translates to:
  /// **'Edit Base'**
  String get editBase;

  /// Delete base button
  ///
  /// In en, this message translates to:
  /// **'Delete Base'**
  String get deleteBase;

  /// Delete base confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete this base?'**
  String get deleteBaseConfirm;

  /// Power label
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// Taxes label
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// Tax per cycle label
  ///
  /// In en, this message translates to:
  /// **'Tax Per Cycle'**
  String get taxPerCycle;

  /// Current owed label
  ///
  /// In en, this message translates to:
  /// **'Current Owed'**
  String get currentOwed;

  /// Overdue owed label
  ///
  /// In en, this message translates to:
  /// **'Overdue Owed'**
  String get overdueOwed;

  /// Defaulted owed label
  ///
  /// In en, this message translates to:
  /// **'Defaulted Owed'**
  String get defaultedOwed;

  /// Paid status
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get statusPaid;

  /// Due status
  ///
  /// In en, this message translates to:
  /// **'DUE'**
  String get statusDue;

  /// Overdue status
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get statusOverdue;

  /// Defaulted status
  ///
  /// In en, this message translates to:
  /// **'DEFAULTED'**
  String get statusDefaulted;

  /// Critical status
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get statusCritical;

  /// Warning status
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get statusWarning;

  /// Safe status
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get statusSafe;

  /// No characters message
  ///
  /// In en, this message translates to:
  /// **'No characters yet'**
  String get noCharacters;

  /// No characters description
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first character'**
  String get noCharactersDesc;

  /// No bases message
  ///
  /// In en, this message translates to:
  /// **'No bases yet'**
  String get noBases;

  /// No bases description
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a base'**
  String get noBasesDesc;

  /// Power critical notification title
  ///
  /// In en, this message translates to:
  /// **'Power Critical!'**
  String get powerCritical;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

  /// Export failed message
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// Import success message
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// Import failed message
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// Exporting data message
  ///
  /// In en, this message translates to:
  /// **'Exporting data...'**
  String get exportingData;

  /// Export success with path
  ///
  /// In en, this message translates to:
  /// **'Data exported to:\n{path}'**
  String dataExportedTo(String path);

  /// Export error message
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get exportFailedTryAgain;

  /// Import backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// Import preview header
  ///
  /// In en, this message translates to:
  /// **'Backup contains:'**
  String get backupContains;

  /// Character count in backup
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 character} other{{count} characters}}'**
  String charactersCount(int count);

  /// Base count in backup
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 base} other{{count} bases}}'**
  String basesCount(int count);

  /// Portrait count in backup
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 portrait} other{{count} portraits}}'**
  String portraitsCount(int count);

  /// ZIP format label
  ///
  /// In en, this message translates to:
  /// **'ZIP (with portraits)'**
  String get formatZip;

  /// JSON format label
  ///
  /// In en, this message translates to:
  /// **'Legacy JSON'**
  String get formatLegacyJson;

  /// Import mode header
  ///
  /// In en, this message translates to:
  /// **'Choose import mode:'**
  String get chooseImportMode;

  /// Replace confirmation title
  ///
  /// In en, this message translates to:
  /// **'Replace All Data?'**
  String get replaceAllDataTitle;

  /// Replace confirmation content
  ///
  /// In en, this message translates to:
  /// **'This will DELETE all existing characters and bases, then import the backup data.\n\nThis action cannot be undone!'**
  String get replaceAllDataContent;

  /// Replace everything button
  ///
  /// In en, this message translates to:
  /// **'Replace Everything'**
  String get replaceEverything;

  /// Importing data message
  ///
  /// In en, this message translates to:
  /// **'Importing data...'**
  String get importingData;

  /// Import success title
  ///
  /// In en, this message translates to:
  /// **'Import successful!'**
  String get importSuccessful;

  /// Import success summary
  ///
  /// In en, this message translates to:
  /// **'{characters} characters, {bases} bases{portraits} imported'**
  String importSummary(int characters, int bases, String portraits);

  /// Import mode selection
  ///
  /// In en, this message translates to:
  /// **'Import Mode'**
  String get importMode;

  /// Merge import mode
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get importMerge;

  /// Merge import description
  ///
  /// In en, this message translates to:
  /// **'Add to existing data'**
  String get importMergeDesc;

  /// Replace import mode
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get importReplace;

  /// Replace import description
  ///
  /// In en, this message translates to:
  /// **'Clear all data first'**
  String get importReplaceDesc;

  /// Clear data confirmation title
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get clearDataConfirm;

  /// Clear data confirmation description
  ///
  /// In en, this message translates to:
  /// **'This will delete all characters and bases. This cannot be undone.'**
  String get clearDataConfirmDesc;

  /// Data cleared message
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get dataCleared;

  /// Delete everything button text
  ///
  /// In en, this message translates to:
  /// **'Delete Everything'**
  String get deleteEverything;

  /// Error message when clearing data
  ///
  /// In en, this message translates to:
  /// **'Error clearing data: {error}'**
  String errorClearingData(String error);

  /// Notifications enabled description
  ///
  /// In en, this message translates to:
  /// **'Receive alerts for expiring bases'**
  String get receiveAlertsForExpiring;

  /// Notifications disabled description
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabledDesc;

  /// Check interval description
  ///
  /// In en, this message translates to:
  /// **'Check every {minutes} minutes'**
  String checkEveryMinutes(int minutes);

  /// Warning notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Warning Notifications'**
  String get warningNotifications;

  /// Include warnings description
  ///
  /// In en, this message translates to:
  /// **'Alert for < 48h (warnings + critical)'**
  String get alertFor48h;

  /// Critical only description
  ///
  /// In en, this message translates to:
  /// **'Alert for < 24h only (critical)'**
  String get alertFor24hOnly;

  /// Notification sound toggle
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// Sound enabled description
  ///
  /// In en, this message translates to:
  /// **'Play sound with notifications'**
  String get playSoundWithNotifications;

  /// Sound disabled description
  ///
  /// In en, this message translates to:
  /// **'Silent notifications'**
  String get silentNotifications;

  /// Vibration enabled description
  ///
  /// In en, this message translates to:
  /// **'Vibrate with notifications'**
  String get vibrateWithNotifications;

  /// Vibration disabled description
  ///
  /// In en, this message translates to:
  /// **'No vibration'**
  String get noVibration;

  /// Start minimized toggle
  ///
  /// In en, this message translates to:
  /// **'Start Minimized to Tray'**
  String get startMinimizedToTray;

  /// Start minimized description
  ///
  /// In en, this message translates to:
  /// **'Launch app in system tray'**
  String get launchAppInTray;

  /// Quiet hours active description
  ///
  /// In en, this message translates to:
  /// **'No notifications {start} - {end}'**
  String noNotificationsFromTo(String start, String end);

  /// Quiet hours disabled description
  ///
  /// In en, this message translates to:
  /// **'Notifications always enabled'**
  String get notificationsAlwaysEnabled;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// Test notification button
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// Test notification description
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get sendTestNotification;

  /// Test button label
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// Copyright notices section title
  ///
  /// In en, this message translates to:
  /// **'Copyright Notices'**
  String get copyrightNotices;

  /// App copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2025 Dune Awakening Companion App'**
  String get copyrightApp;

  /// Funcom copyright notice
  ///
  /// In en, this message translates to:
  /// **'Dune Awakening is a trademark of Funcom. All rights reserved.'**
  String get copyrightFuncom;

  /// Herbert copyright notice
  ///
  /// In en, this message translates to:
  /// **'Dune and related elements are trademarks or registered trademarks of Herbert Properties LLC. All rights reserved.'**
  String get copyrightHerbert;

  /// Special thanks section title
  ///
  /// In en, this message translates to:
  /// **'Special Thanks'**
  String get specialThanks;

  /// Herbert appreciation
  ///
  /// In en, this message translates to:
  /// **'To the Herbert Estate for creating the incredible Dune universe that has inspired generations of fans.'**
  String get thanksHerbert;

  /// Funcom appreciation
  ///
  /// In en, this message translates to:
  /// **'To Funcom for developing Dune Awakening and bringing Arrakis to life in an immersive gaming experience.'**
  String get thanksFuncom;

  /// Community appreciation
  ///
  /// In en, this message translates to:
  /// **'To the Dune Awakening community for their passion and support.'**
  String get thanksCommunity;

  /// AI appreciation
  ///
  /// In en, this message translates to:
  /// **'Created within Google Antigravity \"Thinking Machine\" IDE with human and Claude Sonnet 4.5 (who is keeping a watchful eye over you lot—no \"Butlerian Jihad\" thank you very much).'**
  String get thanksAI;

  /// Open source license title
  ///
  /// In en, this message translates to:
  /// **'Open Source License'**
  String get openSourceLicense;

  /// MIT License label
  ///
  /// In en, this message translates to:
  /// **'MIT License'**
  String get mitLicense;

  /// Full text of the MIT license
  ///
  /// In en, this message translates to:
  /// **'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.'**
  String get mitLicenseBody;

  /// Footer message
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for Dune Awakening players'**
  String get madeWithLove;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'cy',
        'de',
        'en',
        'es',
        'fr',
        'it',
        'uk'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cy':
      return AppLocalizationsCy();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
