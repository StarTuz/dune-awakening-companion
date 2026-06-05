import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_optimizer.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_summary.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/generator_running_cost.dart';

void main() {
  group('BaseCalculatorOptimizer', () {
    test('reports deficit from summary', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 1},
        deepDesertDiscount: false,
      );
      expect(BaseCalculatorOptimizer.powerDeficit(summary), 75);
      expect(
        BaseCalculatorOptimizer.targetPowerNeeded(summary: summary, buffer: 25),
        100,
      );
    });

    test('fewest-generator mix covers TCNO deficit with spice generator', () {
      final recs = BaseCalculatorOptimizer.recommendFewestGenerators(275);
      expect(recs, hasLength(1));
      expect(recs.single.code, 'spice_powered_generator');
      expect(recs.single.totalPower, greaterThanOrEqualTo(275));
    });

    test('fuel-only recommendation uses ceil division', () {
      final recs = BaseCalculatorOptimizer.recommendFuelGenerators(100);
      expect(recs, hasLength(1));
      expect(recs.single.code, 'fuel_powered_generator');
      expect(recs.single.quantity, 2);
      expect(recs.single.totalPower, 150);
    });
  });

  group('GeneratorRunningCost', () {
    test('estimates fuel cells per running generator over time', () {
      final cost = GeneratorRunningCost.estimateConsumption(
        quantities: {'fuel_powered_generator': 3},
        hours: 24,
      );
      expect(cost['Fuel Cells'], 72);
    });

    test('returns empty when no fuel generators are placed', () {
      final cost = GeneratorRunningCost.estimateConsumption(
        quantities: {'windtrap': 1},
        hours: 168,
      );
      expect(cost, isEmpty);
    });
  });
}
