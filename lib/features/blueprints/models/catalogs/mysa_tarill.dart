import '../blueprint_catalog.dart';

const _region = 'Mysa Tarill';
const _palace = 'Mysa Tarill';

/// Seed list from IGN's Mysa Tarill unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Mysa_Tarill_Unique_Schematics_and_Locations
///
/// Mysa Tarill is mostly overlap with Shield Wall — 18 of 19 IGN-listed
/// entries are existing Shield Wall rows that gain Mysa Tarill sources
/// in `shield_wall.dart`. This file contains the single Mysa-Tarill-
/// exclusive schematic.
///
/// Note: "Mysa Tarill" is both the region and the name of the ornate
/// stone palace where one of the chests sits. The catalog uses the
/// same string for both, matching the precedent set by Hagga Basin
/// South.
const mysaTarillBlueprintCatalog = [
  BlueprintCatalogEntry(
    name: 'Clapper Mk4',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _palace),
    ],
  ),
];
