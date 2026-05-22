import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/blueprints/models/blueprint_catalog.dart';

void main() {
  group('blueprint catalog structure', () {
    test('every entry has a non-empty name and at least one source', () {
      for (final entry in blueprintCatalog) {
        expect(entry.name.trim(), isNotEmpty,
            reason: 'empty name on entry');
        expect(entry.sources, isNotEmpty,
            reason: '${entry.name} has no sources');
      }
    });

    test('every source has non-empty region and location', () {
      for (final entry in blueprintCatalog) {
        for (final source in entry.sources) {
          expect(source.region.trim(), isNotEmpty,
              reason: '${entry.name} has a source with empty region');
          expect(source.location.trim(), isNotEmpty,
              reason: '${entry.name} has a source with empty location');
        }
      }
    });

    test('schematic names are unique across the whole catalog', () {
      final seen = <String>{};
      final dupes = <String>{};
      for (final entry in blueprintCatalog) {
        final key = entry.name.toLowerCase();
        if (!seen.add(key)) dupes.add(entry.name);
      }
      expect(dupes, isEmpty,
          reason: 'duplicate schematic names — these should be collapsed into '
              'a single entry with multiple sources: $dupes');
    });

    test('a single entry never lists the same (region, location) twice', () {
      for (final entry in blueprintCatalog) {
        final seen = <String>{};
        final dupes = <String>{};
        for (final s in entry.sources) {
          final key = '${s.region}::${s.location}';
          if (!seen.add(key)) dupes.add(s.label);
        }
        expect(dupes, isEmpty,
            reason: '${entry.name} has duplicate source(s): $dupes');
      }
    });

    test('category is one of the documented values', () {
      const knownCategories = {
        'Weapon',
        'Armor',
        'Tool',
        'Vehicle',
        'Utility',
        'Building',
        'Schematic',
        'Other',
      };
      for (final entry in blueprintCatalog) {
        expect(knownCategories, contains(entry.category),
            reason: '${entry.name} has unknown category "${entry.category}"');
      }
    });

    test('blueprintCatalogRegions returns every region used by sources', () {
      final regionsFromSources = <String>{
        for (final entry in blueprintCatalog)
          for (final source in entry.sources) source.region,
      };
      expect(blueprintCatalogRegions().toSet(), regionsFromSources);
    });
  });
}
