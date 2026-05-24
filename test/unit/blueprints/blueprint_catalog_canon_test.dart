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
///  - Sheol:
///    https://www.ign.com/wikis/dune-awakening/All_Sheol_Unique_Schematics_and_Locations
///
/// **Patch 1.1.20 (Aug 2025)** swapped Tarl Cutteray (T5) and Sandflies
/// Carver (T4). The canon below reflects post-patch reality, not what
/// IGN's pre-patch Sheol/Shield Wall/O'odham guides still show:
///   - Tarl Cutteray drops in Sheol only (Delphis + Euporia).
///   - Sandflies Carver drops in O'odham (Stonestep + ITS 71 +
///     Rockwarren) + Western Shield Wall (ITS 60).
///
/// When IGN updates the guides — or when a new region is added — update this
/// table along with the catalog. The tests will surface drift in either
/// direction (missing entries OR hallucinated ones).
const Map<String, Map<String, List<String>>> _canon = {
  // Deep Desert — T5 A row + T6 B-I rows. Grid positions change weekly with
  // the Coriolis Storm; the canon is keyed by site name, not grid position.
  // T5 A row: "Forgotten Cave" appears ×3 in row A — identical pool, one label.
  // T6 B-I rows: "Forgotten Cave (outer)" = B7/D4/D9; "(inner)" = F1/F6.
  // "BTS" = Buried Testing Station; "deep" = D2 (larger pool); standard = F9/H2.
  // Provisional cave labels — verify against in-game signage when possible.
  'Deep Desert': {
    // ── T5 A row ──────────────────────────────────────────────────────────
    'Forgotten Cave': ['Spice-infused Duraluminum Dust'],
    'Imperial Testing Station No. 148': [
      'Cope',
      'Extravagant Message',
      'Filter Extractor Mk5',
      'Hummingbird Wing Module Mk5',
      'Maas Kharet Bloodbag',
      'Saturnine Stillsuit Boots',
      'Saturnine Stillsuit Garment',
      'Saturnine Stillsuit Gloves',
      'Saturnine Stillsuit Mask',
      'Spice-infused Duraluminum Dust',
      'Wayfinder Helm',
    ],
    'Imperial Testing Station No. 185': [
      'Arhun K-28 Lasgun',
      'Collapsible Dew Reaper Mk5',
      'Compact Compactor Mk5',
      'Double-sealed Stilltent',
      "Mendek's Rattle",
      'Night Rider Sandbike Boost Mk5',
      'Spice-infused Duraluminum Dust',
      'Station Gauntlets',
      'Steady Assault Boost Module Mk5',
    ],
    'Imperial Testing Station No. 186': [
      'Albatross Wing Module Mk5',
      'Focused Reaper Mk5',
      'Jolt-sword',
      'Long Range Scanner',
      'Scrubber',
      'Spice-infused Duraluminum Dust',
      'Station Garb',
      "Taqwa's Double",
      "The Emperor's Wings Mk5",
    ],
    'Imperial Testing Station No. 217': [
      'Albatross Wing Module Mk5',
      'Focused Reaper Mk5',
      'Jolt-sword',
      'Long Range Scanner',
      'Scrubber',
      'Spice-infused Duraluminum Dust',
      'Station Garb',
      "Taqwa's Double",
      "The Emperor's Wings Mk5",
    ],
    'Imperial Testing Station No. 37': [
      'Arhun K-28 Lasgun',
      'Collapsible Dew Reaper Mk5',
      'Compact Compactor Mk5',
      'Double-sealed Stilltent',
      "Mendek's Rattle",
      'Night Rider Sandbike Boost Mk5',
      'Spice-infused Duraluminum Dust',
      'Station Gauntlets',
      'Steady Assault Boost Module Mk5',
    ],
    'Imperial Testing Station No. 93': [
      'Cope',
      'Extravagant Message',
      'Filter Extractor Mk5',
      'Hummingbird Wing Module Mk5',
      'Maas Kharet Bloodbag',
      'Saturnine Stillsuit Boots',
      'Saturnine Stillsuit Garment',
      'Saturnine Stillsuit Gloves',
      'Saturnine Stillsuit Mask',
      'Spice-infused Duraluminum Dust',
      'Wayfinder Helm',
    ],
    'Wreck of the Archidamas III': [
      'Adept Disruptor Pistol',
      'Advanced Reaper Gloves',
      'Focused Buggy Cutteray Mk5',
      'Impure Extractor Mk5',
      "Piter's Disruptor",
      'Shaded Hood',
      "Shaitan's Tongue",
      'Spice-infused Duraluminum Dust',
    ],
    'Wreck of the Cycliadas': [
      'Advanced Suspensor Jacket',
      "Mendek's Boots",
      "Mendek's Chestplate",
      "Mendek's Gauntlets",
      "Mendek's Helmet",
      "Mendek's Pants",
      'Spice-infused Duraluminum Dust',
      'Tarl Softstep Boots',
    ],
    'Wreck of the Dioedas': [
      'Advanced Suspensor Jacket',
      "Mendek's Boots",
      "Mendek's Chestplate",
      "Mendek's Gauntlets",
      "Mendek's Helmet",
      "Mendek's Pants",
      'Spice-infused Duraluminum Dust',
      'Tarl Softstep Boots',
    ],
    'Wreck of the Eumenes': [
      'Advanced Suspensor Jacket',
      "Mendek's Boots",
      "Mendek's Chestplate",
      "Mendek's Gauntlets",
      "Mendek's Helmet",
      "Mendek's Pants",
      'Spice-infused Duraluminum Dust',
      'Tarl Softstep Boots',
    ],
    'Wreck of the Hicetas': [
      'Batigh Stillsuit Boots',
      'Batigh Stillsuit Garment',
      'Batigh Stillsuit Gloves',
      'Batigh Stillsuit Mask',
      'Kharet Viper',
      'Spice-infused Duraluminum Dust',
      'Stormrider Boost Module Mk5',
      'Syndicate Impaler',
    ],
    'Wreck of the Hyperbatas': [
      'Advanced Suspensor Jacket',
      "Mendek's Boots",
      "Mendek's Chestplate",
      "Mendek's Gauntlets",
      "Mendek's Helmet",
      "Mendek's Pants",
      'Spice-infused Duraluminum Dust',
      'Tarl Softstep Boots',
    ],
    'Wreck of the Orsippus': [
      'Advanced Suspensor Jacket',
      "Mendek's Boots",
      "Mendek's Chestplate",
      "Mendek's Gauntlets",
      "Mendek's Helmet",
      "Mendek's Pants",
      'Spice-infused Duraluminum Dust',
      'Tarl Softstep Boots',
    ],
    'Wreck of the Proxenus': [
      'Adept Disruptor Pistol',
      'Advanced Reaper Gloves',
      'Focused Buggy Cutteray Mk5',
      'Impure Extractor Mk5',
      "Piter's Disruptor",
      'Shaded Hood',
      "Shaitan's Tongue",
      'Spice-infused Duraluminum Dust',
    ],
    'Wreck of the Stasanor': [
      'Adept Disruptor Pistol',
      'Advanced Reaper Gloves',
      'Focused Buggy Cutteray Mk5',
      'Impure Extractor Mk5',
      "Piter's Disruptor",
      'Shaded Hood',
      "Shaitan's Tongue",
      'Spice-infused Duraluminum Dust',
    ],
    'Wreck of the Xenophon': [
      'Batigh Stillsuit Boots',
      'Batigh Stillsuit Garment',
      'Batigh Stillsuit Gloves',
      'Batigh Stillsuit Mask',
      'Kharet Viper',
      'Spice-infused Duraluminum Dust',
      'Stormrider Boost Module Mk5',
      'Syndicate Impaler',
    ],
    // ── T6 B-I rows ───────────────────────────────────────────────────────
    'Forgotten Cave (outer)': [
      'Collapsible Dew Reaper Mk6',
      'Compact Compactor Mk6',
      "Crew Chief's Stillsuit Garment",
      'Desert Garb',
      'Filter Extractor Mk6',
      'Focused Buggy Cutteray Mk6',
      'Hook-claw Gloves',
      'Imperial Stillsuit Boots',
      'Imperial Stillsuit Garment',
      'Imperial Stillsuit Gloves',
      'Imperial Stillsuit Mask',
      'Impure Extractor Mk6',
      'Ix-core Leggings',
      'Mohandis Sandbike Engine Mk6',
      'Night Rider Sandbike Boost Mk6',
      "Pardot's Hood",
      'Rattler Boost Module Mk6',
      'Replica Pulse-sword',
      "Shaddam's Bladder",
      'Spice-infused Plastanium Dust',
      'Swift Treadwheel Engine Mk6',
      'Tabr Softstep Boots',
      "The Baron's Bloodbag",
      "Villari's Stillsuit Boots",
      "Villari's Stillsuit Garment",
      "Villari's Stillsuit Gloves",
      "Villari's Stillsuit Mask",
      'Walker Sandcrawler Engine Mk6',
      'Wayfinder Helm',
    ],
    'Forgotten Cave (inner)': [
      'Circuit Gauntlets',
      'Compact Compactor Mk6',
      "Crew Chief's Stillsuit Garment",
      "Idaho's Charge",
      'Imperial Stillsuit Boots',
      'Imperial Stillsuit Garment',
      'Imperial Stillsuit Gloves',
      'Imperial Stillsuit Mask',
      'Impure Extractor Mk6',
      "Indara's Lullaby",
      'Ix-core Leggings',
      "Kynes's Cutteray",
      'Pincushion Boots',
      'Pincushion Chestpiece',
      'Pincushion Gauntlets',
      'Pincushion Helmet',
      'Pincushion Pants',
      'Regis Tripleshot Repeating Rifle',
      'Spice-infused Plastanium Dust',
      'Steady Assault Boost Module Mk6',
    ],
    'Buried Testing Station': [
      'A Dart for Every Man',
      'Adaptive Holtzman Shield',
      'Black Market K-28 Lasgun',
      'Bulwark Boots',
      'Bulwark Chest',
      'Bulwark Gloves',
      'Bulwark Helmet',
      'Bulwark Leggings',
      'Cauterizer',
      'Collapsible Dew Reaper Mk6',
      'Dunewatcher',
      "Feyd's Drinker",
      'Glasser',
      "Halleck's Pick",
      'Penetrator',
      'Plasma Cannon',
      'Power Harness',
      'Regis Burst Drillshot',
      'Salusan Vengeance',
      'Sardaukar Intimidator',
      'Schematic Pattern Grade 1',
      'Schematic Pattern Grade 2',
      'Schematic Pattern Grade 3',
      'Schematic Pattern Grade 4',
      'Schematic Pattern Grade 5',
      'Spike Hilt Sword',
      'Spice-infused Plastanium Dust',
      'Stormrider Boost Module Mk6',
      'Young Sparky Mk6',
    ],
    'Buried Testing Station (deep)': [
      'A Dart for Every Man',
      'Adaptive Holtzman Shield',
      'Albatross Wing Module Mk6',
      'Bigger Buggy Boot Mk6',
      'Bluddshot Buggy Engine Mk6',
      'Burning Blades',
      'Circuit Gauntlets',
      "Executor's Boots",
      "Executor's Chestpiece",
      "Executor's Gauntlets",
      "Executor's Helmet",
      "Executor's Pants",
      "Feyd's Drinker",
      'Glasser',
      "Halleck's Pick",
      'Hummingbird Wing Module Mk6',
      "Idaho's Charge",
      "Kynes's Cutteray",
      'Omni Focused Dew Scythe',
      'Penetrator',
      'Power Harness',
      'Replica Pulse-knife',
      'Roc Carrier Wing',
      'Salusan Vengeance',
      'Schematic Pattern Grade 1',
      'Schematic Pattern Grade 2',
      'Schematic Pattern Grade 3',
      'Schematic Pattern Grade 4',
      'Schematic Pattern Grade 5',
      'Spice-infused Plastanium Dust',
      'Steady Assault Boost Module Mk6',
      'Steady Carrier Boost Module Mk6',
      'Steady Treadwheel Boost Module Mk6',
      'Stormrider Boost Module Mk6',
      'Tactical Radiation Suit',
      "The Emperor's Wings Mk6",
      'The Forge Boots',
      'The Forge Chestpiece',
      'The Forge Gloves',
      'The Forge Helmet',
      'The Forge Pants',
      "Yueh's Reaper Gloves",
      'Young Sparky Mk6',
    ],
    'Fallen Shipwreck': [
      "Bashar's Command",
      "Executor's Boots",
      "Executor's Chestpiece",
      "Executor's Gauntlets",
      "Executor's Helmet",
      "Executor's Pants",
      'Hummingbird Wing Module Mk6',
      'Perforator',
      'Regis Disruptor Pistol',
      'Replica Pulse-knife',
      'Replica Pulse-sword',
      'Seethe',
      'Shellburster',
      "Shishakli's Bite",
      'Static Needle',
      'Steady Treadwheel Boost Module Mk6',
      "The Baron's Bloodbag",
      'Vaporizer',
      'Way of the Misr',
    ],
    'Unrecovered Shipwreck': [
      "Bashar's Command",
      "Executor's Boots",
      "Executor's Chestpiece",
      "Executor's Gauntlets",
      "Executor's Helmet",
      "Executor's Pants",
      'Hummingbird Wing Module Mk6',
      'Perforator',
      'Regis Disruptor Pistol',
      'Replica Pulse-knife',
      'Replica Pulse-sword',
      'Seethe',
      'Shellburster',
      "Shishakli's Bite",
      'Spice-infused Plastanium Dust',
      'Static Needle',
      'Steady Treadwheel Boost Module Mk6',
      "The Baron's Bloodbag",
      'Vaporizer',
      'Way of the Misr',
    ],
  },
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
      'Shredder',
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
      'Rattler Boost Module Mk3',
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
      'Artisan Disruptor Pistol',
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
      'Shock-Knife',
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
      'Sandflies Carver',
      "Shadrath's Drinker",
      'Spice-infused Aluminum Dust',
      'Spice-infused Copper Dust',
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
      'Sandflies Carver',
      "Shadrath's Drinker",
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
      'Sandflies Carver',
      "Shadrath's Drinker",
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
      'Sandflies Carver',
      "Shadrath's Drinker",
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
  // Power Gauntlets. The Beast's Claw shares its 11-entry pool with
  // the Shield Wall Southern Comms / Passage of Artemis / Sirr'asraar
  // Vault tri-source pool except for Spice-infused Aluminum Dust.
  //
  // IGN's Mysa Tarill guide table renders Sentinel Pants as a duplicate
  // "Sentinel Jacket" row — the catalog and canon test treat the second
  // Jacket row as Sentinel Pants per in-game confirmation from the user.
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
      'Sentinel Pants',
      'Spark-Knife',
      "The Emperor's Wings Mk4",
    ],
  },
  // Sheol — endgame Mk5/Duraluminum region with the radiated zone and
  // PvP shipwrecks. Tarl Cutteray was moved here from the T4 zones by
  // patch 1.1.20; Sandflies Carver was swapped the other way. The
  // canon below reflects post-patch state — IGN's Sheol guide still
  // lists Sandflies Carver at Delphis/Euporia, which is stale.
  // Fallen Shipwreck is a dynamic event that occurs across Hagga Basin
  // (all sub-regions except the south). Pool from dune.gaming.tools
  // (~3.3% per item, 13 uniques). Cutteray required; Sandworm timer.
  // Four items are unique to this pool; nine overlap with Sheol sites.
  'Hagga Basin': {
    'Fallen Shipwreck': [
      'Adept Burst Drillshot',
      'Bigger Buggy Boot Mk5',
      'Bite Back Blade',
      'Desert Dasher Garment',
      'Dune Dancer Stillsuit Garment',
      'Jolt-knife',
      "Sprinter's Stillsuit Garment",
      'Steady Treadwheel Boost Module Mk5',
      'Swift Treadwheel Engine Mk5',
      'Syndicate Boots',
      'Syndicate Chestplate',
      'Syndicate Gauntlets',
      'Syndicate Helmet',
      'Syndicate Pants',
      'Way of the Desert',
    ],
  },
  'Sheol': {
    "Shaitan's Grotto": [
      'Acheronian Boots',
      'Acheronian Chestplate',
      'Acheronian Gauntlets',
      'Acheronian Helmet',
      'Acheronian Pants',
      'Buoyant Reaper Mk5',
      'Moisture Sealer',
      'Rattler Boost Module Mk5',
      'Relentless',
    ],
    'Edge of Acheron': [
      'Adept Burst Drillshot',
      'Bigger Buggy Boot Mk5',
      'Syndicate Boots',
      'Syndicate Chestplate',
      'Syndicate Helmet',
      'Syndicate Pants',
      'Way of the Desert',
    ],
    'Wreck of the Delphis': [
      'Adept Tripleshot Repeating Rifle',
      'Bigger Buggy Boot Mk5',
      'Bluddshot Buggy Engine Mk5',
      "Fivefinger's Tripleshot Rifle",
      'Hajra Literjon Mk5',
      'Jolt-knife',
      'Stim-Leggings',
      'Syndicate Gauntlets',
      'Syndicate Helmet',
      'Tarl Cutteray',
      "Thufir's Best",
      'Young Sparky Mk5',
    ],
    'Wreck of the Euporia': [
      'Acheronian Helmet',
      'Adept Tripleshot Repeating Rifle',
      'Bluddshot Buggy Engine Mk5',
      "Fivefinger's Tripleshot Rifle",
      'Hajra Literjon Mk5',
      'Tarl Cutteray',
      "Thufir's Best",
      'Young Sparky Mk5',
    ],
    'Downed Ships': [
      'Syndicate Chestplate',
      'Syndicate Pants',
      "Thufir's Best",
      'Way of the Desert',
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
          final missing = sitesCanon.keys.toSet().difference(sitesInCatalog);
          final extra = sitesInCatalog.difference(sitesCanon.keys.toSet());
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
      final actual = blueprintCatalog.fold<int>(
          0, (sum, entry) => sum + entry.sources.length);
      expect(actual, expected,
          reason: 'catalog has $actual source rows, canon has $expected');
    });
  });
}
