/// Categories used to group items in the Base Calculator catalog.
///
/// The category labels are localized at the UI layer (see
/// `BaseCalculatorCategoryX.label`); the enum itself is a stable data key.
enum BaseCalculatorCategory {
  utilities,
  fabricators,
  refineries,
  storage,
}

/// A single placeable item in the Base Calculator catalog.
///
/// `powerDelta` is positive for generators (produces power) and negative for
/// consumers (fabricators, windtraps, refineries, etc.). `resourceCosts` maps a
/// raw in-game resource name to the quantity required for one unit.
///
/// Item and resource names are intentionally kept as raw English game terms
/// (proper nouns), mirroring the blueprint catalog, rather than localized
/// strings — only UI chrome is localized.
class BaseCalculatorItem {
  /// Stable internal code (snake_case). Distinct from any third-party tool's
  /// codes; used for selection keys and tests.
  final String code;

  /// Display name (raw game term).
  final String name;

  final BaseCalculatorCategory category;

  /// Power change per unit: positive generates power, negative consumes it.
  final int powerDelta;

  /// Raw resource name -> quantity required for one unit.
  final Map<String, int> resourceCosts;

  const BaseCalculatorItem({
    required this.code,
    required this.name,
    required this.category,
    required this.powerDelta,
    required this.resourceCosts,
  });

  /// True when this item produces power (a generator).
  bool get isGenerator => powerDelta > 0;

  /// True when this item consumes power.
  bool get isConsumer => powerDelta < 0;

  /// True for storage buildings that do not draw base power.
  bool get isPassive => powerDelta == 0;
}
