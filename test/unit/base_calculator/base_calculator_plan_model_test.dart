import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_plan.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_state.dart';

void main() {
  test('fromState and toCalculatorState round-trip selections', () {
    const state = BaseCalculatorState(
      quantities: {'fuel_powered_generator': 2},
      storageQuantities: {'player_inventory': 1},
      deepDesertDiscount: true,
    );

    final plan = BaseCalculatorPlan.fromState(
      id: 'plan-1',
      name: 'Test plan',
      state: state,
      createdAt: DateTime.utc(2026, 6, 5),
      updatedAt: DateTime.utc(2026, 6, 5),
    );

    final restored = plan.toCalculatorState();

    expect(restored.quantities, state.quantities);
    expect(restored.storageQuantities, state.storageQuantities);
    expect(restored.deepDesertDiscount, isTrue);
    expect(restored.activePlanId, 'plan-1');
    expect(restored.activePlanName, 'Test plan');
  });

  test('toJson/fromJson preserves encoded quantities', () {
    final plan = BaseCalculatorPlan(
      id: 'plan-2',
      name: 'Export plan',
      itemQuantities: const {'windtrap': 1},
      storageQuantities: const {'sandbike_inventory': 2},
      createdAt: DateTime.utc(2026, 6, 5),
      updatedAt: DateTime.utc(2026, 6, 5),
    );

    final restored = BaseCalculatorPlan.fromJson(plan.toJson());

    expect(restored.id, plan.id);
    expect(restored.itemQuantities, plan.itemQuantities);
    expect(restored.storageQuantities, plan.storageQuantities);
  });

  test('encodeQuantities drops non-positive entries', () {
    final encoded = BaseCalculatorPlan.encodeQuantities({
      'fuel_powered_generator': 2,
      'windtrap': 0,
    });
    final decoded = BaseCalculatorPlan.decodeQuantities(encoded);

    expect(decoded, {'fuel_powered_generator': 2});
  });
}
