/// Running-cost estimates for fueled generators in the Base Calculator.
///
/// Fuel burn is modeled per **running generator over time**, not from net
/// power or consumer load (see `docs/RESEARCH_BASE_CALCULATOR.md` audit).
///
/// Rates are community-sourced and marked verify-in-game:
/// - Fuel-Powered Generator: 1 Fuel Cell / hour / generator
///   ([Method.gg power guide](https://www.method.gg/dune-awakening/how-to-power-your-base-efficiently-in-dune-awakening),
///   [TheGamer sub-fief guide](https://www.thegamer.com/dune-awakening-sub-fief-base-power-how-to-guide/))
class GeneratorRunningCost {
  /// Fuel cells consumed per hour for each placed [fuel_powered_generator].
  static const int fuelCellsPerHourPerFuelGenerator = 1;

  static const String fuelGeneratorCode = 'fuel_powered_generator';

  /// Supported planning windows for the running-cost UI.
  static const List<int> planningHoursPresets = [24, 72, 168];

  /// Estimate fueled consumption for the selected build over [hours].
  ///
  /// Only fueled generators with known rates are included today. Wind turbines
  /// and spice generators are omitted until lubricant/spice rates are audited.
  static Map<String, int> estimateConsumption({
    required Map<String, int> quantities,
    required int hours,
  }) {
    if (hours <= 0) return const {};

    final fuelGenerators = quantities[fuelGeneratorCode] ?? 0;
    if (fuelGenerators <= 0) return const {};

    return {
      'Fuel Cells': fuelGenerators * fuelCellsPerHourPerFuelGenerator * hours,
    };
  }

  static int countFuelGenerators(Map<String, int> quantities) {
    return quantities[fuelGeneratorCode] ?? 0;
  }
}
