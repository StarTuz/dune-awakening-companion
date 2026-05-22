import '../blueprint_catalog.dart';

const _region = "The O'odham";

const _stonestep = 'Stonestep Village';
const _its71 = 'Imperial Testing Station No. 71';
const _rockwarren = 'Rockwarren Village';
const _its163 = 'Imperial Testing Station No. 163';

/// Seed list from IGN's The O'odham unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_The_O%27odham_Unique_Schematics_and_Locations
///
/// The O'odham is a late-game region with heavy overlap into Shield Wall:
/// most "Mk4" schematics drop at multiple O'odham sites in addition to
/// their Shield Wall sources. Those cross-region entries live in
/// `shield_wall.dart` with the O'odham sources appended.
///
/// This file only contains schematics **exclusive to The O'odham**.
const oodhamBlueprintCatalog = [
  // ─── Imperial Testing Station No. 163 ────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Firestorm',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its163),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Ironwatch Special',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _its163),
    ],
  ),

  // ─── Imperial Testing Station No. 71 only ────────────────────────────
  // (The tri-source pool spanning Stonestep / ITS 71 / Rockwarren is
  // covered by entries in shield_wall.dart that gain O'odham sources;
  // Compression-Stim Leggings is the only ITS 71-exclusive schematic.)
  BlueprintCatalogEntry(
    name: 'Compression-Stim Leggings',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _its71),
    ],
  ),

  // ─── Sandflies Carver — Tarl Cutteray's T4 swap-in replacement ───────
  // Patch 1.1.20 (Aug 2025) moved Tarl Cutteray (T5/Duraluminum) out of
  // these low-tier sites and swapped Sandflies Carver (T4/Aluminum) into
  // them. Lives here because 3 of 4 sources are in The O'odham. IGN's
  // Sheol guide still lists Sandflies Carver at Delphis/Euporia, but
  // that's the pre-patch state — those slots now hold Tarl Cutteray
  // (see sheol.dart).
  BlueprintCatalogEntry(
    name: 'Sandflies Carver',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _stonestep),
      BlueprintSource(region: _region, location: _its71),
      BlueprintSource(region: _region, location: _rockwarren),
      BlueprintSource(
        region: 'Western Shield Wall',
        location: 'Imperial Testing Station No. 60',
      ),
    ],
  ),
];
