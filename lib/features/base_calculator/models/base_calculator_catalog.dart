import 'base_calculator_item.dart';

/// Static catalog for the Base Calculator (Phase 1).
///
/// SOURCE & ACCURACY
/// -----------------
/// Power deltas and resource costs were transcribed from public Dune Awakening
/// base-cost tools (DuneCalc base calculator and the TCNO planner) and
/// cross-checked against an in-game build screenshot in 2026-05. The shared
/// TCNO config `s:W:1,FPG:2,MCR:1` reconciles with these numbers
/// (2x Fuel Generator +150 vs Windtrap -75 + a -350 refinery = net -275),
/// which is why Utilities power values are treated as validated.
///
/// Only the **Utilities** (power) and **Fabricators** categories are included in
/// Phase 1 because their costs were fully captured. Refineries, Storage,
/// Buildings, and Vehicles are deferred until their per-item costs are verified
/// in-game (see `docs/RESEARCH_BASE_CALCULATOR.md`, Audit Findings).
///
/// Treat all values as "verify in-game" until a maintainer confirms them; game
/// patches can change build costs and power values.
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
];

/// Catalog indexed by item code for O(1) lookups from selection state.
final Map<String, BaseCalculatorItem> baseCalculatorCatalogByCode = {
  for (final item in baseCalculatorCatalog) item.code: item,
};
