import '../blueprint_catalog.dart';

const _east = 'Eastern Shield Wall';
const _west = 'Western Shield Wall';

const _southernComms = 'Southern Comms';
const _fangs = 'Fangs of Maraqeb';
const _sentinelCity = 'Sentinel City';
const _its142 = 'Imperial Testing Station No. 142';
const _passageArtemis = 'Passage of Artemis';
const _sirrasraar = "Sirr'asraar Vault";
const _alecto = 'Wreck of the Alecto';
const _its60 = 'Imperial Testing Station No. 60';

/// Seed list from IGN's Shield Wall unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Shield_Wall_Unique_Schematics_and_Locations
///
/// Shield Wall splits into Eastern and Western sub-regions, both surfaced
/// as their own region in the catalog so the region filter chip stays
/// close to in-game terminology.
///
/// Three major drop pools span both sub-regions:
///   - Southern Comms (E) / Passage of Artemis (W) / Sirr'asraar Vault (W)
///   - Sentinel City (E) / Wreck of the Alecto (W)
///   - Imperial Testing Station No. 142 (E) / Imperial Testing Station No. 60 (W)
///     (only for the two Spice-infused Dust schematics)
///
/// Spice-infused Copper Dust **also** drops in Jabal Eifrit Al-gharb —
/// that catalog row lives in `jabal_eifrit.dart` and gains the two
/// Shield Wall sources there.
const shieldWallBlueprintCatalog = [
  // ─── Tri-source pool: Southern Comms (E) + Passage of Artemis (W) +
  //     Sirr'asraar Vault (W) ─────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Bigger Buggy Boot Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Filter Extractor Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Long Shot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Helmet',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Spark-Knife',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk4",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
    ],
  ),

  // ─── Fangs of Maraqeb (East) only ───────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Collapsible Dew Reaper Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Idaho Softstep Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Power Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Gloves",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Mask",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stammershot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stormrider Boost Module Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
    ],
  ),

  // ─── Sentinel City (East) + Wreck of the Alecto (West) dual pool ────
  BlueprintCatalogEntry(
    name: "Denira's Gift",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'House Disruptor Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Jacket",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Sinner's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Fighter',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
    ],
  ),

  // ─── Sentinel City (East) only ──────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'House Burst Drillshot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Poison Mist',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
    ],
  ),

  // ─── Spice-infused Aluminum Dust — six sources spanning both pools
  //     and ITS 60 ─────────────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Spice-infused Aluminum Dust',
    category: 'Other',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _west, location: _its60),
    ],
  ),

  // ─── Imperial Testing Station No. 142 (East) only ────────────────────
  // (Spice-infused Copper Dust also drops here — see jabal_eifrit.dart.)
  BlueprintCatalogEntry(
    name: "Abulurd's Rapture",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Buoyant Reaper Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Improved Reaper Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Old Sparky Mk4',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Rattler Boost Module Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Spark-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _its142),
    ],
  ),

  // ─── Imperial Testing Station No. 60 (West) only ─────────────────────
  // (Spice-infused Aluminum Dust + Spice-infused Copper Dust also drop
  // here — see the Aluminum entry above and jabal_eifrit.dart.)
  BlueprintCatalogEntry(
    name: 'Albatross Wing Module Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Bluddshot Buggy Engine Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Compact Compactor Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Eviscerator',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Experimental Vulcan GAU-94',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk4',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Improved Suspensor Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Miner's Blessing",
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Pipecleaner',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Drinker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Tarl Cutteray',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
    ],
  ),
];
