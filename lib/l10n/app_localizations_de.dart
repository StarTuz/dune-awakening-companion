// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Begleiter';

  @override
  String get navDashboard => 'Übersicht';

  @override
  String get navCharacters => 'Charaktere';

  @override
  String get navAlerts => 'Warnungen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get dashboardTitle => 'Übersicht';

  @override
  String get charactersTitle => 'Charaktere';

  @override
  String get basesTitle => 'Basen';

  @override
  String get alertsTitle => 'Warnungen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get expiringSoonTitle => 'Läuft Bald Ab';

  @override
  String get activeAlertsTitle => 'Aktive Warnungen';

  @override
  String get error => 'Fehler';

  @override
  String get loading => 'Laden...';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schließen';

  @override
  String get refreshTooltip => 'Aktualisieren';

  @override
  String get notificationHistoryTooltip => 'Benachrichtigungsverlauf';

  @override
  String get addBaseTooltip => 'Basis hinzufügen';

  @override
  String get updateCountdownTooltip => 'Countdown aktualisieren';

  @override
  String get addCharacterTooltip => 'Charakter hinzufügen';

  @override
  String get allBasesSafeTitle => 'Alle Basen sind sicher!';

  @override
  String get allBasesSafeMessage =>
      'Keine Basis läuft in den nächsten 48 Stunden ab.';

  @override
  String get timeRemainingPower => 'Verbleibende Zeit: Energie';

  @override
  String get timeRemainingTaxes => 'Verbleibende Zeit: Steuern';

  @override
  String get expiresLabel => 'Läuft ab';

  @override
  String get dueLabel => 'Fällig';

  @override
  String get tapToManage =>
      'Tippen, um die Basen dieses Charakters zu verwalten';

  @override
  String get severityCritical => 'KRITISCH';

  @override
  String get severityWarning => 'WARNUNG';

  @override
  String taxOverdueLabel(String time) {
    return 'Überfällig: $time';
  }

  @override
  String get daysAbbr => 'T';

  @override
  String get hoursAbbr => 'Std';

  @override
  String get minutesAbbr => 'Min';

  @override
  String get sectionAbout => 'Über';

  @override
  String get sectionAppearance => 'Erscheinungsbild';

  @override
  String get sectionLanguage => 'Sprache';

  @override
  String get sectionDataManagement => 'Datenverwaltung';

  @override
  String get sectionAccessibility => 'Barrierefreiheit';

  @override
  String get sectionNotifications => 'Benachrichtigungen';

  @override
  String get sectionLegal => 'Rechtliches & Danksagungen';

  @override
  String get version => 'Version';

  @override
  String get databaseVersion => 'Datenbankversion';

  @override
  String get build => 'Build';

  @override
  String get features => 'Funktionen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get desertNightTheme => 'Wüstennacht-Thema';

  @override
  String get desertDayTheme => 'Wüstentag-Thema';

  @override
  String get factionTheme => 'Fraktions-Thema';

  @override
  String get chooseFaction => 'Wähle Deine Fraktion';

  @override
  String get factionDesert => 'Wüste (Standard)';

  @override
  String get factionDesertDesc => 'Warmer Sand & Gewürzgold';

  @override
  String get factionAtreides => 'Haus Atreides';

  @override
  String get factionAtreidesDesc => 'Grün & Schwarz - Das edle Haus';

  @override
  String get factionHarkonnen => 'Haus Harkonnen';

  @override
  String get factionHarkonnenDesc => 'Rot & Schwarz - Die brutalen Herrscher';

  @override
  String get factionFremen => 'Fremen';

  @override
  String get factionFremenDesc => 'Sand & Blau - Die Wüstenkrieger';

  @override
  String get factionSmuggler => 'Schmuggler';

  @override
  String get factionSmugglerDesc => 'Lila & Bronze - Die Schattenhändler';

  @override
  String get language => 'Sprache';

  @override
  String get exportData => 'Daten Exportieren';

  @override
  String get exportDataDesc => 'Alle Charaktere und Basen sichern';

  @override
  String get importData => 'Daten Importieren';

  @override
  String get importDataDesc => 'Aus Sicherung wiederherstellen';

  @override
  String get clearAllData => 'Alle Daten Löschen';

  @override
  String get clearAllDataDesc => 'Alle Charaktere und Basen löschen';

  @override
  String get textSize => 'Textgröße';

  @override
  String get textSizeSmall => 'Klein';

  @override
  String get textSizeMedium => 'Mittel';

  @override
  String get textSizeLarge => 'Groß';

  @override
  String get textSizeXL => 'Sehr Groß';

  @override
  String get textWeight => 'Schriftstärke';

  @override
  String get textWeightLight => 'Leicht';

  @override
  String get textWeightRegular => 'Normal';

  @override
  String get textWeightBold => 'Fett';

  @override
  String get highContrast => 'Hoher Kontrast';

  @override
  String get highContrastEnabled => 'Erhöhter Farbkontrast';

  @override
  String get highContrastDisabled => 'Standard-Farbkontrast';

  @override
  String get reduceMotion => 'Bewegung Reduzieren';

  @override
  String get reduceMotionEnabled => 'Animationen deaktiviert';

  @override
  String get reduceMotionDisabled => 'Animationen aktiviert';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get enableNotifications => 'Benachrichtigungen Aktivieren';

  @override
  String get notificationsEnabled => 'Warnungen werden gesendet';

  @override
  String get notificationsDisabled => 'Keine Warnungen werden gesendet';

  @override
  String get checkInterval => 'Prüfintervall';

  @override
  String get checkIntervalDesc => 'Wie oft nach Warnungen prüfen';

  @override
  String get minutes => 'Minuten';

  @override
  String get quietHours => 'Ruhezeiten';

  @override
  String get quietHoursEnabled => 'Nicht stören aktiviert';

  @override
  String get quietHoursDisabled => 'Benachrichtigungen zu jeder Zeit';

  @override
  String get quietHoursStart => 'Startzeit';

  @override
  String get quietHoursEnd => 'Endzeit';

  @override
  String get sound => 'Ton';

  @override
  String get soundEnabled => 'Benachrichtigungstöne aktiviert';

  @override
  String get soundDisabled => 'Benachrichtigungstöne deaktiviert';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationEnabled => 'Haptisches Feedback aktiviert';

  @override
  String get vibrationDisabled => 'Haptisches Feedback deaktiviert';

  @override
  String get notificationHistory => 'Benachrichtigungsverlauf';

  @override
  String get viewHistory => 'Verlauf Anzeigen';

  @override
  String get clearHistory => 'Verlauf Löschen';

  @override
  String get noNotifications => 'Noch keine Benachrichtigungen';

  @override
  String get noHistoryTitle => 'Kein Benachrichtigungsverlauf';

  @override
  String get noHistorySubtitle =>
      'Benachrichtigungen erscheinen hier, wenn sie gesendet werden';

  @override
  String entriesUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ungelesen',
      one: '1 ungelesen',
    );
    return '$_temp0';
  }

  @override
  String get allRead => 'Alles gelesen';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get deleteOlderThan7Days => 'Älter als 7 Tage löschen';

  @override
  String get clearAllHistory => 'Gesamten Verlauf löschen';

  @override
  String get clearHistoryMessage =>
      'Gesamten Benachrichtigungsverlauf löschen?';

  @override
  String get deletedOldNotifications =>
      'Benachrichtigungen älter als 7 Tage gelöscht';

  @override
  String errorLoadingHistory(String error) {
    return 'Fehler beim Laden des Verlaufs: $error';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get testAlerts => 'Warnungen Testen';

  @override
  String get checkingAlerts => 'Prüfe Warnungen...';

  @override
  String get checkComplete =>
      '✅ Prüfung abgeschlossen! Benachrichtigungen gesendet, wenn Basen Aufmerksamkeit benötigen.';

  @override
  String get importantDisclaimer => 'Wichtiger Hinweis';

  @override
  String get disclaimerText =>
      'Dies ist eine inoffizielle, von Fans erstellte App. NICHT mit Funcom verbunden, gebilligt oder unterstützt. Funcom war nicht an der Entwicklung beteiligt. Dune Awakening ist eine Marke von Funcom. Dune und verwandte Elemente sind Marken von Herbert Properties LLC.';

  @override
  String get acknowledgments => 'Danksagungen';

  @override
  String get ackHerbert => 'Herbert Estate für das Dune-Universum';

  @override
  String get ackFuncom => 'Funcom für Dune Awakening';

  @override
  String get ackCommunity => 'Dune Awakening Community';

  @override
  String get ackFlutter => 'Flutter Framework';

  @override
  String get characterName => 'Charaktername';

  @override
  String get enterCharacterName => 'Charaktername eingeben';

  @override
  String get provider => 'Anbieter';

  @override
  String get worldServerName => 'Welt/Servername';

  @override
  String get enterPrivateServerName => 'Privaten Servernamen eingeben';

  @override
  String get enterSietchName => 'Sietch-Namen eingeben';

  @override
  String get remove => 'Entfernen';

  @override
  String get region => 'Region';

  @override
  String get serverType => 'Servertyp';

  @override
  String get official => 'Offiziell';

  @override
  String get private => 'Privat';

  @override
  String get world => 'Welt';

  @override
  String get sietch => 'Sietch';

  @override
  String get portrait => 'Portrait';

  @override
  String get addPortrait => 'Portrait Hinzufügen';

  @override
  String get removePortrait => 'Portrait Entfernen';

  @override
  String get addCharacter => 'Charakter Hinzufügen';

  @override
  String get editCharacter => 'Charakter Bearbeiten';

  @override
  String get deleteCharacter => 'Charakter Löschen';

  @override
  String get deleteCharacterConfirm =>
      'Diesen Charakter löschen? Dies wird auch alle seine Basen löschen.';

  @override
  String deleteCharacterMessage(String name) {
    return 'Bist du sicher, dass du $name löschen möchtest?';
  }

  @override
  String characterBasesTitle(String name) {
    return '$name - Basen';
  }

  @override
  String get noBasesMessage =>
      'Noch keine Basen. Füge eine mit dem + Button hinzu!';

  @override
  String powerRemaining(String time) {
    return 'Energie: $time verbleibend';
  }

  @override
  String get powerExpired => 'Energie: Abgelaufen';

  @override
  String get noCharactersMessage =>
      'Noch keine Charaktere. Füge einen hinzu, um loszulegen.';

  @override
  String get basesButton => 'Basen';

  @override
  String get baseName => 'Basisname';

  @override
  String get powerDays => 'Tage';

  @override
  String get powerHours => 'Stunden';

  @override
  String get powerMinutes => 'Minuten';

  @override
  String get advancedFief => 'Erweitertes Lehen';

  @override
  String get advancedFiefDesc => 'Für Steuerverfolgung aktivieren';

  @override
  String get addBase => 'Basis Hinzufügen';

  @override
  String get editBase => 'Basis Bearbeiten';

  @override
  String get deleteBase => 'Basis Löschen';

  @override
  String get deleteBaseConfirm => 'Diese Basis löschen?';

  @override
  String get power => 'Energie';

  @override
  String get taxes => 'Steuern';

  @override
  String get taxPerCycle => 'Steuer Pro Zyklus';

  @override
  String get currentOwed => 'Aktuell Geschuldet';

  @override
  String get overdueOwed => 'Überfällig Geschuldet';

  @override
  String get defaultedOwed => 'Ausgefallen Geschuldet';

  @override
  String get statusPaid => 'BEZAHLT';

  @override
  String get statusDue => 'FÄLLIG';

  @override
  String get statusOverdue => 'ÜBERFÄLLIG';

  @override
  String get statusDefaulted => 'AUSGEFALLEN';

  @override
  String get statusCritical => 'KRITISCH';

  @override
  String get statusWarning => 'WARNUNG';

  @override
  String get statusSafe => 'SICHER';

  @override
  String get noCharacters => 'Noch keine Charaktere';

  @override
  String get noCharactersDesc =>
      'Tippe +, um deinen ersten Charakter hinzuzufügen';

  @override
  String get noBases => 'Noch keine Basen';

  @override
  String get noBasesDesc => 'Tippe +, um eine Basis hinzuzufügen';

  @override
  String get powerCritical => 'Energie Kritisch!';

  @override
  String get taxOverdue => 'Steuern Überfällig!';

  @override
  String get exportSuccess => 'Daten erfolgreich exportiert';

  @override
  String get exportFailed => 'Export fehlgeschlagen';

  @override
  String get importSuccess => 'Daten erfolgreich importiert';

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String get exportingData => 'Daten werden exportiert...';

  @override
  String dataExportedTo(String path) {
    return 'Daten exportiert nach:\n$path';
  }

  @override
  String get exportFailedTryAgain =>
      'Export fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get importBackup => 'Sicherung importieren';

  @override
  String get backupContains => 'Sicherung enthält:';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Charaktere',
      one: '1 Charakter',
    );
    return '$_temp0';
  }

  @override
  String basesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Basen',
      one: '1 Basis',
    );
    return '$_temp0';
  }

  @override
  String portraitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portraits',
      one: '1 Portrait',
    );
    return '$_temp0';
  }

  @override
  String get formatZip => 'ZIP (mit Portraits)';

  @override
  String get formatLegacyJson => 'Veraltetes JSON';

  @override
  String get chooseImportMode => 'Importmodus wählen:';

  @override
  String get replaceAllDataTitle => 'Alle Daten ersetzen?';

  @override
  String get replaceAllDataContent =>
      'Dies wird ALLE vorhandenen Charaktere und Basen LÖSCHEN und dann die Sicherungsdaten importieren.\n\nDiese Aktion kann nicht rückgängig gemacht werden!';

  @override
  String get replaceEverything => 'Alles ersetzen';

  @override
  String get importingData => 'Daten werden importiert...';

  @override
  String get importSuccessful => 'Import erfolgreich!';

  @override
  String importSummary(int characters, int bases, String portraits) {
    return '$characters Charaktere, $bases Basen$portraits importiert';
  }

  @override
  String get importMode => 'Importmodus';

  @override
  String get importMerge => 'Zusammenführen';

  @override
  String get importMergeDesc => 'Zu bestehenden Daten hinzufügen';

  @override
  String get importReplace => 'Ersetzen';

  @override
  String get importReplaceDesc => 'Alle Daten zuerst löschen';

  @override
  String get clearDataConfirm => 'Alle Daten löschen?';

  @override
  String get clearDataConfirmDesc =>
      'Dies löscht alle Charaktere und Basen. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get dataCleared => 'Alle Daten gelöscht';

  @override
  String get deleteEverything => 'Alles löschen';

  @override
  String errorClearingData(String error) {
    return 'Fehler beim Löschen der Daten: $error';
  }

  @override
  String get receiveAlertsForExpiring =>
      'Warnungen für ablaufende Basen erhalten';

  @override
  String get notificationsDisabledDesc => 'Benachrichtigungen deaktiviert';

  @override
  String checkEveryMinutes(int minutes) {
    return 'Alle $minutes Minuten prüfen';
  }

  @override
  String get warningNotifications => 'Warnbenachrichtigungen';

  @override
  String get alertFor48h => 'Warnung für < 48h (Warnungen + Kritisch)';

  @override
  String get alertFor24hOnly => 'Warnung für < 24h nur (Kritisch)';

  @override
  String get notificationSound => 'Benachrichtigungston';

  @override
  String get playSoundWithNotifications =>
      'Ton bei Benachrichtigungen abspielen';

  @override
  String get silentNotifications => 'Lautlose Benachrichtigungen';

  @override
  String get vibrateWithNotifications => 'Bei Benachrichtigungen vibrieren';

  @override
  String get noVibration => 'Keine Vibration';

  @override
  String get startMinimizedToTray => 'Minimiert starten';

  @override
  String get launchAppInTray => 'App im Systemtray starten';

  @override
  String noNotificationsFromTo(String start, String end) {
    return 'Keine Benachrichtigungen $start - $end';
  }

  @override
  String get notificationsAlwaysEnabled => 'Benachrichtigungen immer aktiviert';

  @override
  String get startTime => 'Startzeit';

  @override
  String get endTime => 'Endzeit';

  @override
  String get testNotification => 'Testbenachrichtigung';

  @override
  String get sendTestNotification => 'Testbenachrichtigung senden';

  @override
  String get test => 'Testen';

  @override
  String get copyrightNotices => 'Urheberrechtshinweise';

  @override
  String get copyrightApp => '© 2025 Dune Awakening Companion App';

  @override
  String get copyrightFuncom =>
      'Dune Awakening ist eine Marke von Funcom. Alle Rechte vorbehalten.';

  @override
  String get copyrightHerbert =>
      'Dune und verwandte Elemente sind Marken oder eingetragene Marken von Herbert Properties LLC. Alle Rechte vorbehalten.';

  @override
  String get specialThanks => 'Besonderer Dank';

  @override
  String get thanksHerbert =>
      'An das Herbert Estate für die Erschaffung des unglaublichen Dune-Universums, das Generationen von Fans inspiriert hat.';

  @override
  String get thanksFuncom =>
      'An Funcom für die Entwicklung von Dune Awakening und dafür, Arrakis in einem immersiven Spielerlebnis zum Leben zu erwecken.';

  @override
  String get thanksCommunity =>
      'An die Dune Awakening Community für ihre Leidenschaft und Unterstützung.';

  @override
  String get thanksAI =>
      'Erstellt innerhalb der Google Antigravity \"Thinking Machine\" IDE mit Menschen und Claude Sonnet 4.5 (der ein wachsames Auge auf euch alle hat – kein \"Butlers Djihad\", vielen Dank).';

  @override
  String get openSourceLicense => 'Open-Source-Lizenz';

  @override
  String get mitLicense => 'MIT-Lizenz';

  @override
  String get mitLicenseBody =>
      'Hiermit wird unentgeltlich jeder Person, die eine Kopie der Software und der zugehörigen Dokumentationsdateien (die \"Software\") erhält, die Erlaubnis erteilt, uneingeschränkt mit der Software zu handeln, einschließlich, aber nicht beschränkt auf das Recht, die Software zu verwenden, zu kopieren, zu ändern, zusammenzuführen, zu veröffentlichen, zu vertreiben, unterzulizenzieren und/oder Kopien der Software zu verkaufen, und Personen, denen die Software überlassen wird, dies zu gestatten, unter den folgenden Bedingungen:\n\nDer obige Urheberrechtshinweis und dieser Genehmigungshinweis müssen in allen Kopien oder wesentlichen Teilen der Software enthalten sein.\n\nDIE SOFTWARE WIRD \"WIE BESEHEN\" BEREITGESTELLT, OHNE JEGLICHE AUSDRÜCKLICHE ODER STILLSCHWEIGENDE GARANTIE, EINSCHLIESSLICH, ABER NICHT BESCHRÄNKT AUF DIE GEWÄHRLEISTUNG DER MARKTGÄNGIGKEIT, DER EIGNUNG FÜR EINEN BESTIMMTEN ZWECK UND DER NICHTVERLETZUNG VON RECHTEN DRITTER.';

  @override
  String get madeWithLove => 'Mit ❤️ gemacht für Dune Awakening Spieler';
}
