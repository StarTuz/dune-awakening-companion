import '../../features/bases/models/base.dart';
import '../../features/bases/services/base_repository.dart';
import '../../features/characters/models/character.dart';
import '../../features/characters/services/character_repository.dart';

/// Represents a base that needs an alert
class BaseAlert {
  final Base base;
  final Character character;
  final AlertType type;
  final AlertSeverity severity;
  final Duration timeRemaining;

  BaseAlert({
    required this.base,
    required this.character,
    required this.type,
    required this.severity,
    required this.timeRemaining,
  });

  String get characterInfo => '${character.name} - ${character.world}';
}

enum AlertType {
  power,
  tax,
}

enum AlertSeverity {
  critical, // < 24 hours or overdue
  warning,  // < 48 hours
}

/// Service to check for bases that need alerts
class AlertCheckerService {
  final BaseRepository _baseRepository;
  final CharacterRepository _characterRepository;

  AlertCheckerService(this._baseRepository, this._characterRepository);

  /// Check all bases and return those needing alerts
  Future<List<BaseAlert>> checkForAlerts({
    bool includeWarnings = false, // If false, only critical alerts
  }) async {
    final alerts = <BaseAlert>[];
    final now = DateTime.now();

    // Get all bases
    final bases = await _baseRepository.getAll();

    // Get all characters (for lookup)
    final characters = await _characterRepository.getAll();
    final characterMap = {for (var c in characters) c.id: c};

    for (final base in bases) {
      final character = characterMap[base.characterId];
      if (character == null) continue; // Skip if character not found

      // Check power expiration
      final powerRemaining = base.powerExpirationTime.difference(now);
      if (powerRemaining.isNegative) {
        // Power expired
        alerts.add(BaseAlert(
          base: base,
          character: character,
          type: AlertType.power,
          severity: AlertSeverity.critical,
          timeRemaining: powerRemaining,
        ));
      } else if (powerRemaining.inHours < 24) {
        // Power critical (< 24h)
        alerts.add(BaseAlert(
          base: base,
          character: character,
          type: AlertType.power,
          severity: AlertSeverity.critical,
          timeRemaining: powerRemaining,
        ));
      } else if (includeWarnings && powerRemaining.inHours < 48) {
        // Power warning (< 48h)
        alerts.add(BaseAlert(
          base: base,
          character: character,
          type: AlertType.power,
          severity: AlertSeverity.warning,
          timeRemaining: powerRemaining,
        ));
      }

      // Check tax if applicable
      // Only alert if there's actual tax owed - don't alert for PAID status
      // Uses effective values which auto-calculate missed cycles
      if (base.isAdvancedFief && base.taxPerCycle != null && base.effectiveNextTaxDueDate != null) {
        final taxRemaining = base.effectiveNextTaxDueDate!.difference(now);
        final hasTaxOwed = base.totalTaxOwed > 0;
        
        // Only generate alerts if there's actually tax owed
        if (hasTaxOwed) {
          if (taxRemaining.isNegative || base.missedCycles > 0) {
            // Tax overdue (any missed cycles counts as overdue)
            alerts.add(BaseAlert(
              base: base,
              character: character,
              type: AlertType.tax,
              severity: AlertSeverity.critical,
              timeRemaining: taxRemaining,
            ));
          } else if (taxRemaining.inHours < 24) {
            // Tax due soon (< 24h)
            alerts.add(BaseAlert(
              base: base,
              character: character,
              type: AlertType.tax,
              severity: AlertSeverity.critical,
              timeRemaining: taxRemaining,
            ));
          } else if (includeWarnings && taxRemaining.inHours < 48) {
            // Tax warning (< 48h)
            alerts.add(BaseAlert(
              base: base,
              character: character,
              type: AlertType.tax,
              severity: AlertSeverity.warning,
              timeRemaining: taxRemaining,
            ));
          }
        }
      }
    }

    return alerts;
  }

  /// Get count of critical alerts
  Future<int> getCriticalAlertCount() async {
    final alerts = await checkForAlerts(includeWarnings: false);
    return alerts.length;
  }

  /// Check and trigger notifications for due bases
  Future<void> checkAndNotify({
    required Function(BaseAlert) onAlert,
    bool includeWarnings = false,
  }) async {
    final alerts = await checkForAlerts(includeWarnings: includeWarnings);
    
    for (final alert in alerts) {
      onAlert(alert);
    }
  }
}
