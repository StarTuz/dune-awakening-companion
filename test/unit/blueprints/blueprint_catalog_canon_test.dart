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
///  - Jabal Eifrit (Al-gharb, Al-Janub, Al-sharq):
///    https://www.ign.com/wikis/dune-awakening/All_Jabal_Eifrit_Unique_Schematics_and_Locations
///  - Shield Wall (Eastern + Western):
///    https://www.ign.com/wikis/dune-awakening/All_Shield_Wall_Unique_Schematics_and_Locations
///  - The O'odham:
///    https://www.ign.com/wikis/dune-awakening/All_The_O%27odham_Unique_Schematics_and_Locations
///  - Mysa Tarill:
///    https://www.ign.com/wikis/dune-awakening/All_Mysa_Tarill_Unique_Schematics_and_Locations
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
  // IGN's Jabal Eifrit page uses the abbreviated names "Way of the Lost",
  // "Zaal's Companion", and (at Wreck of the Tisiphone) "Ripper". The
  // catalog uses the fuller in-game names ("Way of the Lost Maula Pistol",
  // "Zaal's Companion Assault Rifle", "Ripper Scattergun") that match the
  // Hagga Rift / Wreck of Kytheria entries — treating them as the same
  // schematics with additional drop sites. "lnkvine" (lowercase L) on
  // IGN's page is a typo for "Inkvine"; "Skin-lined" is normalised to
  // "Skin-Lined" to match the Hagga Rift entry.
  'Jabal Eifrit Al-gharb': {
    "Piter's Net": [
      "Karak's Boots",
      "Karak's Gauntlets",
      "Karak's Helmet",
      "Karak's Jacket",
      "Karak's Pants",
      'Ripper Searing Shiv',
      'Spice-infused Steel Dust',
      'Way of the Lost Maula Pistol',
      "Zaal's Companion Assault Rifle",
    ],
    'Eastern Jumble': [
      "Callie's Breaker",
      "Glutton's Drinker",
      'Old Sparky Mk3',
      "Seb's Kisser",
      'Shock-sword',
      'Spice-infused Copper Dust',
      'Spice-infused Steel Dust',
    ],
  },
  'Jabal Eifrit Al-Janub': {
    'Imperial Testing Station No. 76': [
      'Shock-sword',
      "Glutton's Drinker",
      "Callie's Breaker",
      'Old Sparky Mk3',
      'Reaper Gloves',
      "Seb's Kisser",
    ],
    "Khidr's Shadow": [
      'Handheld Life Scanner Mk3',
      'Inkvine Boots',
      'Inkvine Gauntlets',
      'Inkvine Jacket',
      'Inkvine Mask',
      'Inkvine Pants',
      'The Tapper',
    ],
    'Runaway Station Camp': [
      'Buoyant Reaper Mk3',
      "Glutton's Bloodbag",
      'Hajra Literjon Mk3',
      'Rigged Suspensor Jacket',
      'Shock Gauntlets',
      'Skin-Lined Jacket',
      "Ta'lab Softstep Boots",
      "The Emperor's Wings Mk3",
    ],
    'Hand of Khidr': [
      'Buoyant Reaper Mk3',
      'Filter Extractor Mk3',
      "Glutton's Bloodbag",
      'Hajra Literjon Mk3',
      'Shock Gauntlets',
      'Skin-Lined Jacket',
      "Ta'lab Softstep Boots",
      "The Emperor's Wings Mk3",
    ],
  },
  'Jabal Eifrit Al-sharq': {
    'Wreck of the Tisiphone': [
      "Karak's Boots",
      "Karak's Gauntlets",
      "Karak's Helmet",
      "Karak's Jacket",
      "Karak's Pants",
      'Ripper Scattergun',
      'Way of the Lost Maula Pistol',
      "Zaal's Companion Assault Rifle",
    ],
    "Kel's Fallback": [
      "Callie's Breaker",
      "Glutton's Drinker",
      'Old Sparky Mk3',
      "Seb's Kisser",
      'Shock-sword',
    ],
    'Unnamed observation point east of Farhold': [
      'Buoyant Reaper Mk3',
      "Glutton's Bloodbag",
      'Hajra Literjon Mk3',
      'Shock Gauntlets',
      'Skin-Lined Jacket',
      "Ta'lab Softstep Boots",
      "The Emperor's Wings Mk3",
    ],
  },
  // Shield Wall splits into Eastern + Western. Several schematics roll
  // from three- and two-site pools that span both sub-regions; Spice-
  // infused Aluminum Dust touches six sites in total. Spice-infused
  // Copper Dust at ITS 142 / ITS 60 is already in the Jabal Eifrit
  // catalog row that owns it.
  'Eastern Shield Wall': {
    'Southern Comms': [
      'Bigger Buggy Boot Mk4',
      'Filter Extractor Mk4',
      'Focused Buggy Cutteray Mk4',
      'Long Shot',
      'Sentinel Boots',
      'Sentinel Gauntlets',
      'Sentinel Helmet',
      'Sentinel Jacket',
      'Sentinel Pants',
      'Spark-Knife',
      'Spice-infused Aluminum Dust',
      "The Emperor's Wings Mk4",
    ],
    'Fangs of Maraqeb': [
      'Collapsible Dew Reaper Mk4',
      'Idaho Softstep Boots',
      'Power Gauntlets',
      "Shadrath's Stillsuit Boots",
      "Shadrath's Stillsuit Garment",
      "Shadrath's Stillsuit Gloves",
      "Shadrath's Stillsuit Mask",
      'Stammershot',
      'Stormrider Boost Module Mk4',
    ],
    'Sentinel City': [
      "Denira's Gift",
      'House Burst Drillshot',
      'House Disruptor Pistol',
      'Poison Mist',
      "Quirth's Boots",
      "Quirth's Gauntlets",
      "Quirth's Helmet",
      "Quirth's Jacket",
      "Quirth's Pants",
      "Sinner's Bloodbag",
      'Spice-infused Aluminum Dust',
      'Way of the Fighter',
    ],
    'Imperial Testing Station No. 142': [
      "Abulurd's Rapture",
      'Buoyant Reaper Mk4',
      'Improved Reaper Gloves',
      'Maraqeb Stillsuit Boots',
      'Maraqeb Stillsuit Garment',
      'Maraqeb Stillsuit Gloves',
      'Maraqeb Stillsuit Mask',
      'Mohandis Sandbike Engine Mk4',
      'Old Sparky Mk4',
      'Rattler Boost Module Mk4',
      'Spark-sword',
      'Spice-infused Copper Dust',
    ],
  },
  'Western Shield Wall': {
    'Passage of Artemis': [
      'Bigger Buggy Boot Mk4',
      'Filter Extractor Mk4',
      'Focused Buggy Cutteray Mk4',
      'Long Shot',
      'Sentinel Boots',
      'Sentinel Gauntlets',
      'Sentinel Helmet',
      'Sentinel Jacket',
      'Sentinel Pants',
      'Spark-Knife',
      'Spice-infused Aluminum Dust',
      "The Emperor's Wings Mk4",
    ],
    "Sirr'asraar Vault": [
      'Bigger Buggy Boot Mk4',
      'Filter Extractor Mk4',
      'Focused Buggy Cutteray Mk4',
      'Long Shot',
      'Sentinel Boots',
      'Sentinel Gauntlets',
      'Sentinel Helmet',
      'Sentinel Jacket',
      'Sentinel Pants',
      'Spark-Knife',
      'Spice-infused Aluminum Dust',
      "The Emperor's Wings Mk4",
    ],
    'Wreck of the Alecto': [
      "Denira's Gift",
      'House Disruptor Pistol',
      "Quirth's Boots",
      "Quirth's Gauntlets",
      "Quirth's Helmet",
      "Quirth's Jacket",
      "Quirth's Pants",
      "Sinner's Bloodbag",
      'Spice-infused Aluminum Dust',
      'Way of the Fighter',
    ],
    'Imperial Testing Station No. 60': [
      'Albatross Wing Module Mk4',
      'Bluddshot Buggy Engine Mk4',
      'Compact Compactor Mk4',
      'Eviscerator',
      'Experimental Vulcan GAU-94',
      'Hajra Literjon Mk4',
      'Improved Suspensor Jacket',
      "Miner's Blessing",
      'Night Rider Sandbike Boost Mk4',
      'Pipecleaner',
      "Shadrath's Drinker",
      'Spice-infused Aluminum Dust',
      'Spice-infused Copper Dust',
      'Tarl Cutteray',
    ],
  },
  // The O'odham is mostly Mk4 overlap with Shield Wall. Three sites
  // (Stonestep Village / ITS 71 / Rockwarren Village) share a 10-entry
  // pool with ITS 60. ITS 163 shares a pool with ITS 142. Batigh Grotto
  // overlaps with Sentinel City + Wreck of the Alecto (plus Poison Mist
  // which is otherwise Sentinel City-only).
  //
  // Tarl Cutteray is listed at the tri-pool here per IGN; the user has
  // separately reported it as moved to Sheol in-game. Canon test keeps
  // the IGN listing for now — see "Pending corrections" in
  // docs/RESEARCH_BLUEPRINTS.md.
  "The O'odham": {
    'Stonestep Village': [
      'Bluddshot Buggy Engine Mk4',
      'Compact Compactor Mk4',
      'Eviscerator',
      'Hajra Literjon Mk4',
      'Improved Suspensor Jacket',
      "Miner's Blessing",
      'Night Rider Sandbike Boost Mk4',
      'Pipecleaner',
      "Shadrath's Drinker",
      'Tarl Cutteray',
    ],
    'Imperial Testing Station No. 71': [
      'Bluddshot Buggy Engine Mk4',
      'Compact Compactor Mk4',
      'Compression-Stim Leggings',
      'Eviscerator',
      'Hajra Literjon Mk4',
      'Improved Suspensor Jacket',
      "Miner's Blessing",
      'Night Rider Sandbike Boost Mk4',
      'Pipecleaner',
      "Shadrath's Drinker",
      'Tarl Cutteray',
    ],
    'Rockwarren Village': [
      'Bluddshot Buggy Engine Mk4',
      'Compact Compactor Mk4',
      'Eviscerator',
      'Hajra Literjon Mk4',
      'Improved Suspensor Jacket',
      "Miner's Blessing",
      'Night Rider Sandbike Boost Mk4',
      'Pipecleaner',
      "Shadrath's Drinker",
      'Tarl Cutteray',
    ],
    'Imperial Testing Station No. 163': [
      'Buoyant Reaper Mk4',
      'Firestorm',
      'Improved Reaper Gloves',
      'Ironwatch Special',
      'Maraqeb Stillsuit Boots',
      'Maraqeb Stillsuit Garment',
      'Maraqeb Stillsuit Gloves',
      'Maraqeb Stillsuit Mask',
      'Mohandis Sandbike Engine Mk4',
      'Rattler Boost Module Mk4',
      'Spark-sword',
    ],
    'Batigh Grotto': [
      "Denira's Gift",
      'House Disruptor Pistol',
      'Poison Mist',
      "Quirth's Boots",
      "Quirth's Gauntlets",
      "Quirth's Helmet",
      "Quirth's Jacket",
      "Quirth's Pants",
      "Sinner's Bloodbag",
      'Way of the Fighter',
    ],
  },
  // Mysa Tarill is mostly Shield Wall overlap. The palace site
  // (also called "Mysa Tarill" — region and site share a name) shares
  // its 9-entry pool with Fangs of Maraqeb (E Shield Wall) except for
  // Power Gauntlets. The Beast's Claw shares its 10-entry pool with
  // the Shield Wall Southern Comms / Passage of Artemis / Sirr'asraar
  // Vault tri-source pool except for Sentinel Pants and Spice-infused
  // Aluminum Dust.
  //
  // IGN's Mysa Tarill guide lists "Sentinel Jacket" twice for the
  // Beast's Claw row and omits Sentinel Pants — likely a typo. See
  // "Pending corrections" in docs/RESEARCH_BLUEPRINTS.md.
  'Mysa Tarill': {
    'Mysa Tarill': [
      'Clapper Mk4',
      'Collapsible Dew Reaper Mk4',
      'Idaho Softstep Boots',
      "Shadrath's Stillsuit Boots",
      "Shadrath's Stillsuit Garment",
      "Shadrath's Stillsuit Gloves",
      "Shadrath's Stillsuit Mask",
      'Stammershot',
      'Stormrider Boost Module Mk4',
    ],
    "The Beast's Claw": [
      'Bigger Buggy Boot Mk4',
      'Filter Extractor Mk4',
      'Focused Buggy Cutteray Mk4',
      'Long Shot',
      'Sentinel Boots',
      'Sentinel Gauntlets',
      'Sentinel Helmet',
      'Sentinel Jacket',
      'Spark-Knife',
      "The Emperor's Wings Mk4",
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
