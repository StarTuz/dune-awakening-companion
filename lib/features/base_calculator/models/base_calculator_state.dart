import 'base_calculator_summary.dart';
import 'storage_summary.dart';

/// In-memory state for the Base Calculator.
///
/// Holds the per-item build quantities, the per-container storage quantities
/// (`code -> quantity`), whether the Deep Desert 50% material discount is
/// enabled, and optional metadata for the currently loaded saved plan.
class BaseCalculatorState {
  final Map<String, int> quantities;
  final Map<String, int> storageQuantities;
  final bool deepDesertDiscount;
  final String? activePlanId;
  final String? activePlanName;

  const BaseCalculatorState({
    this.quantities = const {},
    this.storageQuantities = const {},
    this.deepDesertDiscount = false,
    this.activePlanId,
    this.activePlanName,
  });

  BaseCalculatorState copyWith({
    Map<String, int>? quantities,
    Map<String, int>? storageQuantities,
    bool? deepDesertDiscount,
    Object? activePlanId = _unset,
    Object? activePlanName = _unset,
  }) {
    return BaseCalculatorState(
      quantities: quantities ?? this.quantities,
      storageQuantities: storageQuantities ?? this.storageQuantities,
      deepDesertDiscount: deepDesertDiscount ?? this.deepDesertDiscount,
      activePlanId: identical(activePlanId, _unset)
          ? this.activePlanId
          : activePlanId as String?,
      activePlanName: identical(activePlanName, _unset)
          ? this.activePlanName
          : activePlanName as String?,
    );
  }

  /// Total number of placed items (sum of all quantities).
  int get totalItems =>
      quantities.values.fold(0, (sum, qty) => sum + (qty > 0 ? qty : 0));

  /// Total number of configured storage containers.
  int get totalStorage =>
      storageQuantities.values.fold(0, (sum, qty) => sum + (qty > 0 ? qty : 0));

  /// True when nothing at all has been selected or toggled.
  bool get isPristine =>
      totalItems == 0 && totalStorage == 0 && !deepDesertDiscount;

  /// Computed power/resource/volume summary for the current build selection.
  BaseCalculatorSummary get summary => BaseCalculatorSummary.fromQuantities(
        quantities,
        deepDesertDiscount: deepDesertDiscount,
      );

  /// Computed capacity for the current storage selection.
  StorageSummary get storageSummary =>
      StorageSummary.fromQuantities(storageQuantities);

  /// Estimated trips to haul the build's materials with the configured
  /// storage. `null` when no storage is configured.
  int? get trips => tripsNeeded(
        materialVolume: summary.totalVolume,
        storageCapacity: storageSummary.totalVolumeCapacity,
      );

  static const Object _unset = Object();
}
