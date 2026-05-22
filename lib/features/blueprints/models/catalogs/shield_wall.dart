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

// The O'odham — many Shield Wall Mk4 schematics also drop in O'odham.
// Cross-region sources are appended to entries here rather than in a
// separate file, mirroring how Buoyant Reaper Mk3 lives in vermillius_gap.dart.
const _oodham = "The O'odham";
const _stonestep = 'Stonestep Village';
const _its71 = 'Imperial Testing Station No. 71';
const _rockwarren = 'Rockwarren Village';
const _its163 = 'Imperial Testing Station No. 163';
const _batighGrotto = 'Batigh Grotto';

// Mysa Tarill — the Fangs of Maraqeb pool (except Power Gauntlets) and
// most of the tri-source Sentinel/Mk4 pool (except Spice-infused
// Aluminum Dust) also drop here.
const _mysa = 'Mysa Tarill';
const _mysaPalace = 'Mysa Tarill';
const _beastsClaw = "The Beast's Claw";

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
///
/// Many Mk4 schematics also drop in The O'odham (Stonestep / ITS 71 /
/// Rockwarren tri-pool, ITS 163, or Batigh Grotto). Those O'odham
/// sources are appended to the relevant entries here.
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
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Filter Extractor Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Long Shot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Helmet',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Sentinel Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Spark-Knife',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk4",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _southernComms),
      BlueprintSource(region: _west, location: _passageArtemis),
      BlueprintSource(region: _west, location: _sirrasraar),
      BlueprintSource(region: _mysa, location: _beastsClaw),
    ],
  ),

  // ─── Fangs of Maraqeb (East) only ───────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Collapsible Dew Reaper Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Idaho Softstep Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
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
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Gloves",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Stillsuit Mask",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stammershot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stormrider Boost Module Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _fangs),
      BlueprintSource(region: _mysa, location: _mysaPalace),
    ],
  ),

  // ─── Sentinel City (E) + Wreck of the Alecto (W) + Batigh Grotto (O'odham)
  //     triple pool ─────────────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: "Denira's Gift",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'House Disruptor Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Jacket",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Quirth's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Sinner's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Fighter',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _west, location: _alecto),
      BlueprintSource(region: _oodham, location: _batighGrotto),
    ],
  ),

  // ─── Sentinel City (E) only / + O'odham Batigh Grotto for Poison Mist ──
  BlueprintCatalogEntry(
    name: 'House Burst Drillshot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
    ],
  ),
  // Poison Mist also drops at Batigh Grotto per the O'odham guide.
  BlueprintCatalogEntry(
    name: 'Poison Mist',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _sentinelCity),
      BlueprintSource(region: _oodham, location: _batighGrotto),
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

  // ─── ITS 142 (E) + ITS 163 (O'odham) dual pool ───────────────────────
  // (Spice-infused Copper Dust also drops at ITS 142 — see
  // jabal_eifrit.dart.)
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
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Improved Reaper Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maraqeb Stillsuit Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
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
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Spark-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _east, location: _its142),
      BlueprintSource(region: _oodham, location: _its163),
    ],
  ),

  // ─── ITS 60 (W) + O'odham tri-pool ────────────────────────────────────
  // (Spice-infused Aluminum Dust + Spice-infused Copper Dust also drop
  // here — see the Aluminum entry above and jabal_eifrit.dart.)
  // 10 of these 12 schematics also drop in The O'odham's tri-source pool:
  // Stonestep Village / Imperial Testing Station No. 71 / Rockwarren
  // Village. Albatross Wing Module Mk4 and Experimental Vulcan GAU-94 are
  // ITS 60-only.
  //
  // Tarl Cutteray is listed at the O'odham tri-pool by IGN, but per the
  // user it has since been moved to Sheol in-game; see the "Pending
  // corrections" section of docs/RESEARCH_BLUEPRINTS.md.
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
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Compact Compactor Mk4',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Eviscerator',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
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
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Improved Suspensor Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Miner's Blessing",
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk4',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Pipecleaner',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shadrath's Drinker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Tarl Cutteray',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: _its60),
      BlueprintSource(region: _oodham, location: _stonestep),
      BlueprintSource(region: _oodham, location: _its71),
      BlueprintSource(region: _oodham, location: _rockwarren),
    ],
  ),
];
