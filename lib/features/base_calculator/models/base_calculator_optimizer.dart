import 'base_calculator_catalog.dart';
import 'base_calculator_item.dart';
import 'base_calculator_summary.dart';

/// A suggested generator mix to cover a power shortfall.
class GeneratorRecommendation {
  final String code;
  final String name;
  final int quantity;
  final int powerPerUnit;
  final int totalPower;
  final Map<String, int> buildMaterials;

  const GeneratorRecommendation({
    required this.code,
    required this.name,
    required this.quantity,
    required this.powerPerUnit,
    required this.totalPower,
    required this.buildMaterials,
  });
}

/// Pure planning helpers for power deficits and generator sizing.
class BaseCalculatorOptimizer {
  /// Power still needed after current generation (0 when balanced/surplus).
  static int powerDeficit(BaseCalculatorSummary summary) {
    return summary.netPower < 0 ? -summary.netPower : 0;
  }

  /// Optional surplus generation when net power is positive.
  static int powerSurplus(BaseCalculatorSummary summary) {
    return summary.netPower > 0 ? summary.netPower : 0;
  }

  /// Total power required including an optional safety [buffer].
  static int targetPowerNeeded({
    required BaseCalculatorSummary summary,
    int buffer = 0,
  }) {
    return powerDeficit(summary) + buffer.clamp(0, 100000);
  }

  /// Fewest-generator mix using the largest available units first.
  static List<GeneratorRecommendation> recommendFewestGenerators(
    int powerNeeded,
  ) {
    if (powerNeeded <= 0) return const [];

    final generators = _catalogGenerators()
      ..sort((a, b) => b.powerDelta.compareTo(a.powerDelta));

    final counts = <String, int>{};
    var remaining = powerNeeded;

    while (remaining > 0) {
      BaseCalculatorItem? pick;
      for (final gen in generators) {
        if (gen.powerDelta >= remaining) {
          pick = gen;
          break;
        }
      }
      pick ??= generators.first;
      counts[pick.code] = (counts[pick.code] ?? 0) + 1;
      remaining -= pick.powerDelta;
    }

    return _toRecommendations(counts);
  }

  /// Early-game friendly mix using only fuel-powered generators.
  static List<GeneratorRecommendation> recommendFuelGenerators(
    int powerNeeded,
  ) {
    if (powerNeeded <= 0) return const [];

    final fuel = baseCalculatorCatalogByCode['fuel_powered_generator'];
    if (fuel == null) return const [];

    final qty = (powerNeeded / fuel.powerDelta).ceil();
    return [
      GeneratorRecommendation(
        code: fuel.code,
        name: fuel.name,
        quantity: qty,
        powerPerUnit: fuel.powerDelta,
        totalPower: qty * fuel.powerDelta,
        buildMaterials: _scaledCosts(fuel.resourceCosts, qty),
      ),
    ];
  }

  static List<GeneratorRecommendation> _toRecommendations(
    Map<String, int> counts,
  ) {
    final out = <GeneratorRecommendation>[];
    counts.forEach((code, qty) {
      if (qty <= 0) return;
      final item = baseCalculatorCatalogByCode[code];
      if (item == null || !item.isGenerator) return;
      out.add(
        GeneratorRecommendation(
          code: code,
          name: item.name,
          quantity: qty,
          powerPerUnit: item.powerDelta,
          totalPower: qty * item.powerDelta,
          buildMaterials: _scaledCosts(item.resourceCosts, qty),
        ),
      );
    });
    out.sort((a, b) => b.totalPower.compareTo(a.totalPower));
    return out;
  }

  static Map<String, int> _scaledCosts(Map<String, int> costs, int qty) {
    return costs.map((resource, cost) => MapEntry(resource, cost * qty));
  }

  static List<BaseCalculatorItem> _catalogGenerators() {
    return baseCalculatorCatalog
        .where((item) => item.isGenerator)
        .toList(growable: false);
  }
}
