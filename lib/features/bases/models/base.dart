import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'base.g.dart';

/// Tax cycle length in days (based on game mechanics)
const int kTaxCycleDays = 14;

/// Grace period before shields go down (in days)
const int kGracePeriodDays = 14;

enum TaxStatus {
  none,       // Not an advanced fief
  paid,       // All paid up
  due,        // Current cycle due
  overdue,    // Past grace period start
  defaulted,  // Shields down
}

@JsonSerializable()
class Base implements BaseModel {
  @override
  final String id;
  final String characterId;
  final String name;
  final DateTime powerExpirationTime; // Manual entry
  @override
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Tax tracking fields
  final bool isAdvancedFief;           // true if pays taxes
  final int? taxPerCycle;              // Solari amount per cycle
  final DateTime? nextTaxDueDate;      // When next payment due
  final int? currentOwed;              // Current cycle amount owed
  final int? overdueOwed;              // Past cycles amount (in grace period)
  final int? defaultedOwed;            // After grace period (shields down)

  Base({
    required this.id,
    required this.characterId,
    required this.name,
    required this.powerExpirationTime,
    required this.createdAt,
    required this.updatedAt,
    this.isAdvancedFief = false,
    this.taxPerCycle,
    this.nextTaxDueDate,
    this.currentOwed,
    this.overdueOwed,
    this.defaultedOwed,
  });

  factory Base.fromJson(Map<String, dynamic> json) => _$BaseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$BaseToJson(this);

  /// Calculate hours remaining until power expiration
  double get hoursRemaining {
    final now = DateTime.now();
    final difference = powerExpirationTime.difference(now);
    return difference.inMinutes / 60.0;
  }

  /// Check if power has expired
  bool get isExpired => hoursRemaining <= 0;

  /// Check if power is expiring soon (within 24 hours)
  bool get isExpiringSoon => hoursRemaining <= 24 && !isExpired;
  
  /// Calculate total tax owed across all categories (uses raw stored values)
  int get storedTaxOwed => (currentOwed ?? 0) + (overdueOwed ?? 0) + (defaultedOwed ?? 0);
  
  /// Calculate how many tax cycles have been missed since nextTaxDueDate
  int get missedCycles {
    if (!isAdvancedFief || taxPerCycle == null || nextTaxDueDate == null) return 0;
    final now = DateTime.now();
    
    // If due date is still in the future, no cycles missed
    if (nextTaxDueDate!.isAfter(now)) return 0;
    
    // Due date is in the past - calculate how many complete cycles have passed
    // Use hours for more precision (avoids truncation issues with inDays)
    final hoursPastDue = now.difference(nextTaxDueDate!).inHours;
    final hoursPerCycle = kTaxCycleDays * 24;
    
    // At minimum 1 cycle if any time has passed beyond due date
    // Then add additional cycles for each complete 14-day period
    return (hoursPastDue / hoursPerCycle).ceil().clamp(1, 999);
  }
  
  /// Calculate effective current owed (auto-includes new cycle if due date passed)
  int get effectiveCurrentOwed {
    if (!isAdvancedFief || taxPerCycle == null) return 0;
    final cycles = missedCycles;
    if (cycles == 0) return currentOwed ?? 0;
    
    // If user has explicitly set all owed amounts to 0 (meaning they paid),
    // respect that and don't auto-add new debt. Just return 0.
    // The date will auto-roll forward, showing "Due in: X" for next cycle.
    if (storedTaxOwed == 0) return 0;
    
    // When cycles are missed AND there was unpaid tax,
    // current cycle tax is always taxPerCycle
    // (previous current owed moves to overdue/defaulted)
    return taxPerCycle!;
  }
  
  /// Calculate effective overdue owed (includes current that aged into overdue)
  int get effectiveOverdueOwed {
    if (!isAdvancedFief || taxPerCycle == null) return 0;
    final cycles = missedCycles;
    if (cycles == 0) return overdueOwed ?? 0;
    
    // If user has paid (all owed = 0), don't auto-add debt
    if (storedTaxOwed == 0) return 0;
    
    final now = DateTime.now();
    final daysPastDue = now.difference(nextTaxDueDate!).inDays;
    
    // If past grace period, everything goes to defaulted
    if (daysPastDue > kGracePeriodDays) return 0;
    
    // Within grace period: previous current becomes overdue
    // Plus any existing overdue, plus taxes for cycles between first and now
    final existingOverdue = overdueOwed ?? 0;
    final existingCurrent = currentOwed ?? 0;
    // Tax for the cycles that are now overdue (not including current cycle)
    final overdueFromCycles = (cycles > 1) ? taxPerCycle! * (cycles - 1) : 0;
    
    return existingOverdue + existingCurrent + overdueFromCycles;
  }
  
  /// Calculate effective defaulted owed (past grace period - shields down!)
  int get effectiveDefaultedOwed {
    if (!isAdvancedFief || taxPerCycle == null) return 0;
    final cycles = missedCycles;
    if (cycles == 0) return defaultedOwed ?? 0;
    
    // If user has paid (all owed = 0), don't auto-add debt
    if (storedTaxOwed == 0) return 0;
    
    final now = DateTime.now();
    final daysPastDue = now.difference(nextTaxDueDate!).inDays;
    
    // Only calculate defaulted if past grace period
    if (daysPastDue <= kGracePeriodDays) return defaultedOwed ?? 0;
    
    // Past grace: all existing owed + all missed cycle taxes go to defaulted
    final existingDefaulted = defaultedOwed ?? 0;
    final existingOverdue = overdueOwed ?? 0;
    final existingCurrent = currentOwed ?? 0;
    // All cycles except the current one go to defaulted
    final defaultedFromCycles = (cycles > 1) ? taxPerCycle! * (cycles - 1) : 0;
    
    return existingDefaulted + existingOverdue + existingCurrent + defaultedFromCycles;
  }
  
  /// Calculate effective next tax due date (rolled forward by missed cycles)
  DateTime? get effectiveNextTaxDueDate {
    if (nextTaxDueDate == null) return null;
    final cycles = missedCycles;
    if (cycles == 0) return nextTaxDueDate;
    
    // Roll forward by the number of missed cycles
    return nextTaxDueDate!.add(Duration(days: cycles * kTaxCycleDays));
  }
  
  /// Calculate total tax owed (uses effective values with auto-increment)
  int get totalTaxOwed => effectiveCurrentOwed + effectiveOverdueOwed + effectiveDefaultedOwed;
  
  /// Calculate days until next tax payment (uses effective date)
  double get daysUntilTax {
    final effectiveDate = effectiveNextTaxDueDate;
    if (effectiveDate == null) return double.infinity;
    final now = DateTime.now();
    final difference = effectiveDate.difference(now);
    return difference.inHours / 24.0;
  }
  
  /// Days past the original due date (for display)
  double get daysPastDue {
    if (nextTaxDueDate == null) return 0;
    final now = DateTime.now();
    final difference = now.difference(nextTaxDueDate!);
    if (difference.isNegative) return 0;
    return difference.inHours / 24.0;
  }
  
  /// Determine current tax status (uses effective values)
  TaxStatus get taxStatus {
    if (!isAdvancedFief || taxPerCycle == null) return TaxStatus.none;
    if (effectiveDefaultedOwed > 0) return TaxStatus.defaulted;
    if (effectiveOverdueOwed > 0) return TaxStatus.overdue;
    if (effectiveCurrentOwed > 0) return TaxStatus.due;
    return TaxStatus.paid;
  }
  
  /// Check if tax is critical (defaulted or very overdue)
  bool get isTaxCritical => taxStatus == TaxStatus.defaulted || 
                            (taxStatus == TaxStatus.overdue && daysPastDue > kGracePeriodDays);

  Base copyWith({
    String? id,
    String? characterId,
    String? name,
    DateTime? powerExpirationTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAdvancedFief,
    int? taxPerCycle,
    DateTime? nextTaxDueDate,
    int? currentOwed,
    int? overdueOwed,
    int? defaultedOwed,
  }) {
    return Base(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      powerExpirationTime: powerExpirationTime ?? this.powerExpirationTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAdvancedFief: isAdvancedFief ?? this.isAdvancedFief,
      taxPerCycle: taxPerCycle ?? this.taxPerCycle,
      nextTaxDueDate: nextTaxDueDate ?? this.nextTaxDueDate,
      currentOwed: currentOwed ?? this.currentOwed,
      overdueOwed: overdueOwed ?? this.overdueOwed,
      defaultedOwed: defaultedOwed ?? this.defaultedOwed,
    );
  }
}

