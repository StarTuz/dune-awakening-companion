import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/blueprints/models/blueprint_catalog.dart';

/// Canon: (region, site) -> exact set of schematic names that drop there,
/// sourced from IGN's unique schematics guides:
///
///  - Hagga Basin South:
///    https://www.ign.com/wikis/dune-awakening/All_Hagga_Basin_South_Unique_Schematics_and_Locations
///  - Vermillius Gap (West + East):
///    https://www.ign.com/wikis/dune-awakening/All_Vermillius_Gap_Unique_Schematics_and_Locations
///  - Hagga Rift:
///    https://www.ign.com/wikis/dune-awakening/All_Hagga_Rift_Unique_Schematics_and_Locations
///
/// When IGN updates the guides — or when a new region is added — update this
/// table along with the catalog. The tests will surface drift in either
/// direction (missing entries OR hallucinated ones).
const Map<String, Map<String, List<String>>> _canon = {
  'Hagga Basin South': {
    'Wreck of the Alcyon': ["Kaleff's Drinker"],
    'Key Hole Rock': [
      'Old Sparky Mk1',
      'Mohandis Sandbike Engine Mk1',
      "Sim's Cutter",
    ],
    'Hagga Basin South': [
      "Aren's Mask",
      "Aren's Chestpiece",
      "Aren's Boots",
      "Aren's Gloves",
      "Aren's Pants",
      'Hajra Literjon Mk1',
    ],
    'Broken Stone Station': ["Aren's Vengeance"],
    'Imperial Testing Station No. 2': ["The Emperor's Wings Mk1"],
    'Old Griffin Hideaway': ['Way of the Fallen'],
    'Dewgap Gateway': [
      'Hollower Stillsuit Mask',
      'Hollower Stillsuit Garment',
      'Hollower Stillsuit Gloves',
      'Hollower Stillsuit Boots',
    ],
  },
  'Vermillius Gap West': {
    'Northwest Iron Works': [
      "Iri's Gauntlets",
      'Old Sparky Mk2',
      "Scipio's Drinker",
    ],
    "Miner's Watch": [
      "Mendia's Boots",
      "Mendia's Gauntlets",
      "Mendia's Jacket",
      "Mendia's Pants",
      "Mendia's Wrap",
      'Pseudo-Pulse-Sword',
    ],
    'Table of the Gods': [
      'Buoyant Reaper Mk2',
      'Hajra Literjon Mk2',
      "Scipio's Bloodbag",
      "The Emperor's Wings Mk2",
    ],
    'Coils of the Wyrm': [
      'Oathbreaker Boots',
      'Oathbreaker Chestpiece',
      'Oathbreaker Gauntlets',
      'Oathbreaker Headwrap',
      'Oathbreaker Pants',
    ],
    'Imperial Station No. 197': [
      "Olef's Quickcutter",
      'Softstep Boots',
    ],
    'Wreck of the Pallas': [
      "Fila's Regret",
      'Legion Tattoo',
      'Mohandis Sandbike Engine Mk2',
      'Way of the Wanderer',
    ],
    'The Anomaly': [
      'Compact Compactor Mk3',
      "Kel's Stillsuit Boots",
      "Kel's Stillsuit Garment",
      "Kel's Stillsuit Gloves",
      "Kel's Stillsuit Mask",
    ],
  },
  'Vermillius Gap East': {
    "Mirzabah's Head": [
      'Buoyant Reaper Mk3',
      'Hajra Literjon Mk2',
      'Old Sparky Mk2',
      "Scipio's Bloodbag",
      "The Emperor's Wings Mk2",
    ],
    'Suk Alusus': [
      'Oathbreaker Boots',
      'Oathbreaker Chestpiece',
      'Oathbreaker Gauntlets',
      'Oathbreaker Headwrap',
      'Oathbreaker Pants',
    ],
    'Ghanima Cavern': [
      "Menol's Stillsuit Boots",
      "Menol's Stillsuit Garment",
      "Menol's Stillsuit Gloves",
      "Menol's Stillsuit Mask",
      'Night Rider Sandbike Boost Mk2',
    ],
    'Imperial Testing Station No. 10': [
      'Pseudo-Pulse-Sword',
      'Bigger Buggy Boot Mk3',
      'Bluddshot Buggy Engine Mk3',
      "Mendia's Boots",
      "Mendia's Gauntlets",
      "Mendia's Jacket",
      "Mendia's Pants",
      "Mendia's Wrap",
      'Mohandis Sandbike Engine Mk3',
      'Night Rider Sandbike Boost Mk3',
    ],
  },
  // IGN renders some Hagga Rift locations as "Imperial Testing Station #29"
  // and "Choam Mineral Extraction Facility #6"; we normalise both to "No. N"
  // to match the rest of the catalog.
  'Hagga Rift': {
    'The Spiral': [
      'Inkvine Mask',
      'Inkvine Jacket',
      'Inkvine Gauntlets',
      'Inkvine Pants',
      'Inkvine Boots',
      'Handheld Life Scanner Mk3',
      "Assassin's Rifle",
    ],
    'Arctus Cavern': [
      'Inkvine Mask',
      'Inkvine Jacket',
      'Inkvine Gauntlets',
      'Inkvine Pants',
      'Inkvine Boots',
      'Handheld Life Scanner Mk3',
      "Assassin's Rifle",
    ],
    'Deserter Camp in Imperial Testing Station No. 29': [
      "Callie's Breaker",
      "Glutton's Bloodbag",
      'Old Sparky Mk3',
      "Seb's Kisser",
      'Shock-sword',
      'Focused Buggy Cutteray Mk3',
    ],
    'Choam Mineral Extraction Facility No. 6': [
      "Callie's Breaker",
      "Glutton's Bloodbag",
      'Old Sparky Mk3',
      "Seb's Kisser",
      'Shock-sword',
      'Focused Buggy Cutteray Mk3',
    ],
    'Stepstone Cavern': [
      "Glutton's Bloodbag",
      'Buoyant Reaper Mk3',
      'Hajra Literjon Mk3',
      'Shock Gauntlets',
      'Skin-Lined Jacket',
      "Ta'lab Softstep Boots",
      "The Emperor's Wings Mk3",
    ],
    'Wreck of Kytheria': [
      "Karak's Helmet",
      "Karak's Jacket",
      "Karak's Gauntlets",
      "Karak's Pants",
      "Karak's Boots",
      'Way of the Lost Maula Pistol',
      "Zaal's Companion Assault Rifle",
      'Ripper Scattergun',
    ],
  },
};

/// Catalog as `region -> site -> set of schematic names`.
Map<String, Map<String, Set<String>>> _catalogIndex() {
  final out = <String, Map<String, Set<String>>>{};
  for (final entry in blueprintCatalog) {
    for (final source in entry.sources) {
      final byRegion = out.putIfAbsent(source.region, () => {});
      final names = byRegion.putIfAbsent(source.location, () => {});
      names.add(entry.name);
    }
  }
  return out;
}

void main() {
  group('blueprint catalog matches IGN canon', () {
    final index = _catalogIndex();

    test('canon covers exactly the regions the catalog declares', () {
      final canonRegions = _canon.keys.toSet();
      final catalogRegions = index.keys.toSet();
      final missingFromCatalog = canonRegions.difference(catalogRegions);
      final extraInCatalog = catalogRegions.difference(canonRegions);
      expect(missingFromCatalog, isEmpty,
          reason: 'canon names regions the catalog does not cover: '
              '$missingFromCatalog');
      expect(extraInCatalog, isEmpty,
          reason: 'catalog has regions not in canon: $extraInCatalog');
    });

    _canon.forEach((region, sitesCanon) {
      group(region, () {
        test('catalog covers the expected sites in $region', () {
          final sitesInCatalog = index[region]?.keys.toSet() ?? const {};
          final missing =
              sitesCanon.keys.toSet().difference(sitesInCatalog);
          final extra =
              sitesInCatalog.difference(sitesCanon.keys.toSet());
          expect(missing, isEmpty,
              reason: '$region: catalog is missing sites: $missing');
          expect(extra, isEmpty,
              reason: '$region: catalog has non-canon sites: $extra');
        });

        sitesCanon.forEach((site, expectedNames) {
          test('$site has the canonical schematic set', () {
            final actual = index[region]?[site] ?? const <String>{};
            final missing = expectedNames.toSet().difference(actual);
            final extra = actual.difference(expectedNames.toSet());
            expect(missing, isEmpty,
                reason: '$region / $site is missing: $missing');
            expect(extra, isEmpty,
                reason: '$region / $site has non-canon entries: $extra');
          });
        });
      });
    });

    test('total source count matches canon total', () {
      final expected = _canon.values
          .expand((sites) => sites.values)
          .fold<int>(0, (sum, names) => sum + names.length);
      final actual = blueprintCatalog
          .fold<int>(0, (sum, entry) => sum + entry.sources.length);
      expect(actual, expected,
          reason: 'catalog has $actual source rows, canon has $expected');
    });
  });
}
