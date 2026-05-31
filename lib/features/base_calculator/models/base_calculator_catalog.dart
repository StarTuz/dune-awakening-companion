import 'base_calculator_item.dart';

/// Static catalog for the Base Calculator.
///
/// SOURCE & ACCURACY
/// -----------------
/// Power deltas and resource costs were transcribed from the TCNO Dune base
/// calculator (primary — including shared configs like `s:W:1,FPG:2,MCR:1`)
/// and cross-checked against DuneCalc where available. The Medium Spice
/// Refinery (`MCR`, -350 power) reconciles with the in-game screenshot in the
/// audit (2× Fuel Generator +150 vs Windtrap -75 + MCR -350 = net -275).
///
/// Refineries and **storage buildings** (placeable containers/cisterns) were
/// added from the TCNO catalog bundle (2026-05). **Hauling** containers for
/// trip planning live separately in `storage_catalog.dart`.
///
/// Treat all values as "verify in-game" until a maintainer confirms them.
///
/// Display order for UI sections (building categories before optional hauling).
const baseCalculatorCategoryOrder = [
  BaseCalculatorCategory.utilities,
  BaseCalculatorCategory.fabricators,
  BaseCalculatorCategory.refineries,
  BaseCalculatorCategory.storage,
];
const List<BaseCalculatorItem> baseCalculatorCatalog = [
  // --- Utilities: power generators -----------------------------------------
  BaseCalculatorItem(
    code: 'fuel_powered_generator',
    name: 'Fuel-Powered Generator',
    category: BaseCalculatorCategory.utilities,
    powerDelta: 75,
    resourceCosts: {'Salvaged Metal': 45},
  ),
  BaseCalculatorItem(
    code: 'wind_turbine_omnidirectional',
    name: 'Wind Turbine (Omnidirectional)',
    category: BaseCalculatorCategory.utilities,
    powerDelta: 150,
    resourceCosts: {
      'Steel Ingot': 45,
      'Cobalt Paste': 65,
      'Calibrated Servok': 20,
    },
  ),
  BaseCalculatorItem(
    code: 'wind_turbine_directional',
    name: 'Wind Turbine (Directional)',
    category: BaseCalculatorCategory.utilities,
    powerDelta: 350,
    resourceCosts: {
      'Duraluminum Ingot': 120,
      'Cobalt Paste': 160,
      'Calibrated Servok': 50,
      'Spice Melange': 3,
    },
  ),
  BaseCalculatorItem(
    code: 'spice_powered_generator',
    name: 'Spice-Powered Generator',
    category: BaseCalculatorCategory.utilities,
    powerDelta: 1000,
    resourceCosts: {
      'Plastanium Ingot': 430,
      'Silicone Block': 180,
      'Spice Melange': 270,
      'Complex Machinery': 100,
      'Cobalt Paste': 300,
      'Advanced Machinery': 40,
    },
  ),

  // --- Utilities: power consumers ------------------------------------------
  BaseCalculatorItem(
    code: 'sub_fief_console',
    name: 'Sub-Fief Console',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -15,
    resourceCosts: {'Salvaged Metal': 25},
  ),
  BaseCalculatorItem(
    code: 'advanced_sub_fief_console',
    name: 'Advanced Sub-Fief Console',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -15,
    resourceCosts: {'Salvaged Metal': 40},
  ),
  BaseCalculatorItem(
    code: 'repair_station',
    name: 'Repair Station',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -20,
    resourceCosts: {'Iron Ingot': 40},
  ),
  BaseCalculatorItem(
    code: 'recycler',
    name: 'Recycler',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -15,
    resourceCosts: {'Copper Ingot': 30},
  ),
  BaseCalculatorItem(
    code: 'windtrap',
    name: 'Windtrap',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -75,
    resourceCosts: {
      'Steel Ingot': 90,
      'Silicone Block': 30,
      'Calibrated Servok': 20,
    },
  ),
  BaseCalculatorItem(
    code: 'large_windtrap',
    name: 'Large Windtrap',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -135,
    resourceCosts: {
      'Silicone Block': 250,
      'Calibrated Servok': 70,
      'Spice Melange': 5,
      'Duraluminum Ingot': 240,
    },
  ),
  BaseCalculatorItem(
    code: 'pentashield_surface_vertical',
    name: 'Pentashield Surface (Vertical)',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -3,
    resourceCosts: {
      'Steel Ingot': 2,
      'Cobalt Paste': 20,
      'Calibrated Servok': 6,
    },
  ),
  BaseCalculatorItem(
    code: 'pentashield_surface_horizontal',
    name: 'Pentashield Surface (Horizontal)',
    category: BaseCalculatorCategory.utilities,
    powerDelta: -3,
    resourceCosts: {
      'Steel Ingot': 2,
      'Cobalt Paste': 20,
      'Calibrated Servok': 6,
    },
  ),

  // --- Fabricators ----------------------------------------------------------
  BaseCalculatorItem(
    code: 'fabricator',
    name: 'Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -10,
    resourceCosts: {'Salvaged Metal': 75},
  ),
  BaseCalculatorItem(
    code: 'garment_fabricator',
    name: 'Garment Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -40,
    resourceCosts: {
      'Steel Ingot': 40,
      'Complex Machinery': 30,
    },
  ),
  BaseCalculatorItem(
    code: 'advanced_garment_fabricator',
    name: 'Advanced Garment Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -150,
    resourceCosts: {
      'Plastanium Ingot': 140,
      'Silicone Block': 180,
      'Complex Machinery': 100,
      'Spice Melange': 45,
    },
  ),
  BaseCalculatorItem(
    code: 'advanced_weapons_fabricator',
    name: 'Advanced Weapons Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -150,
    resourceCosts: {
      'Military Power Regulator': 40,
      'Plastanium Ingot': 140,
      'Silicone Block': 180,
      'Complex Machinery': 100,
      'Spice Melange': 45,
      'Cobalt Paste': 150,
    },
  ),
  BaseCalculatorItem(
    code: 'vehicles_fabricator',
    name: 'Vehicles Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -40,
    resourceCosts: {
      'Steel Ingot': 40,
      'Complex Machinery': 30,
    },
  ),
  BaseCalculatorItem(
    code: 'advanced_vehicle_fabricator',
    name: 'Advanced Vehicle Fabricator',
    category: BaseCalculatorCategory.fabricators,
    powerDelta: -150,
    resourceCosts: {
      'Industrial Pump': 50,
      'Plastanium Ingot': 140,
      'Silicone Block': 180,
      'Complex Machinery': 100,
      'Spice Melange': 45,
      'Cobalt Paste': 150,
    },
  ),

  // --- Refineries -----------------------------------------------------------
  BaseCalculatorItem(
    code: 'small_ore_refinery',
    name: 'Small Ore Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -15,
    resourceCosts: {'Salvaged Metal': 90},
  ),
  BaseCalculatorItem(
    code: 'medium_ore_refinery',
    name: 'Medium Ore Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -45,
    resourceCosts: {
      'Steel Ingot': 125,
      'Cobalt Paste': 60,
      'Complex Machinery': 50,
    },
  ),
  BaseCalculatorItem(
    code: 'large_ore_refinery',
    name: 'Large Ore Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -350,
    resourceCosts: {
      'Plastanium Ingot': 380,
      'Silicone Block': 540,
      'Spice Melange': 400,
      'Complex Machinery': 200,
      'Cobalt Paste': 745,
      'Advanced Machinery': 40,
    },
  ),
  BaseCalculatorItem(
    code: 'small_chemical_refinery',
    name: 'Small Chemical Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -15,
    resourceCosts: {'Copper Ingot': 45},
  ),
  BaseCalculatorItem(
    code: 'medium_chemical_refinery',
    name: 'Medium Chemical Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -350,
    resourceCosts: {
      'Duraluminum Ingot': 150,
      'Silicone Block': 90,
      'Complex Machinery': 50,
      'Spice Melange': 35,
    },
  ),
  BaseCalculatorItem(
    code: 'spice_refinery',
    name: 'Spice Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -200,
    resourceCosts: {
      'Duraluminum Ingot': 160,
      'Silicone Block': 130,
      'Cobalt Paste': 80,
      'Complex Machinery': 70,
    },
  ),
  BaseCalculatorItem(
    code: 'medium_spice_refinery',
    name: 'Medium Spice Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -350,
    resourceCosts: {
      'Plastanium Ingot': 285,
      'Silicone Block': 225,
      'Spice Melange': 135,
      'Complex Machinery': 100,
      'Cobalt Paste': 190,
    },
  ),
  BaseCalculatorItem(
    code: 'large_spice_refinery',
    name: 'Large Spice Refinery',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -500,
    resourceCosts: {
      'Plastanium Ingot': 950,
      'Silicone Block': 1080,
      'Spice Melange': 1000,
      'Complex Machinery': 350,
      'Cobalt Paste': 1110,
      'Advanced Machinery': 55,
    },
  ),
  BaseCalculatorItem(
    code: 'fremen_deathstill',
    name: 'Fremen Deathstill',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -200,
    resourceCosts: {
      'Steel Ingot': 60,
      'Silicone Block': 28,
      'Complex Machinery': 32,
    },
  ),
  BaseCalculatorItem(
    code: 'advanced_fremen_deathstill',
    name: 'Advanced Fremen Deathstill',
    category: BaseCalculatorCategory.refineries,
    powerDelta: -350,
    resourceCosts: {
      'Duraluminum Ingot': 240,
      'Silicone Block': 170,
      'Complex Machinery': 70,
    },
  ),

  // --- Storage buildings (placeable containers) -----------------------------
  BaseCalculatorItem(
    code: 'small_storage_container',
    name: 'Small Storage Container',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {'Salvaged Metal': 35},
  ),
  BaseCalculatorItem(
    code: 'chest',
    name: 'Chest',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {'Iron Ingot': 20},
  ),
  BaseCalculatorItem(
    code: 'storage_container',
    name: 'Storage Container',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {
      'Aluminum Ingot': 45,
      'Silicone Block': 8,
    },
  ),
  BaseCalculatorItem(
    code: 'medium_storage_container',
    name: 'Medium Storage Container',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {
      'Plastanium Ingot': 70,
      'Silicone Block': 14,
      'Spice Melange': 4,
    },
  ),
  BaseCalculatorItem(
    code: 'water_cistern',
    name: 'Water Cistern',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {'Copper Ingot': 25},
  ),
  BaseCalculatorItem(
    code: 'medium_water_cistern',
    name: 'Medium Water Cistern',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {
      'Steel Ingot': 60,
      'Silicone Block': 30,
    },
  ),
  BaseCalculatorItem(
    code: 'large_water_cistern',
    name: 'Large Water Cistern',
    category: BaseCalculatorCategory.storage,
    powerDelta: 0,
    resourceCosts: {
      'Duraluminum Ingot': 150,
      'Silicone Block': 160,
      'Industrial Pump': 25,
    },
  ),
];

/// Catalog indexed by item code for O(1) lookups from selection state.
final Map<String, BaseCalculatorItem> baseCalculatorCatalogByCode = {
  for (final item in baseCalculatorCatalog) item.code: item,
};
