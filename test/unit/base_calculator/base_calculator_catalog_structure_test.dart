import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/base_calculator/models/base_calculator_catalog.dart';

void main() {
  group('base calculator catalog structure', () {
    test('catalog is non-empty', () {
      expect(baseCalculatorCatalog, isNotEmpty);
    });

    test('every item has a non-empty code and name', () {
      for (final item in baseCalculatorCatalog) {
        expect(item.code.trim(), isNotEmpty, reason: 'empty code');
        expect(item.name.trim(), isNotEmpty,
            reason: 'empty name on ${item.code}');
      }
    });

    test('item codes are unique', () {
      final seen = <String>{};
      final dupes = <String>{};
      for (final item in baseCalculatorCatalog) {
        if (!seen.add(item.code)) dupes.add(item.code);
      }
      expect(dupes, isEmpty, reason: 'duplicate codes: $dupes');
    });

    test('every item has at least one resource cost, all positive', () {
      for (final item in baseCalculatorCatalog) {
        expect(item.resourceCosts, isNotEmpty,
            reason: '${item.code} has no resource costs');
        for (final entry in item.resourceCosts.entries) {
          expect(entry.key.trim(), isNotEmpty,
              reason: '${item.code} has an empty resource name');
          expect(entry.value, greaterThan(0),
              reason: '${item.code} -> ${entry.key} is not positive');
        }
      }
    });

    test('power delta is non-zero (item either generates or consumes)', () {
      for (final item in baseCalculatorCatalog) {
        expect(item.powerDelta, isNot(0),
            reason: '${item.code} has a zero power delta');
      }
    });

    test('index covers every catalog item exactly once', () {
      expect(baseCalculatorCatalogByCode.length, baseCalculatorCatalog.length);
      for (final item in baseCalculatorCatalog) {
        expect(baseCalculatorCatalogByCode[item.code], same(item));
      }
    });
  });
}
