/// Built-in calculator templates for common build scenarios (Phase 5).
class BaseCalculatorPreset {
  final String id;
  final String name;
  final String description;
  final bool deepDesertDiscount;
  final Map<String, int> itemQuantities;
  final Map<String, int> storageQuantities;

  const BaseCalculatorPreset({
    required this.id,
    required this.name,
    required this.description,
    this.deepDesertDiscount = false,
    this.itemQuantities = const {},
    this.storageQuantities = const {},
  });
}

/// Static presets. Names/descriptions are localized via [id] lookup in the UI.
const List<BaseCalculatorPreset> baseCalculatorPresets = [
  BaseCalculatorPreset(
    id: 'starter_camp',
    name: 'Starter camp',
    description: 'Console, basic power, repair, and starter storage.',
    itemQuantities: {
      'sub_fief_console': 1,
      'fuel_powered_generator': 2,
      'repair_station': 1,
      'small_storage_container': 2,
    },
  ),
  BaseCalculatorPreset(
    id: 'deep_desert_refinery',
    name: 'Deep Desert refinery',
    description:
        'TCNO-audited sample: 2× fuel gen, windtrap, medium spice refinery.',
    deepDesertDiscount: true,
    itemQuantities: {
      'fuel_powered_generator': 2,
      'windtrap': 1,
      'medium_spice_refinery': 1,
    },
    storageQuantities: {
      'player_inventory': 1,
      'buggy_storage_mk4': 1,
    },
  ),
  BaseCalculatorPreset(
    id: 'crafting_hub',
    name: 'Crafting hub',
    description: 'Fabricators with wind power and backup fuel generation.',
    itemQuantities: {
      'sub_fief_console': 1,
      'wind_turbine_omnidirectional': 2,
      'fuel_powered_generator': 2,
      'fabricator': 1,
      'survival_fabricator': 1,
      'garment_fabricator': 1,
      'recycler': 1,
      'storage_container': 2,
    },
  ),
  BaseCalculatorPreset(
    id: 'guild_haul',
    name: 'Guild haul',
    description: 'Ore + chemical refining with hauling containers configured.',
    itemQuantities: {
      'sub_fief_console': 1,
      'fuel_powered_generator': 4,
      'medium_ore_refinery': 1,
      'medium_chemical_refinery': 1,
      'repair_station': 1,
      'medium_storage_container': 2,
    },
    storageQuantities: {
      'player_inventory': 1,
      'assault_ornithopter_storage_mk5': 1,
      'buggy_storage_mk4': 1,
    },
  ),
];

final Map<String, BaseCalculatorPreset> baseCalculatorPresetsById = {
  for (final preset in baseCalculatorPresets) preset.id: preset,
};
