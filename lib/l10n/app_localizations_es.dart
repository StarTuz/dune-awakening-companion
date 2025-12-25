// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Compañero de Dune Awakening';

  @override
  String get navDashboard => 'Tablero';

  @override
  String get navCharacters => 'Personajes';

  @override
  String get navAlerts => 'Alertas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get dashboardTitle => 'Tablero';

  @override
  String get charactersTitle => 'Personajes';

  @override
  String get basesTitle => 'Bases';

  @override
  String get alertsTitle => 'Alertas';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get expiringSoonTitle => 'Próximos a Expirar';

  @override
  String get activeAlertsTitle => 'Alertas Activas';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando...';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get ok => 'Aceptar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get refreshTooltip => 'Actualizar';

  @override
  String get notificationHistoryTooltip => 'Historial de Notificaciones';

  @override
  String get addBaseTooltip => 'Agregar Base';

  @override
  String get updateCountdownTooltip => 'Actualizar cuenta regresiva';

  @override
  String get addCharacterTooltip => 'Agregar Personaje';

  @override
  String get allBasesSafeTitle => '¡Todas las bases están seguras!';

  @override
  String get allBasesSafeMessage =>
      'Ninguna base expira en las próximas 48 horas.';

  @override
  String get timeRemainingPower => 'Tiempo Restante: Energía';

  @override
  String get timeRemainingTaxes => 'Tiempo Restante: Impuestos';

  @override
  String get expiresLabel => 'Expira';

  @override
  String get dueLabel => 'Vence';

  @override
  String get tapToManage => 'Toca para administrar las bases de este personaje';

  @override
  String get severityCritical => 'CRÍTICO';

  @override
  String get severityWarning => 'ADVERTENCIA';

  @override
  String taxOverdueLabel(String time) {
    return 'Vencido: $time';
  }

  @override
  String get daysAbbr => 'd';

  @override
  String get hoursAbbr => 'h';

  @override
  String get minutesAbbr => 'm';

  @override
  String get sectionAbout => 'Acerca de';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get sectionDataManagement => 'Gestión de Datos';

  @override
  String get sectionAccessibility => 'Accesibilidad';

  @override
  String get sectionNotifications => 'Notificaciones';

  @override
  String get sectionLegal => 'Legal y Reconocimientos';

  @override
  String get version => 'Versión';

  @override
  String get databaseVersion => 'Versión de Base de Datos';

  @override
  String get build => 'Compilación';

  @override
  String get features => 'Características';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get desertNightTheme => 'Tema Noche del Desierto';

  @override
  String get desertDayTheme => 'Tema Día del Desierto';

  @override
  String get factionTheme => 'Tema de Facción';

  @override
  String get chooseFaction => 'Elige Tu Facción';

  @override
  String get factionDesert => 'Desierto (Predeterminado)';

  @override
  String get factionDesertDesc => 'Arena cálida y oro de especia';

  @override
  String get factionAtreides => 'Casa Atreides';

  @override
  String get factionAtreidesDesc => 'Verde y negro - La casa noble';

  @override
  String get factionHarkonnen => 'Casa Harkonnen';

  @override
  String get factionHarkonnenDesc => 'Rojo y negro - Los gobernantes brutales';

  @override
  String get factionFremen => 'Fremen';

  @override
  String get factionFremenDesc => 'Arena y azul - Los guerreros del desierto';

  @override
  String get factionSmuggler => 'Contrabandista';

  @override
  String get factionSmugglerDesc =>
      'Púrpura y bronce - Los comerciantes de las sombras';

  @override
  String get language => 'Idioma';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get exportDataDesc => 'Respaldar todos los personajes y bases';

  @override
  String get importData => 'Importar Datos';

  @override
  String get importDataDesc => 'Restaurar desde respaldo';

  @override
  String get clearAllData => 'Borrar Todos los Datos';

  @override
  String get clearAllDataDesc => 'Eliminar todos los personajes y bases';

  @override
  String get textSize => 'Tamaño de Texto';

  @override
  String get textSizeSmall => 'Pequeño';

  @override
  String get textSizeMedium => 'Mediano';

  @override
  String get textSizeLarge => 'Grande';

  @override
  String get textSizeXL => 'Extra Grande';

  @override
  String get textWeight => 'Grosor de Texto';

  @override
  String get textWeightLight => 'Ligero';

  @override
  String get textWeightRegular => 'Regular';

  @override
  String get textWeightBold => 'Negrita';

  @override
  String get highContrast => 'Alto Contraste';

  @override
  String get highContrastEnabled => 'Contraste de color mejorado';

  @override
  String get highContrastDisabled => 'Contraste de color estándar';

  @override
  String get reduceMotion => 'Reducir Movimiento';

  @override
  String get reduceMotionEnabled => 'Animaciones desactivadas';

  @override
  String get reduceMotionDisabled => 'Animaciones activadas';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get enableNotifications => 'Activar Notificaciones';

  @override
  String get notificationsEnabled => 'Se enviarán alertas';

  @override
  String get notificationsDisabled => 'No se enviarán alertas';

  @override
  String get checkInterval => 'Intervalo de Verificación';

  @override
  String get checkIntervalDesc => 'Con qué frecuencia verificar alertas';

  @override
  String get minutes => 'minutos';

  @override
  String get quietHours => 'Horas de Silencio';

  @override
  String get quietHoursEnabled => 'No molestar activado';

  @override
  String get quietHoursDisabled => 'Notificaciones a todas horas';

  @override
  String get quietHoursStart => 'Hora de Inicio';

  @override
  String get quietHoursEnd => 'Hora de Fin';

  @override
  String get sound => 'Sonido';

  @override
  String get soundEnabled => 'Sonidos de notificación activados';

  @override
  String get soundDisabled => 'Sonidos de notificación desactivados';

  @override
  String get vibration => 'Vibración';

  @override
  String get vibrationEnabled => 'Retroalimentación háptica activada';

  @override
  String get vibrationDisabled => 'Retroalimentación háptica desactivada';

  @override
  String get notificationHistory => 'Historial de Notificaciones';

  @override
  String get viewHistory => 'Ver Historial';

  @override
  String get clearHistory => 'Borrar Historial';

  @override
  String get noNotifications => 'Sin notificaciones aún';

  @override
  String get noHistoryTitle => 'Sin historial de notificaciones';

  @override
  String get noHistorySubtitle =>
      'Las notificaciones aparecerán aquí cuando se envíen';

  @override
  String entriesUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sin leer',
      one: '1 sin leer',
    );
    return '$_temp0';
  }

  @override
  String get allRead => 'Todo leído';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get deleteOlderThan7Days => 'Eliminar anteriores a 7 días';

  @override
  String get clearAllHistory => 'Borrar todo el historial';

  @override
  String get clearHistoryMessage =>
      '¿Eliminar todo el historial de notificaciones?';

  @override
  String get deletedOldNotifications =>
      'Se eliminaron las notificaciones de más de 7 días';

  @override
  String errorLoadingHistory(String error) {
    return 'Error al cargar el historial: $error';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get testAlerts => 'Probar Alertas';

  @override
  String get checkingAlerts => 'Comprobando alertas...';

  @override
  String get checkComplete =>
      '✅ ¡Comprobación completa! Notificaciones enviadas si las bases necesitan atención.';

  @override
  String get importantDisclaimer => 'Aviso Importante';

  @override
  String get disclaimerText =>
      'Esta es una aplicación no oficial hecha por fans. NO está afiliada, respaldada ni apoyada por Funcom. Funcom no participó en el desarrollo. Dune Awakening es una marca registrada de Funcom. Dune y elementos relacionados son marcas registradas de Herbert Properties LLC.';

  @override
  String get acknowledgments => 'Agradecimientos';

  @override
  String get ackHerbert => 'Herbert Estate por el universo Dune';

  @override
  String get ackFuncom => 'Funcom por Dune Awakening';

  @override
  String get ackCommunity => 'Comunidad de Dune Awakening';

  @override
  String get ackFlutter => 'Framework Flutter';

  @override
  String get characterName => 'Nombre del Personaje';

  @override
  String get enterCharacterName => 'Ingresa el nombre del personaje';

  @override
  String get provider => 'Proveedor';

  @override
  String get worldServerName => 'Nombre del Mundo/Servidor';

  @override
  String get enterPrivateServerName => 'Ingresa el nombre del servidor privado';

  @override
  String get enterSietchName => 'Ingresa el nombre del sietch';

  @override
  String get remove => 'Eliminar';

  @override
  String get region => 'Región';

  @override
  String get serverType => 'Tipo de Servidor';

  @override
  String get official => 'Oficial';

  @override
  String get private => 'Privado';

  @override
  String get world => 'Mundo';

  @override
  String get sietch => 'Sietch';

  @override
  String get portrait => 'Retrato';

  @override
  String get addPortrait => 'Agregar Retrato';

  @override
  String get removePortrait => 'Eliminar Retrato';

  @override
  String get addCharacter => 'Agregar Personaje';

  @override
  String get editCharacter => 'Editar Personaje';

  @override
  String get deleteCharacter => 'Eliminar Personaje';

  @override
  String get deleteCharacterConfirm =>
      '¿Eliminar este personaje? Esto también eliminará todas sus bases.';

  @override
  String deleteCharacterMessage(String name) {
    return '¿Estás seguro de que quieres eliminar a $name?';
  }

  @override
  String characterBasesTitle(String name) {
    return '$name - Bases';
  }

  @override
  String get noBasesMessage =>
      'Aún no hay bases. ¡Agrega una usando el botón +!';

  @override
  String powerRemaining(String time) {
    return 'Energía: restan $time';
  }

  @override
  String get powerExpired => 'Energía: Agotada';

  @override
  String get noCharactersMessage =>
      'Aún no hay personajes. Agrega uno para comenzar.';

  @override
  String get basesButton => 'Bases';

  @override
  String get baseName => 'Nombre de la Base';

  @override
  String get powerDays => 'Días';

  @override
  String get powerHours => 'Horas';

  @override
  String get powerMinutes => 'Minutos';

  @override
  String get advancedFief => 'Feudo Avanzado';

  @override
  String get advancedFiefDesc => 'Activar para seguimiento de impuestos';

  @override
  String get addBase => 'Agregar Base';

  @override
  String get editBase => 'Editar Base';

  @override
  String get deleteBase => 'Eliminar Base';

  @override
  String get deleteBaseConfirm => '¿Eliminar esta base?';

  @override
  String get power => 'Energía';

  @override
  String get taxes => 'Impuestos';

  @override
  String get taxPerCycle => 'Impuesto por Ciclo';

  @override
  String get currentOwed => 'Adeudo Actual';

  @override
  String get overdueOwed => 'Adeudo Vencido';

  @override
  String get defaultedOwed => 'Adeudo en Mora';

  @override
  String get statusPaid => 'PAGADO';

  @override
  String get statusDue => 'PENDIENTE';

  @override
  String get statusOverdue => 'VENCIDO';

  @override
  String get statusDefaulted => 'EN MORA';

  @override
  String get statusCritical => 'CRÍTICO';

  @override
  String get statusWarning => 'ADVERTENCIA';

  @override
  String get statusSafe => 'SEGURO';

  @override
  String get noCharacters => 'Sin personajes aún';

  @override
  String get noCharactersDesc => 'Toca + para agregar tu primer personaje';

  @override
  String get noBases => 'Sin bases aún';

  @override
  String get noBasesDesc => 'Toca + para agregar una base';

  @override
  String get powerCritical => '¡Energía Crítica!';

  @override
  String get taxOverdue => '¡Impuestos Vencidos!';

  @override
  String get exportSuccess => 'Datos exportados exitosamente';

  @override
  String get exportFailed => 'Exportación fallida';

  @override
  String get importSuccess => 'Datos importados exitosamente';

  @override
  String get importFailed => 'Error al importar';

  @override
  String get exportingData => 'Exportando datos...';

  @override
  String dataExportedTo(String path) {
    return 'Datos exportados a:\n$path';
  }

  @override
  String get exportFailedTryAgain =>
      'Error al exportar. Por favor, inténtelo de nuevo.';

  @override
  String get importBackup => 'Importar Copia de Seguridad';

  @override
  String get backupContains => 'La copia de seguridad contiene:';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personajes',
      one: '1 personaje',
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
      other: '$count retratos',
      one: '1 retrato',
    );
    return '$_temp0';
  }

  @override
  String get formatZip => 'ZIP (con retratos)';

  @override
  String get formatLegacyJson => 'JSON Legado';

  @override
  String get chooseImportMode => 'Elija el modo de importación:';

  @override
  String get replaceAllDataTitle => '¿Reemplazar todos los datos?';

  @override
  String get replaceAllDataContent =>
      'Esto ELIMINARÁ todos los personajes y bases existentes, y luego importará los datos de la copia de seguridad.\n\n¡Esta acción no se puede deshacer!';

  @override
  String get replaceEverything => 'Reemplazar Todo';

  @override
  String get importingData => 'Importando datos...';

  @override
  String get importSuccessful => '¡Importación exitosa!';

  @override
  String importSummary(int characters, int bases, String portraits) {
    return '$characters personajes, $bases bases$portraits importados';
  }

  @override
  String get importMode => 'Modo de Importación';

  @override
  String get importMerge => 'Fusionar';

  @override
  String get importMergeDesc => 'Agregar a datos existentes';

  @override
  String get importReplace => 'Reemplazar';

  @override
  String get importReplaceDesc => 'Borrar todos los datos primero';

  @override
  String get clearDataConfirm => '¿Borrar todos los datos?';

  @override
  String get clearDataConfirmDesc =>
      'Esto eliminará todos los personajes y bases. No se puede deshacer.';

  @override
  String get dataCleared => 'Todos los datos borrados';

  @override
  String get deleteEverything => 'Eliminar Todo';

  @override
  String errorClearingData(String error) {
    return 'Error al eliminar datos: $error';
  }

  @override
  String get receiveAlertsForExpiring =>
      'Recibir alertas para bases por expirar';

  @override
  String get notificationsDisabledDesc => 'Notificaciones desactivadas';

  @override
  String checkEveryMinutes(int minutes) {
    return 'Verificar cada $minutes minutos';
  }

  @override
  String get warningNotifications => 'Notificaciones de Advertencia';

  @override
  String get alertFor48h => 'Alertar para < 48h (advertencias + crítico)';

  @override
  String get alertFor24hOnly => 'Alertar para < 24h solamente (crítico)';

  @override
  String get notificationSound => 'Sonido de Notificación';

  @override
  String get playSoundWithNotifications =>
      'Reproducir sonido con notificaciones';

  @override
  String get silentNotifications => 'Notificaciones silenciosas';

  @override
  String get vibrateWithNotifications => 'Vibrar con notificaciones';

  @override
  String get noVibration => 'Sin vibración';

  @override
  String get startMinimizedToTray => 'Iniciar Minimizado en Bandeja';

  @override
  String get launchAppInTray => 'Iniciar app en bandeja del sistema';

  @override
  String noNotificationsFromTo(String start, String end) {
    return 'Sin notificaciones $start - $end';
  }

  @override
  String get notificationsAlwaysEnabled => 'Notificaciones siempre activadas';

  @override
  String get startTime => 'Hora de Inicio';

  @override
  String get endTime => 'Hora de Fin';

  @override
  String get testNotification => 'Probar Notificación';

  @override
  String get sendTestNotification => 'Enviar una notificación de prueba';

  @override
  String get test => 'Probar';

  @override
  String get copyrightNotices => 'Avisos de Derechos de Autor';

  @override
  String get copyrightApp => '© 2025 Dune Awakening Companion App';

  @override
  String get copyrightFuncom =>
      'Dune Awakening es una marca registrada de Funcom. Todos los derechos reservados.';

  @override
  String get copyrightHerbert =>
      'Dune y elementos relacionados son marcas comerciales o marcas registradas de Herbert Properties LLC. Todos los derechos reservados.';

  @override
  String get specialThanks => 'Agradecimientos Especiales';

  @override
  String get thanksHerbert =>
      'Al Herbert Estate por crear el increíble universo de Dune que ha inspirado a generaciones de fans.';

  @override
  String get thanksFuncom =>
      'A Funcom por desarrollar Dune Awakening y dar vida a Arrakis en una experiencia de juego inmersiva.';

  @override
  String get thanksCommunity =>
      'A la comunidad de Dune Awakening por su pasión y apoyo.';

  @override
  String get thanksAI =>
      'Creado en Google Antigravity \"Thinking Machine\" IDE con humanos y Claude Sonnet 4.5 (quien vigila atentamente—nada de \"Jihad Butleriana\" gracias).';

  @override
  String get openSourceLicense => 'Licencia de Código Abierto';

  @override
  String get mitLicense => 'Licencia MIT';

  @override
  String get mitLicenseBody =>
      'Se concede permiso por la presente, de forma gratuita, a cualquier persona que obtenga una copia de este software y de los archivos de documentación asociados (el \"Software\"), para tratar con el Software sin restricción, incluyendo, sin limitación, los derechos de uso, copia, modificación, fusión, publicación, distribución, sublicencia y/o venta de copias del Software, y para permitir a las personas a quienes se les proporcione el Software hacerlo, con sujeción a las siguientes condiciones:\n\nEl aviso de copyright anterior y este aviso de permiso se incluirán en todas las copias o partes sustanciales del Software.\n\nEL SOFTWARE SE PROPORCIONA \"TAL CUAL\", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O IMPLÍCITA, INCLUYENDO, PERO SIN LIMITARSE A, GARANTÍAS DE COMERCIALIZACIÓN, IDONEIDAD PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN.';

  @override
  String get madeWithLove => 'Hecho con ❤️ para jugadores de Dune Awakening';
}
