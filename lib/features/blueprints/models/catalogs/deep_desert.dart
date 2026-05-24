import '../blueprint_catalog.dart';

const _region = 'Deep Desert';

// Named sites — A row (grid positions change each week with the Coriolis Storm)
const _forgottenCave = 'Forgotten Cave';
const _its37 = 'Imperial Testing Station No. 37';
const _its93 = 'Imperial Testing Station No. 93';
const _its148 = 'Imperial Testing Station No. 148';
const _its185 = 'Imperial Testing Station No. 185';
const _its186 = 'Imperial Testing Station No. 186';
const _its217 = 'Imperial Testing Station No. 217';
const _archidamas = 'Wreck of the Archidamas III';
const _cycliadas = 'Wreck of the Cycliadas';
const _dioedas = 'Wreck of the Dioedas';
const _eumenes = 'Wreck of the Eumenes';
const _hicetas = 'Wreck of the Hicetas';
const _hyperbatas = 'Wreck of the Hyperbatas';
const _orsippus = 'Wreck of the Orsippus';
const _proxenus = 'Wreck of the Proxenus';
const _stasanor = 'Wreck of the Stasanor';
const _xenophon = 'Wreck of the Xenophon';

/// Deep Desert — endgame T5/Duraluminum region, accessible only by
/// ornithopter. Loot data sourced from dune.gaming.tools (A row).
///
/// **Coriolis Storm:** the entire zone resets weekly (every Tuesday,
/// times vary by server region). All player-built structures, vehicles,
/// and abandoned items are destroyed. Points of interest — Forgotten
/// Caves, Buried Imperial Testing Stations, and named shipwrecks — are
/// repositioned to new grid coordinates (A1-A9, B1-B9, …). The loot
/// pools below are tied to the *site name*, not the grid position.
///
/// **A row — pool structure (this file covers A row only):**
///
///   Pool                     │ Sites                          │ Unique schematics
///   ─────────────────────────┼────────────────────────────────┼───────────────────
///   Forgotten Cave           │ ×3 (A1, A5, A8)                │ Dust only
///   ITS 148 / ITS 93         │ A4, A5                         │ 10 (each 10%)
///   ITS 185 / ITS 37         │ A3, A2                         │ 8 (14%, Lasgun 1.4%)
///   ITS 186 / ITS 217        │ A8, A9                         │ 8 (each 13%)
///   Archidamas/Proxenus/     │ A3, A7, A9                     │ 7 (each 14%)
///     Stasanor               │                                │
///   Cycliadas/Dioedas/       │ A3, A4, A1, A2, A9             │ 7 (each 14%)
///     Eumenes/Hyperbatas/    │                                │
///     Orsippus               │                                │
///   Hicetas / Xenophon       │ A1, A5                         │ 7 (each 14%)
///   ─────────────────────────┼────────────────────────────────┼───────────────────
///   All sites (A row)        │ 17 named locations             │ Duraluminum Dust (100%)
///
/// Grid positions shown are from a sample week — they change each reset.
/// "Forgotten Cave" appears three times per week in row A; the pool is
/// identical at each instance so all three share a single location label.
const deepDesertBlueprintCatalog = [
  // ─── ITS 148 + ITS 93 pool (10 uniques, each ~10%) ───────────────────
  BlueprintCatalogEntry(
    name: 'Cope',
    category: 'Other',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Extravagant Message',
    category: 'Other',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Filter Extractor Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Hummingbird Wing Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Maas Kharet Bloodbag',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Saturnine Stillsuit Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Saturnine Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Saturnine Stillsuit Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Saturnine Stillsuit Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Wayfinder Helm',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its93),
      // Also drops in the T6 Forgotten Cave (outer) pool (B7/D4/D9).
      BlueprintSource(region: _region, location: 'Forgotten Cave (outer)'),
    ],
  ),

  // ─── ITS 185 + ITS 37 pool (8 uniques, 14%; Lasgun 1.4%) ─────────────
  // The Arhun K-28 Lasgun's notably lower drop rate (1.4% vs 14%) suggests
  // it is the rare "jackpot" slot for this pool.
  BlueprintCatalogEntry(
    name: 'Arhun K-28 Lasgun',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Collapsible Dew Reaper Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Compact Compactor Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Double-sealed Stilltent',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Rattle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Night Rider Sandbike Boost Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Station Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Steady Assault Boost Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its37),
    ],
  ),

  // ─── ITS 186 + ITS 217 pool (8 uniques, each ~13%) ───────────────────
  BlueprintCatalogEntry(
    name: 'Albatross Wing Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Reaper Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Jolt-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Long Range Scanner',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Scrubber',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Station Garb',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Taqwa's Double",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk5",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
    ],
  ),

  // ─── Archidamas III + Proxenus + Stasanor pool (7 uniques, ~14%) ─────
  BlueprintCatalogEntry(
    name: 'Adept Disruptor Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Advanced Reaper Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Impure Extractor Mk5',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Piter's Disruptor",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shaded Hood',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Shaitan's Tongue",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
    ],
  ),

  // ─── Cycliadas + Dioedas + Eumenes + Hyperbatas + Orsippus pool ───────
  // (7 uniques, each ~14% — "Mendek's set" pool)
  BlueprintCatalogEntry(
    name: 'Advanced Suspensor Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Chestplate",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Mendek's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Tarl Softstep Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
    ],
  ),

  // ─── Hicetas + Xenophon pool (7 uniques, each ~14%) ──────────────────
  BlueprintCatalogEntry(
    name: 'Batigh Stillsuit Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Batigh Stillsuit Garment',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Batigh Stillsuit Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Batigh Stillsuit Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Kharet Viper',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Stormrider Boost Module Mk5',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Syndicate Impaler',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),

  // ─── Spice-infused Duraluminum Dust — guaranteed at all A-row sites ───
  // 100% drop, 6-19 quantity. Covers all 17 named locations in this file.
  BlueprintCatalogEntry(
    name: 'Spice-infused Duraluminum Dust',
    category: 'Other',
    sources: [
      BlueprintSource(region: _region, location: _forgottenCave),
      BlueprintSource(region: _region, location: _its37),
      BlueprintSource(region: _region, location: _its93),
      BlueprintSource(region: _region, location: _its148),
      BlueprintSource(region: _region, location: _its185),
      BlueprintSource(region: _region, location: _its186),
      BlueprintSource(region: _region, location: _its217),
      BlueprintSource(region: _region, location: _archidamas),
      BlueprintSource(region: _region, location: _cycliadas),
      BlueprintSource(region: _region, location: _dioedas),
      BlueprintSource(region: _region, location: _eumenes),
      BlueprintSource(region: _region, location: _hicetas),
      BlueprintSource(region: _region, location: _hyperbatas),
      BlueprintSource(region: _region, location: _orsippus),
      BlueprintSource(region: _region, location: _proxenus),
      BlueprintSource(region: _region, location: _stasanor),
      BlueprintSource(region: _region, location: _xenophon),
    ],
  ),
];
