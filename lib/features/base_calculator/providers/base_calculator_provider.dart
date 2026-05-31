import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_calculator_summary.dart';
import '../models/storage_summary.dart';

/// In-memory state for the Base Calculator (no persistence yet — that is
/// Phase 3).
///
/// Holds the per-item build quantities, the per-container storage quantities
/// (`code -> quantity`), and whether the Deep Desert 50% material discount is
/// enabled.
class BaseCalculatorState {
  final Map<String, int> quantities;
  final Map<String, int> storageQuantities;
  final bool deepDesertDiscount;

  const BaseCalculatorState({
    this.quantities = const {},
    this.storageQuantities = const {},
    this.deepDesertDiscount = false,
  });

  BaseCalculatorState copyWith({
    Map<String, int>? quantities,
    Map<String, int>? storageQuantities,
    bool? deepDesertDiscount,
  }) {
    return BaseCalculatorState(
      quantities: quantities ?? this.quantities,
      storageQuantities: storageQuantities ?? this.storageQuantities,
      deepDesertDiscount: deepDesertDiscount ?? this.deepDesertDiscount,
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
}

class BaseCalculatorNotifier extends StateNotifier<BaseCalculatorState> {
  BaseCalculatorNotifier() : super(const BaseCalculatorState());

  int quantityFor(String code) => state.quantities[code] ?? 0;

  void setQuantity(String code, int quantity) {
    final next = Map<String, int>.from(state.quantities);
    if (quantity <= 0) {
      next.remove(code);
    } else {
      next[code] = quantity;
    }
    state = state.copyWith(quantities: next);
  }

  void increment(String code) => setQuantity(code, quantityFor(code) + 1);

  void decrement(String code) => setQuantity(code, quantityFor(code) - 1);

  int storageQuantityFor(String code) => state.storageQuantities[code] ?? 0;

  void setStorageQuantity(String code, int quantity) {
    final next = Map<String, int>.from(state.storageQuantities);
    if (quantity <= 0) {
      next.remove(code);
    } else {
      next[code] = quantity;
    }
    state = state.copyWith(storageQuantities: next);
  }

  void incrementStorage(String code) =>
      setStorageQuantity(code, storageQuantityFor(code) + 1);

  void decrementStorage(String code) =>
      setStorageQuantity(code, storageQuantityFor(code) - 1);

  void setDeepDesertDiscount(bool value) {
    state = state.copyWith(deepDesertDiscount: value);
  }

  void reset() {
    state = const BaseCalculatorState();
  }
}

final baseCalculatorProvider =
    StateNotifierProvider<BaseCalculatorNotifier, BaseCalculatorState>(
  (ref) => BaseCalculatorNotifier(),
);
