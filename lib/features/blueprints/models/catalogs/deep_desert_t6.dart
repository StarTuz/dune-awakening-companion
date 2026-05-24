import '../blueprint_catalog.dart';

const _region = 'Deep Desert';

// Named site types — B-I rows (grid positions change weekly with the Coriolis Storm)
// "Forgotten Cave (outer)" and "Forgotten Cave (inner)" are provisional labels for
// two clearly distinct loot pools that both occupy Forgotten Cave sites; in-game
// signage may differ — update these labels once confirmed.
const _forgottenCaveOuter = 'Forgotten Cave (outer)';
const _forgottenCaveInner = 'Forgotten Cave (inner)';
const _buriedStation = 'Buried Testing Station';
const _buriedStationDeep = 'Buried Testing Station (deep)';
const _fallenShipwreck = 'Fallen Shipwreck';
const _unrecoveredShipwreck = 'Unrecovered Shipwreck';

// TODO(deep-desert-model): This file was built with the same static-site
// assumptions used for Hagga Basin / Sheol, which is wrong for Deep Desert.
// Deep Desert B-I rows do not work like fixed-location regions — the modelling
// approach needs to be reconsidered before this data is treated as accurate.
// All source locations below are approximate until the correct model is applied.

/// Deep Desert — T6/Plastanium tier, rows B through I.
///
/// Same Coriolis Storm weekly reset applies as A row — site names are
/// stable, grid coordinates change each cycle. Data sourced from
/// dune.gaming.tools (B-I rows).
///
/// **B-I row — site types and pool structure:**
///
///   Site type                     │ Instances  │ Pool size
///   ──────────────────────────────┼────────────┼──────────────
///   Forgotten Cave (outer)        │ B7/D4/D9   │ 29 items
///   Forgotten Cave (inner)        │ F1/F6      │ 20 items
///   Buried Testing Station        │ F9/H2      │ 29 items (incl. Patterns)
///   Buried Testing Station (deep) │ D2         │ 43 items
///   Fallen Shipwreck              │ dynamic    │ 19 items (no Dust)
///   Unrecovered Shipwreck         │ H2/H8/I5   │ 20 items
///
/// **Forgotten Cave labels are provisional.** B7/D4/D9 share one pool;
/// F1/F6 share a different, smaller pool. The outer/inner names are
/// working labels until in-game signage is verified.
///
/// **Fallen Shipwreck:** PvE and PvP variants list 19 identical schematics
/// (slight rate variance is likely an instance data artefact). Modelled
/// as a single location. The T5 Fallen Shipwreck in Hagga Basin is a
/// separate event catalogued in sheol.dart. Plastanium Dust is NOT listed
/// for the Fallen Shipwreck — it is absent from this dynamic event pool.
const deepDesertT6BlueprintCatalog = [
  // ─── Buried Testing Station (deep) — D2 exclusive ─────────────────────
  BlueprintCatalogEntry(
    name: 'Albatross Wing Module Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Bigger Buggy Boot Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Bluddshot Buggy Engine Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Burning Blades',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Omni Focused Dew Scythe',
    category: 'Tool',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Roc Carrier Wing',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Steady Carrier Boost Module Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'Tactical Radiation Suit',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk6",
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'The Forge Boots',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'The Forge Chestpiece',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'The Forge Gloves',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'The Forge Helmet',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: 'The Forge Pants',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),
  BlueprintCatalogEntry(
    name: "Yueh's Reaper Gloves",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStationDeep)],
  ),

  // ─── Buried Testing Station (standard) — F9/H2 exclusive ──────────────
  BlueprintCatalogEntry(
    name: 'Black Market K-28 Lasgun',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Bulwark Boots',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Bulwark Chest',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Bulwark Gloves',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Bulwark Helmet',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Bulwark Leggings',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Cauterizer',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Dunewatcher',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Plasma Cannon',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Regis Burst Drillshot',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Sardaukar Intimidator',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),
  BlueprintCatalogEntry(
    name: 'Spike Hilt Sword',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _buriedStation)],
  ),

  // ─── Forgotten Cave (outer) — B7/D4/D9 exclusive ──────────────────────
  BlueprintCatalogEntry(
    name: 'Desert Garb',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Filter Extractor Mk6',
    category: 'Tool',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Hook-claw Gloves',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Pardot's Hood",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Rattler Boost Module Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Shaddam's Bladder",
    category: 'Utility',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Swift Treadwheel Engine Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Tabr Softstep Boots',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Villari's Stillsuit Boots",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Villari's Stillsuit Garment",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Villari's Stillsuit Gloves",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: "Villari's Stillsuit Mask",
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),
  BlueprintCatalogEntry(
    name: 'Walker Sandcrawler Engine Mk6',
    category: 'Vehicle',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveOuter)],
  ),

  // ─── Forgotten Cave (inner) — F1/F6 exclusive ─────────────────────────
  BlueprintCatalogEntry(
    name: "Indara's Lullaby",
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Pincushion Boots',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Pincushion Chestpiece',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Pincushion Gauntlets',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Pincushion Helmet',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Pincushion Pants',
    category: 'Armor',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),
  BlueprintCatalogEntry(
    name: 'Regis Tripleshot Repeating Rifle',
    category: 'Weapon',
    sources: [BlueprintSource(region: _region, location: _forgottenCaveInner)],
  ),

  // ─── BTS (deep) + BTS (standard) ──────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'A Dart for Every Man',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Adaptive Holtzman Shield',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Feyd's Drinker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Glasser',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Halleck's Pick",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Penetrator',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Power Harness',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Salusan Vengeance',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stormrider Boost Module Mk6',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Young Sparky Mk6',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),

  // ─── BTS (deep) + Cave (inner) ─────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Circuit Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Idaho's Charge",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Kynes's Cutteray",
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Steady Assault Boost Module Mk6',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),

  // ─── BTS (deep) + Fallen Shipwreck + Unrecovered Shipwreck ────────────
  BlueprintCatalogEntry(
    name: "Executor's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Executor's Chestpiece",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Executor's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Executor's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Executor's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Hummingbird Wing Module Mk6',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Replica Pulse-knife',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Steady Treadwheel Boost Module Mk6',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),

  // ─── Cave (outer) + Fallen Shipwreck + Unrecovered Shipwreck ──────────
  BlueprintCatalogEntry(
    name: 'Replica Pulse-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Baron's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),

  // ─── Cave (outer) + Cave (inner) ──────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Compact Compactor Mk6',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Crew Chief's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Imperial Stillsuit Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Imperial Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Imperial Stillsuit Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Imperial Stillsuit Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Impure Extractor Mk6',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Ix-core Leggings',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
    ],
  ),

  // ─── Cave (outer) + BTS (standard) ────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Collapsible Dew Reaper Mk6',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),

  // ─── Fallen Shipwreck + Unrecovered Shipwreck ─────────────────────────
  BlueprintCatalogEntry(
    name: "Bashar's Command",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Perforator',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Regis Disruptor Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Seethe',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shellburster',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shishakli's Bite",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Static Needle',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Vaporizer',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Misr',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _fallenShipwreck),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),

  // ─── Schematic Patterns — BTS (deep) + BTS (standard) ─────────────────
  BlueprintCatalogEntry(
    name: 'Schematic Pattern Grade 1',
    category: 'Schematic',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Schematic Pattern Grade 2',
    category: 'Schematic',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Schematic Pattern Grade 3',
    category: 'Schematic',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Schematic Pattern Grade 4',
    category: 'Schematic',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Schematic Pattern Grade 5',
    category: 'Schematic',
    sources: [
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _buriedStation),
    ],
  ),

  // ─── Spice-infused Plastanium Dust — all T6 sites except Fallen ────────
  // 100% drop at Cave (outer/inner), BTS (standard/deep), Unrecovered Shipwreck.
  // Fallen Shipwreck (dynamic event) does NOT drop Plastanium Dust.
  BlueprintCatalogEntry(
    name: 'Spice-infused Plastanium Dust',
    category: 'Other',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCaveOuter),
      BlueprintSource(region: _region, location: _forgottenCaveInner),
      BlueprintSource(region: _region, location: _buriedStation),
      BlueprintSource(region: _region, location: _buriedStationDeep),
      BlueprintSource(region: _region, location: _unrecoveredShipwreck),
    ],
  ),
];
