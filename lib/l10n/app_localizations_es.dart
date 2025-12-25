// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dune Awakening Companion';

  @override
  String get dashboardTitle => 'Tablero';

  @override
  String get charactersTitle => 'Personajes';

  @override
  String get basesTitle => 'Bases';

  @override
  String get expiringSoonTitle => 'Vence Pronto';

  @override
  String get activeAlertsTitle => 'Alertas Activas';

  @override
  String get error => 'Error';

  @override
  String get navDashboard => 'Tablero';

  @override
  String get navCharacters => 'Personajes';

  @override
  String get navAlerts => 'Alertas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get alertsTitle => 'Alertas';

  @override
  String get refreshTooltip => 'Actualizar';

  @override
  String get allBasesSafeTitle => '¡Todas las bases están seguras!';

  @override
  String get allBasesSafeMessage =>
      'No hay bases que caduquen en las próximas 48 horas.';

  @override
  String get timeRemainingPower => 'Tiempo Restante: Energía';

  @override
  String get timeRemainingTaxes => 'Tiempo Restante: Impuestos';

  @override
  String get expiresLabel => 'Expira';

  @override
  String get dueLabel => 'Vence';

  @override
  String get tapToManage => 'Toca para gestionar las bases';

  @override
  String get loading => 'Cargando...';

  @override
  String get notificationHistoryTooltip => 'Historial de Notificaciones';

  @override
  String get addBaseTooltip => 'Añadir Base';

  @override
  String get updateCountdownTooltip => 'Actualizar cuenta regresiva';
}
