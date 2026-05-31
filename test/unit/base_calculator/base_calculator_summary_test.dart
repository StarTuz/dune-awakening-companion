import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_summary.dart';

void main() {
  group('BaseCalculatorSummary.fromQuantities', () {
    test('empty selection has zero power and is flagged empty', () {
      final summary =
          BaseCalculatorSummary.fromQuantities({}, deepDesertDiscount: false);
      expect(summary.isEmpty, isTrue);
      expect(summary.generatedPower, 0);
      expect(summary.usedPower, 0);
      expect(summary.netPower, 0);
      expect(summary.hasPowerDeficit, isFalse);
      expect(summary.resourceTotals, isEmpty);
    });

    test('generators add power, consumers subtract it', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'fuel_powered_generator': 2, 'windtrap': 1},
        deepDesertDiscount: false,
      );
      expect(summary.generatedPower, 150); // 2 x +75
      expect(summary.usedPower, 75); // 1 x -75
      expect(summary.netPower, 75);
      expect(summary.hasPowerDeficit, isFalse);
    });

    test('reports a deficit when consumers exceed generation', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {
          'fuel_powered_generator': 2, // +150
          'windtrap': 1, // -75
          'advanced_garment_fabricator': 1, // -150
        },
        deepDesertDiscount: false,
      );
      expect(summary.generatedPower, 150);
      expect(summary.usedPower, 225);
      expect(summary.netPower, -75);
      expect(summary.hasPowerDeficit, isTrue);
    });

    test('aggregates resource costs across quantities', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 2},
        deepDesertDiscount: false,
      );
      expect(summary.resourceTotals['Steel Ingot'], 180); // 90 x 2
      expect(summary.resourceTotals['Silicone Block'], 60); // 30 x 2
      expect(summary.resourceTotals['Calibrated Servok'], 40); // 20 x 2
    });

    test('Deep Desert discount halves materials and rounds up', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 1, 'sub_fief_console': 1},
        deepDesertDiscount: true,
      );
      // Windtrap Steel Ingot 90 -> 45 (even).
      expect(summary.resourceTotals['Steel Ingot'], 45);
      // Sub-Fief Console Salvaged Metal 25 -> ceil(12.5) = 13.
      expect(summary.resourceTotals['Salvaged Metal'], 13);
      expect(summary.deepDesertDiscountApplied, isTrue);
    });

    test('Deep Desert discount never touches power', () {
      final base = BaseCalculatorSummary.fromQuantities(
        {'fuel_powered_generator': 1, 'windtrap': 1},
        deepDesertDiscount: false,
      );
      final discounted = BaseCalculatorSummary.fromQuantities(
        {'fuel_powered_generator': 1, 'windtrap': 1},
        deepDesertDiscount: true,
      );
      expect(discounted.generatedPower, base.generatedPower);
      expect(discounted.usedPower, base.usedPower);
      expect(discounted.netPower, base.netPower);
    });

    test('ignores unknown codes and non-positive quantities', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'not_a_real_item': 5, 'windtrap': 0, 'fuel_powered_generator': -3},
        deepDesertDiscount: false,
      );
      expect(summary.isEmpty, isTrue);
      expect(summary.resourceTotals, isEmpty);
    });

    test('resource totals are sorted by descending quantity', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 1},
        deepDesertDiscount: false,
      );
      final values = summary.resourceTotals.values.toList();
      final sorted = [...values]..sort((a, b) => b.compareTo(a));
      expect(values, sorted);
    });
    test('TCNO shared config s:W:1,FPG:2,MCR:1 reconciles to -275 net power',
        () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {
          'windtrap': 1,
          'fuel_powered_generator': 2,
          'medium_spice_refinery': 1,
        },
        deepDesertDiscount: false,
      );
      expect(summary.generatedPower, 150);
      expect(summary.usedPower, 425);
      expect(summary.netPower, -275);
      expect(summary.hasPowerDeficit, isTrue);
    });
  });
}
