import '../blueprint_catalog.dart';

const _region = 'DLC / Lost Harvest';
const _lostHarvest = 'Lost Harvest questline';

/// DLC / reward schematics that are not normal regional chest drops.
///
/// Keep these separate from region catalogs so the tracker does not imply
/// that they can be farmed from ordinary schematic chests.
const dlcBlueprintCatalog = [
  BlueprintCatalogEntry(
    name: 'Steady Treadwheel Boost Module Mk4',
    category: 'Vehicle',
    sourceGroup: BlueprintSourceGroup.dlc,
    sources: [
      BlueprintSource(region: _region, location: _lostHarvest),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Swift Treadwheel Engine Mk4',
    category: 'Vehicle',
    sourceGroup: BlueprintSourceGroup.dlc,
    sources: [
      BlueprintSource(region: _region, location: _lostHarvest),
    ],
  ),
];
