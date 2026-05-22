import '../blueprint_catalog.dart';

const _west = 'Vermillius Gap West';
const _east = 'Vermillius Gap East';

/// Seed list from IGN's Vermillius Gap unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Vermillius_Gap_Unique_Schematics_and_Locations
///
/// Several schematics drop in both West and East. Each entry collapses
/// those duplicates into a single catalog row with multiple sources, so
/// unlocking the schematic from either side flips the checklist
/// everywhere it appears.
const vermilliusGapBlueprintCatalog = [
  // ─── West-only ───────────────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: "Iri's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Northwest Iron Works'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Scipio's Drinker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: 'Northwest Iron Works'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Buoyant Reaper Mk2',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: 'Table of the Gods'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Olef's Quickcutter",
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: 'Imperial Station No. 197'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Softstep Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Imperial Station No. 197'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Fila's Regret",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: 'Wreck of the Pallas'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Legion Tattoo',
    category: 'Other',
    sources: [
      BlueprintSource(region: _west, location: 'Wreck of the Pallas'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk2',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: 'Wreck of the Pallas'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Wanderer',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: 'Wreck of the Pallas'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Compact Compactor Mk3',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _west, location: 'The Anomaly'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Kel's Stillsuit Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'The Anomaly'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Kel's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'The Anomaly'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Kel's Stillsuit Gloves",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'The Anomaly'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Kel's Stillsuit Mask",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'The Anomaly'),
    ],
  ),

  // ─── Shared West + East ──────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Old Sparky Mk2',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: 'Northwest Iron Works'),
      BlueprintSource(region: _east, location: "Mirzabah's Head"),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk2',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _west, location: 'Table of the Gods'),
      BlueprintSource(region: _east, location: "Mirzabah's Head"),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Scipio's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _west, location: 'Table of the Gods'),
      BlueprintSource(region: _east, location: "Mirzabah's Head"),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk2",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _west, location: 'Table of the Gods'),
      BlueprintSource(region: _east, location: "Mirzabah's Head"),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Pseudo-Pulse-Sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendia's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendia's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendia's Jacket",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendia's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendia's Wrap",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: "Miner's Watch"),
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Oathbreaker Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Coils of the Wyrm'),
      BlueprintSource(region: _east, location: 'Suk Alusus'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Oathbreaker Chestpiece',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Coils of the Wyrm'),
      BlueprintSource(region: _east, location: 'Suk Alusus'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Oathbreaker Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Coils of the Wyrm'),
      BlueprintSource(region: _east, location: 'Suk Alusus'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Oathbreaker Headwrap',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Coils of the Wyrm'),
      BlueprintSource(region: _east, location: 'Suk Alusus'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Oathbreaker Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _west, location: 'Coils of the Wyrm'),
      BlueprintSource(region: _east, location: 'Suk Alusus'),
    ],
  ),

  // ─── East-only ───────────────────────────────────────────────────────
  // Buoyant Reaper Mk3 also drops in Hagga Rift (Stepstone Cavern). Kept
  // here so the entry lives next to its other Vermillius Gap siblings; the
  // Hagga Rift source is appended below.
  BlueprintCatalogEntry(
    name: 'Buoyant Reaper Mk3',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _east, location: "Mirzabah's Head"),
      BlueprintSource(
        region: 'Hagga Rift',
        location: 'Stepstone Cavern',
      ),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Menol's Stillsuit Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: 'Ghanima Cavern'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Menol's Stillsuit Garment",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: 'Ghanima Cavern'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Menol's Stillsuit Gloves",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: 'Ghanima Cavern'),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Menol's Stillsuit Mask",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _east, location: 'Ghanima Cavern'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk2',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: 'Ghanima Cavern'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Bigger Buggy Boot Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Bluddshot Buggy Engine Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _east, location: 'Imperial Testing Station No. 10'),
    ],
  ),
];
