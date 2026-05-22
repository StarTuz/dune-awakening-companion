import '../blueprint_catalog.dart';

const _region = 'Hagga Rift';

// IGN guides use "Imperial Testing Station #29" and "Choam Mineral
// Extraction Facility #6"; the catalog normalises both to "No. N" to match
// the Hagga Basin South and Vermillius Gap conventions.

const _deserterCamp = 'Deserter Camp in Imperial Testing Station No. 29';
const _choamFacility = 'Choam Mineral Extraction Facility No. 6';
const _stepstone = 'Stepstone Cavern';
const _spiral = 'The Spiral';
const _arctus = 'Arctus Cavern';
const _kytheria = 'Wreck of Kytheria';

/// Seed list from IGN's Hagga Rift unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Hagga_Rift_Unique_Schematics_and_Locations
///
/// Several schematics share a drop pool — IGN renders them as "X or Y" in
/// the location column. Those collapse into one catalog entry with
/// multiple sources here, so unlocking from any listed site flips the
/// checklist for the schematic everywhere it appears.
///
/// Note: `Buoyant Reaper Mk3` also drops in Hagga Rift / Stepstone Cavern,
/// but its catalog entry lives in `vermillius_gap.dart` next to its
/// Vermillius Gap East source. The canon test still asserts the Hagga
/// Rift source is wired up.
const haggaRiftBlueprintCatalog = [
  // ─── The Spiral / Arctus Cavern shared pool ───────────────────────────
  BlueprintCatalogEntry(
    name: 'Inkvine Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Handheld Life Scanner Mk3',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Assassin's Rifle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),

  // ─── Deserter Camp (Station 29) / Choam #6 shared pool ────────────────
  BlueprintCatalogEntry(
    name: "Callie's Breaker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Old Sparky Mk3',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Seb's Kisser",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shock-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  // Three-way drop pool — Deserter Camp / Choam #6 / Stepstone Cavern.
  BlueprintCatalogEntry(
    name: "Glutton's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),

  // ─── Stepstone Cavern only ────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk3',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shock Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Skin-Lined Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Ta'lab Softstep Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk3",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
    ],
  ),

  // ─── Wreck of Kytheria ────────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: "Karak's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Jacket",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Lost Maula Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Zaal's Companion Assault Rifle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Ripper Scattergun',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
    ],
  ),
];
