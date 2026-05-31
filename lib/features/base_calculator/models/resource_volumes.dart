/// Per-unit inventory **volume** (in "V") for each raw/refined resource.
///
/// SOURCE & ACCURACY
/// -----------------
/// Transcribed from the DuneCalc base calculator "Materials" tab in 2026-05
/// (see `docs/RESEARCH_BASE_CALCULATOR.md`). Used to convert a build's material
/// totals into a transport volume for trip planning. Treat as "verify in-game";
/// game patches can change item volumes.
///
/// A catalog-coverage test asserts every resource referenced by the build
/// catalog has an entry here, so trip math never silently under-counts.
const Map<String, double> baseCalculatorResourceVolumes = {
  // Basic materials
  'Salvaged Metal': 0.15,
  'Iron Ingot': 0.4,
  'Copper Ingot': 0.25,
  'Steel Ingot': 1,
  'Aluminum Ingot': 31.5,
  'Duraluminum Ingot': 133,

  // Advanced materials
  'Plastanium Ingot': 280,
  'Silicone Block': 52,
  'Cobalt Paste': 150,
  'Spice Melange': 18,
  'Plastone': 0.2,

  // Components
  'Complex Machinery': 40,
  'Advanced Machinery': 4,
  'Calibrated Servok': 0.6,
  'Advanced Servoks': 0.1,
  'Armor Plating': 11.5,
  'Plasteel Plate': 0.1,

  // Specialized components
  'Military Power Regulator': 4,
  'Industrial Pump': 2.5,
  'Thermoelectric Cooler': 3,
};

/// Per-unit volume for [resource], or `null` when unknown.
double? resourceVolume(String resource) =>
    baseCalculatorResourceVolumes[resource];
