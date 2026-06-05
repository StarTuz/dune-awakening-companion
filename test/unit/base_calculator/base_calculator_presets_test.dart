import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_catalog.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_presets.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/storage_catalog.dart';

void main() {
  test('every preset item code exists in the catalog or storage list', () {
    for (final preset in baseCalculatorPresets) {
      for (final code in preset.itemQuantities.keys) {
        expect(
          baseCalculatorCatalogByCode.containsKey(code),
          isTrue,
          reason: 'Unknown item code $code in preset ${preset.id}',
        );
      }
      for (final code in preset.storageQuantities.keys) {
        expect(
          baseCalculatorStorageOptionsByCode.containsKey(code),
          isTrue,
          reason: 'Unknown storage code $code in preset ${preset.id}',
        );
      }
    }
  });

  test('deep desert refinery preset matches audited TCNO sample', () {
    final preset = baseCalculatorPresetsById['deep_desert_refinery']!;
    expect(preset.deepDesertDiscount, isTrue);
    expect(preset.itemQuantities['fuel_powered_generator'], 2);
    expect(preset.itemQuantities['windtrap'], 1);
    expect(preset.itemQuantities['medium_spice_refinery'], 1);
  });
}
