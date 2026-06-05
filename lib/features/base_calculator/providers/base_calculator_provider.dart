import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_calculator_plan.dart';
import '../models/base_calculator_state.dart';

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

  void loadPlan(BaseCalculatorPlan plan) {
    state = plan.toCalculatorState();
  }

  void loadState(BaseCalculatorState next) {
    state = next;
  }

  void markActivePlan(BaseCalculatorPlan plan) {
    state = state.copyWith(
      activePlanId: plan.id,
      activePlanName: plan.name,
    );
  }

  void reset() {
    state = const BaseCalculatorState();
  }
}

final baseCalculatorProvider =
    StateNotifierProvider<BaseCalculatorNotifier, BaseCalculatorState>(
  (ref) => BaseCalculatorNotifier(),
);
