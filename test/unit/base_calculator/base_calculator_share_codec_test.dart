import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_portable_plan.dart';
import 'package:dune_awakening_companion/features/base_calculator/services/base_calculator_share_codec.dart';

void main() {
  test('encode/decode round-trip preserves build data', () {
    const original = BaseCalculatorPortablePlan(
      name: 'Deep Desert refinery',
      deepDesertDiscountEnabled: true,
      itemQuantities: {
        'fuel_powered_generator': 2,
        'windtrap': 1,
      },
      storageQuantities: {'player_inventory': 1},
    );

    final encoded = BaseCalculatorShareCodec.encode(original);
    expect(encoded, startsWith('dac-v1'));
    expect(encoded, contains('dd'));
    expect(encoded, contains('fuel_powered_generator=2'));

    final decoded = BaseCalculatorShareCodec.decode(encoded);
    expect(decoded.name, original.name);
    expect(decoded.deepDesertDiscountEnabled, isTrue);
    expect(decoded.itemQuantities, original.itemQuantities);
    expect(decoded.storageQuantities, original.storageQuantities);
  });

  test('decode ignores unknown item codes', () {
    const code =
        'dac-v1;i:fuel_powered_generator=1,unknown_item=9;s:player_inventory=1';
    final decoded = BaseCalculatorShareCodec.decode(code);
    expect(decoded.itemQuantities, {'fuel_powered_generator': 1});
    expect(decoded.storageQuantities, {'player_inventory': 1});
  });

  test('decode rejects empty payloads', () {
    expect(
      () => BaseCalculatorShareCodec.decode('dac-v1'),
      throwsFormatException,
    );
  });

  test('decode rejects unsupported prefixes', () {
    expect(
      () => BaseCalculatorShareCodec.decode('tcno-v1;i:FPG=2'),
      throwsFormatException,
    );
  });

  test('portable JSON round-trip preserves quantities', () {
    const original = BaseCalculatorPortablePlan(
      name: 'Guild haul',
      itemQuantities: {'fuel_powered_generator': 1},
    );
    final restored =
        BaseCalculatorPortablePlan.fromJson(original.toJson());
    expect(restored.name, original.name);
    expect(restored.itemQuantities, original.itemQuantities);
    expect(restored.toJson()['format'], 'dune-base-calculator-plan');
  });
}
