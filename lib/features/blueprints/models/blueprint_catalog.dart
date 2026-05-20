import 'package:uuid/uuid.dart';

import 'blueprint.dart';

class BlueprintCatalogEntry {
  final String name;
  final String category;
  final String location;

  const BlueprintCatalogEntry({
    required this.name,
    required this.category,
    required this.location,
  });

  Blueprint toBlueprint(String characterId) {
    final now = DateTime.now();
    return Blueprint(
      id: const Uuid().v4(),
      characterId: characterId,
      name: name,
      category: category,
      region: Blueprint.defaultRegion,
      sourceType: 'Chest',
      sourceLocation: location,
      notes:
          'Seeded from IGN Hagga Basin South unique schematics guide; verify in-game before treating as confirmed.',
      createdAt: now,
      updatedAt: now,
    );
  }
}

// Seed list from IGN's Hagga Basin South unique schematic checklist:
// https://www.ign.com/wikis/dune-awakening/All_Hagga_Basin_South_Unique_Schematics_and_Locations
const haggaBasinSouthBlueprintCatalog = [
  BlueprintCatalogEntry(
    name: "Kaleff's Drinker",
    category: 'Weapon',
    location: 'Hagga Basin South, Wreck of the Alcyon',
  ),
  BlueprintCatalogEntry(
    name: 'Old Sparky Mk1',
    category: 'Weapon',
    location: 'Hagga Basin South, Key Hole Rock',
  ),
  BlueprintCatalogEntry(
    name: 'Mohandis Sandbike Engine Mk1',
    category: 'Vehicle',
    location: 'Hagga Basin South, Key Hole Rock',
  ),
  BlueprintCatalogEntry(
    name: "Sim's Cutter",
    category: 'Tool',
    location: 'Hagga Basin South, Key Hole Rock',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Mask",
    category: 'Armor',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Chestpiece",
    category: 'Armor',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Boots",
    category: 'Armor',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Gloves",
    category: 'Armor',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Pants",
    category: 'Armor',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "Aren's Vengeance",
    category: 'Weapon',
    location: 'Hagga Basin South, Broken Stone Station',
  ),
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk1',
    category: 'Utility',
    location: 'Hagga Basin South',
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk1",
    category: 'Vehicle',
    location: 'Hagga Basin South, Imperial Testing Station No. 2',
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Fallen',
    category: 'Weapon',
    location: 'Hagga Basin South, Old Griffin Hideaway',
  ),
  BlueprintCatalogEntry(
    name: 'Hollower Stillsuit Mask',
    category: 'Armor',
    location: 'Hagga Basin South, Dewgap Gateway',
  ),
  BlueprintCatalogEntry(
    name: 'Hollower Stillsuit Garment',
    category: 'Armor',
    location: 'Hagga Basin South, Dewgap Gateway',
  ),
  BlueprintCatalogEntry(
    name: 'Hollower Stillsuit Gloves',
    category: 'Armor',
    location: 'Hagga Basin South, Dewgap Gateway',
  ),
  BlueprintCatalogEntry(
    name: 'Hollower Stillsuit Boots',
    category: 'Armor',
    location: 'Hagga Basin South, Dewgap Gateway',
  ),
];
