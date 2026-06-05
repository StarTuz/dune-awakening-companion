import 'base_calculator_plan.dart';
import 'base_calculator_state.dart';

/// Versioned portable plan payload for JSON file export/import and sharing.
///
/// Omits DB identifiers and timestamps so guild mates can exchange builds
/// without carrying local IDs. See Phase 4 in
/// `docs/RESEARCH_BASE_CALCULATOR.md`.
class BaseCalculatorPortablePlan {
  static const String format = 'dune-base-calculator-plan';
  static const int version = 1;

  final String name;
  final bool deepDesertDiscountEnabled;
  final Map<String, int> itemQuantities;
  final Map<String, int> storageQuantities;
  final DateTime? exportedAt;

  const BaseCalculatorPortablePlan({
    required this.name,
    this.deepDesertDiscountEnabled = false,
    this.itemQuantities = const {},
    this.storageQuantities = const {},
    this.exportedAt,
  });

  factory BaseCalculatorPortablePlan.fromState(
    BaseCalculatorState state, {
    String? name,
  }) {
    return BaseCalculatorPortablePlan(
      name: name ?? state.activePlanName ?? '',
      deepDesertDiscountEnabled: state.deepDesertDiscount,
      itemQuantities: Map<String, int>.from(state.quantities),
      storageQuantities: Map<String, int>.from(state.storageQuantities),
      exportedAt: DateTime.now().toUtc(),
    );
  }

  factory BaseCalculatorPortablePlan.fromPlan(BaseCalculatorPlan plan) {
    return BaseCalculatorPortablePlan(
      name: plan.name,
      deepDesertDiscountEnabled: plan.deepDesertDiscountEnabled,
      itemQuantities: Map<String, int>.from(plan.itemQuantities),
      storageQuantities: Map<String, int>.from(plan.storageQuantities),
      exportedAt: DateTime.now().toUtc(),
    );
  }

  factory BaseCalculatorPortablePlan.fromJson(Map<String, dynamic> json) {
    if (json['format'] == format) {
      return BaseCalculatorPortablePlan(
        name: json['name'] as String? ?? '',
        deepDesertDiscountEnabled:
            json['deepDesertDiscountEnabled'] as bool? ?? false,
        itemQuantities: BaseCalculatorPlan.decodeQuantitiesMap(
          json['itemQuantities'],
        ),
        storageQuantities: BaseCalculatorPlan.decodeQuantitiesMap(
          json['storageQuantities'],
        ),
        exportedAt: json['exportedAt'] == null
            ? null
            : DateTime.tryParse(json['exportedAt'] as String),
      );
    }

    // Accept a persisted plan export (e.g. from ZIP backup) for convenience.
    final plan = BaseCalculatorPlan.fromJson(json);
    return BaseCalculatorPortablePlan.fromPlan(plan);
  }

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'version': version,
      'exportedAt': (exportedAt ?? DateTime.now().toUtc()).toIso8601String(),
      'name': name,
      'deepDesertDiscountEnabled': deepDesertDiscountEnabled,
      'itemQuantities': itemQuantities,
      'storageQuantities': storageQuantities,
    };
  }

  BaseCalculatorState toCalculatorState() {
    return BaseCalculatorState(
      quantities: Map<String, int>.from(itemQuantities),
      storageQuantities: Map<String, int>.from(storageQuantities),
      deepDesertDiscount: deepDesertDiscountEnabled,
      activePlanName: name.isEmpty ? null : name,
    );
  }

  bool get isEmpty =>
      itemQuantities.isEmpty &&
      storageQuantities.isEmpty &&
      !deepDesertDiscountEnabled;
}
