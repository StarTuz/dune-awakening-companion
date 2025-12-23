import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'base.g.dart';

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
  
  /// Calculate total tax owed across all categories
  int get totalTaxOwed => (currentOwed ?? 0) + (overdueOwed ?? 0) + (defaultedOwed ?? 0);
  
  /// Calculate days until next tax payment
  double get daysUntilTax {
    if (nextTaxDueDate == null) return double.infinity;
    final now = DateTime.now();
    final difference = nextTaxDueDate!.difference(now);
    return difference.inHours / 24.0;
  }
  
  /// Determine current tax status
  TaxStatus get taxStatus {
    if (!isAdvancedFief || taxPerCycle == null) return TaxStatus.none;
    if (defaultedOwed != null && defaultedOwed! > 0) return TaxStatus.defaulted;
    if (overdueOwed != null && overdueOwed! > 0) return TaxStatus.overdue;
    if (currentOwed != null && currentOwed! > 0) return TaxStatus.due;
    if (daysUntilTax < 0) return TaxStatus.due; // Past due date
    return TaxStatus.paid;
  }
  
  /// Check if tax is critical (defaulted or very overdue)
  bool get isTaxCritical => taxStatus == TaxStatus.defaulted || 
                            (taxStatus == TaxStatus.overdue && daysUntilTax < -14);

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

