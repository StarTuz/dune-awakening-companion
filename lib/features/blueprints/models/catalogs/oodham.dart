import '../blueprint_catalog.dart';

const _region = "The O'odham";

const _its71 = 'Imperial Testing Station No. 71';
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
];
