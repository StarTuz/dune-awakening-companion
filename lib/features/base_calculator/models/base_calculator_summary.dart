import 'base_calculator_catalog.dart';

/// Aggregated results for a set of item selections.
///
/// All math is pure and lives in [BaseCalculatorSummary.fromQuantities] so it
/// can be unit-tested without any Flutter or Riverpod dependency.
class BaseCalculatorSummary {
  /// Total power produced by selected generators.
  final int generatedPower;

  /// Total power consumed by selected consumers (reported as a positive
  /// magnitude).
  final int usedPower;

  /// Resource name -> total quantity required, after any Deep Desert discount.
  /// Sorted by descending quantity then name for stable display.
  final Map<String, int> resourceTotals;

  /// Whether the Deep Desert 50% material discount was applied.
  final bool deepDesertDiscountApplied;

  const BaseCalculatorSummary({
    required this.generatedPower,
    required this.usedPower,
    required this.resourceTotals,
    required this.deepDesertDiscountApplied,
  });

  /// Net power: generated minus used. Negative means the build needs more
  /// generation. Power is never affected by the Deep Desert discount.
  int get netPower => generatedPower - usedPower;

  /// True when generators do not cover the placed consumers.
  bool get hasPowerDeficit => netPower < 0;

  /// True when nothing is selected.
  bool get isEmpty => generatedPower == 0 && usedPower == 0;

  /// Compute a summary from a `code -> quantity` selection map.
  ///
  /// Unknown codes and non-positive quantities are ignored. When
  /// [deepDesertDiscount] is true, resource totals are reduced by 50% (rounded
  /// up so the plan never under-provisions); power is intentionally left
  /// unchanged because the Deep Desert discount applies to materials only.
  factory BaseCalculatorSummary.fromQuantities(
    Map<String, int> quantities, {
    required bool deepDesertDiscount,
  }) {
    var generated = 0;
    var used = 0;
    final rawTotals = <String, int>{};

    quantities.forEach((code, qty) {
      if (qty <= 0) return;
      final item = baseCalculatorCatalogByCode[code];
      if (item == null) return;

      if (item.powerDelta >= 0) {
        generated += item.powerDelta * qty;
      } else {
        used += -item.powerDelta * qty;
      }

      item.resourceCosts.forEach((resource, cost) {
        rawTotals[resource] = (rawTotals[resource] ?? 0) + cost * qty;
      });
    });

    final adjusted = <String, int>{};
    rawTotals.forEach((resource, total) {
      adjusted[resource] = deepDesertDiscount ? (total / 2).ceil() : total;
    });

    final sortedEntries = adjusted.entries.toList()
      ..sort((a, b) {
        final byQty = b.value.compareTo(a.value);
        return byQty != 0 ? byQty : a.key.compareTo(b.key);
      });

    return BaseCalculatorSummary(
      generatedPower: generated,
      usedPower: used,
      resourceTotals: {for (final e in sortedEntries) e.key: e.value},
      deepDesertDiscountApplied: deepDesertDiscount,
    );
  }
}
