import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_catalog.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_summary.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/resource_volumes.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/storage_catalog.dart';
import 'package:dune_awakening_companion/features/base_calculator/models/storage_summary.dart';

void main() {
  group('material volume', () {
    test('every resource used in the catalog has a known volume', () {
      final missing = <String>{};
      for (final item in baseCalculatorCatalog) {
        for (final resource in item.resourceCosts.keys) {
          if (resourceVolume(resource) == null) missing.add(resource);
        }
      }
      expect(missing, isEmpty,
          reason: 'resources without a volume entry: $missing');
    });

    test('summary computes total transport volume from materials', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 1},
        deepDesertDiscount: false,
      );
      // Steel Ingot 90 x1V + Silicone Block 30 x52V + Calibrated Servok 20 x0.6V
      // = 90 + 1560 + 12 = 1662.
      expect(summary.totalVolume, closeTo(1662, 0.0001));
    });

    test('Deep Desert discount also halves transport volume', () {
      final summary = BaseCalculatorSummary.fromQuantities(
        {'windtrap': 1},
        deepDesertDiscount: true,
      );
      expect(summary.totalVolume, closeTo(831, 0.0001));
    });
  });

  group('StorageSummary', () {
    test('empty selection has no capacity', () {
      final s = StorageSummary.fromQuantities({});
      expect(s.isEmpty, isTrue);
      expect(s.totalVolumeCapacity, 0);
      expect(s.totalSlots, 0);
    });

    test('aggregates volume and slots across quantities', () {
      final s = StorageSummary.fromQuantities(
        {'player_inventory': 2, 'buggy_storage_mk3': 1},
      );
      expect(s.totalVolumeCapacity, 175 * 2 + 1500); // 1850
      expect(s.totalSlots, 35 * 2 + 20); // 90
    });

    test('ignores unknown codes and non-positive quantities', () {
      final s = StorageSummary.fromQuantities(
        {'nope': 5, 'player_inventory': 0},
      );
      expect(s.isEmpty, isTrue);
    });
  });

  group('tripsNeeded', () {
    test('returns null when no storage is configured', () {
      expect(tripsNeeded(materialVolume: 1662, storageCapacity: 0), isNull);
    });

    test('returns 0 when there is nothing to haul', () {
      expect(tripsNeeded(materialVolume: 0, storageCapacity: 175), 0);
    });

    test('rounds up partial trips', () {
      // 1662 / 175 = 9.49 -> 10.
      expect(tripsNeeded(materialVolume: 1662, storageCapacity: 175), 10);
      // Exact multiple stays exact.
      expect(tripsNeeded(materialVolume: 350, storageCapacity: 175), 2);
    });
  });

  group('storage catalog structure', () {
    test('options are non-empty with positive capacities', () {
      expect(baseCalculatorStorageOptions, isNotEmpty);
      for (final o in baseCalculatorStorageOptions) {
        expect(o.code.trim(), isNotEmpty);
        expect(o.name.trim(), isNotEmpty);
        expect(o.volumeCapacity, greaterThan(0));
        expect(o.slotCapacity, greaterThan(0));
      }
    });

    test('storage codes are unique and indexed', () {
      final seen = <String>{};
      for (final o in baseCalculatorStorageOptions) {
        expect(seen.add(o.code), isTrue, reason: 'duplicate ${o.code}');
      }
      expect(baseCalculatorStorageOptionsByCode.length,
          baseCalculatorStorageOptions.length);
    });
  });
}
