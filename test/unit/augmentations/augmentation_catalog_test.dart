import 'package:dune_awakening_companion/features/augmentations/models/augmentation_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('augmentation catalog', () {
    test('contains only Tier 6 unique augment rows from dune.gaming.tools list',
        () {
      expect(augmentationCatalog, isNotEmpty);
      expect(
        augmentationCatalog.every(
          (entry) => entry.tier == 6 && entry.rarity == 'Unique',
        ),
        isTrue,
      );
      expect(
        augmentationCatalog
            .every((entry) => entry.sourceGroup == 'Deep Desert'),
        isTrue,
      );
    });

    test('covers the known augment slots', () {
      expect(
        augmentationCatalogSlots(),
        containsAll(['Melee', 'Ranged', 'Garment', 'Generic']),
      );
    });

    test('includes representative melee, ranged, garment, and generic augments',
        () {
      final byName = {
        for (final entry in augmentationCatalog) entry.name: entry,
      };

      expect(byName['Aggressive Grip Adjuster']?.slot, 'Melee');
      expect(byName['Disruptor M11 Shield Breaker']?.slot, 'Ranged');
      expect(byName['Blade-warding Weave']?.slot, 'Garment');
      expect(byName['Protective Coating']?.slot, 'Generic');
    });

    test('does not include non-augmentation unique items', () {
      final names = augmentationCatalog.map((entry) => entry.name).toSet();

      expect(names, isNot(contains('House Heavy Caliber Upgrade')));
      expect(names, isNot(contains('A Dart for Every Man')));
      expect(names, isNot(contains('Spice-infused Plastanium Dust')));
    });
  });
}
