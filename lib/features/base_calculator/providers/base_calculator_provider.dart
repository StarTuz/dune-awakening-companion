import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_calculator_summary.dart';

/// In-memory state for the Base Calculator (Phase 1 — no persistence yet).
///
/// Holds the per-item quantities (`code -> quantity`) and whether the Deep
/// Desert 50% material discount is enabled.
class BaseCalculatorState {
  final Map<String, int> quantities;
  final bool deepDesertDiscount;

  const BaseCalculatorState({
    this.quantities = const {},
    this.deepDesertDiscount = false,
  });

  BaseCalculatorState copyWith({
    Map<String, int>? quantities,
    bool? deepDesertDiscount,
  }) {
    return BaseCalculatorState(
      quantities: quantities ?? this.quantities,
      deepDesertDiscount: deepDesertDiscount ?? this.deepDesertDiscount,
    );
  }

  /// Total number of placed items (sum of all quantities).
  int get totalItems =>
      quantities.values.fold(0, (sum, qty) => sum + (qty > 0 ? qty : 0));

  /// Computed power/resource summary for the current selection.
  BaseCalculatorSummary get summary => BaseCalculatorSummary.fromQuantities(
        quantities,
        deepDesertDiscount: deepDesertDiscount,
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
