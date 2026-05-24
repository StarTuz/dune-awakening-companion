import '../blueprint_catalog.dart';

const _region = 'Sheol';
const _haggaBasin = 'Hagga Basin';

const _edgeOfAcheron = 'Edge of Acheron';
const _shaitan = "Shaitan's Grotto";
const _delphis = 'Wreck of the Delphis';
const _euporia = 'Wreck of the Euporia';
const _downedShips = 'Downed Ships';
const _fallenShipwreck = 'Fallen Shipwreck';

/// Seed list from IGN's Sheol unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Sheol_Unique_Schematics_and_Locations
///
/// Additional source: dune.gaming.tools loot tables (Fallen Shipwreck pool).
///
/// Sheol is the endgame Duraluminum (Mk5/T5) region — the radiated zone
/// at the centre of the map. Chests are gated behind radiation, ID
/// bands, sealed doors, and cutteray work; some sites are inside the
/// open-PvP zone.
///
/// **Patch 1.1.20 (Aug 2025)** swapped two schematics between regions
/// to correct a tier mismatch:
///   - **Tarl Cutteray** (T5/Duraluminum) was previously dropping in
///     T4 zones (O'odham + Western Shield Wall ITS 60). The patch moved
///     it OUT of those zones and INTO Sheol — specifically Wreck of
///     the Delphis + Wreck of the Euporia (~12.5-15% drop chance).
///   - **Sandflies Carver** (T4/Aluminum) was swapped INTO the
///     vacated O'odham + ITS 60 slots. That entry lives in
///     `oodham.dart` because 3 of its 4 sources are there.
///
/// IGN's Sheol guide still lists Sandflies Carver at Delphis/Euporia —
/// that's the pre-patch state. The catalog reflects post-patch reality.
///
/// "Downed Ships" is a deliberate location label (not a named site) —
/// IGN uses it for schematics that drop at the random ship wrecks
/// scattered around Sheol, distinct from the two named wrecks
/// (Delphis, Euporia) and the dynamic Fallen Shipwreck event.
///
/// "Fallen Shipwreck" is a dynamic, time-limited world event: a ship
/// falls from the sky, crashes into the sand (Hagga Basin or Deep
/// Desert), and burns. Players must use a Cutteray to cut open external
/// hatches before a Sandworm arrives and swallows the wreck. Its 13-
/// entry unique-schematic pool was sourced from dune.gaming.tools.
/// Desert Dasher Garment was later confirmed in the same pool as a
/// Tier 2 unique. Five schematics are unique to this pool; the
/// remaining nine are shared with Edge of Acheron, Wreck of the
/// Delphis, or both. Distinct from "Downed Ships" (static PvP wrecks).
const sheolBlueprintCatalog = [
  // ─── Shaitan's Grotto ────────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Acheronian Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Acheronian Chestplate',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Acheronian Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  // Acheronian Helmet also drops at Wreck of the Euporia.
  BlueprintCatalogEntry(
    name: 'Acheronian Helmet',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Acheronian Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Buoyant Reaper Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Moisture Sealer',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Rattler Boost Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Relentless',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _shaitan),
    ],
  ),

  // ─── Edge of Acheron + Fallen Shipwreck ──────────────────────────────
  BlueprintCatalogEntry(
    name: 'Adept Burst Drillshot',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Syndicate Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),

  // ─── Edge of Acheron + Downed Ships + Fallen Shipwreck ───────────────
  BlueprintCatalogEntry(
    name: 'Syndicate Chestplate',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _region, location: _downedShips),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Syndicate Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _region, location: _downedShips),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Desert',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _region, location: _downedShips),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),

  // ─── Edge of Acheron + Wreck of the Delphis + Fallen Shipwreck ───────
  BlueprintCatalogEntry(
    name: 'Bigger Buggy Boot Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Syndicate Helmet',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _edgeOfAcheron),
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),

  // ─── Wreck of the Delphis + Fallen Shipwreck ─────────────────────────
  BlueprintCatalogEntry(
    name: 'Jolt-knife',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  // IGN lists this as "Syndicate Gauntlets" in the schematic name column
  // and "Syndicate Gloves" in the alt text — the catalog follows the
  // schematic name column.
  BlueprintCatalogEntry(
    name: 'Syndicate Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),

  // ─── Wreck of the Delphis only ───────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Stim-Leggings',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
    ],
  ),

  // ─── Wreck of the Delphis + Wreck of the Euporia ─────────────────────
  BlueprintCatalogEntry(
    name: 'Adept Tripleshot Repeating Rifle',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Bluddshot Buggy Engine Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Fivefinger's Tripleshot Rifle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk5',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Young Sparky Mk5',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),
  // Tarl Cutteray — moved here from Western Shield Wall + The O'odham
  // by patch 1.1.20. ~12.5-15% drop chance per the patch notes.
  BlueprintCatalogEntry(
    name: 'Tarl Cutteray',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
    ],
  ),

  // ─── Wreck of the Delphis + Wreck of the Euporia + Downed Ships ──────
  BlueprintCatalogEntry(
    name: "Thufir's Best",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _delphis),
      BlueprintSource(region: _region, location: _euporia),
      BlueprintSource(region: _region, location: _downedShips),
    ],
  ),

  // ─── Fallen Shipwreck only ───────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Bite Back Blade',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Dune Dancer Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Desert Dasher Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Sprinter's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Steady Treadwheel Boost Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Swift Treadwheel Engine Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _haggaBasin, location: _fallenShipwreck),
    ],
  ),
];
