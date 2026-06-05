import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../models/base_calculator_plan.dart';
import '../models/base_calculator_state.dart';
import '../services/base_calculator_plan_repository.dart';
import 'base_calculator_provider.dart';

final baseCalculatorPlanRepositoryProvider =
    Provider<BaseCalculatorPlanRepository>((ref) {
  return BaseCalculatorPlanRepository(AppDatabase.instance);
});

final baseCalculatorPlansProvider =
    FutureProvider<List<BaseCalculatorPlan>>((ref) async {
  final repository = ref.watch(baseCalculatorPlanRepositoryProvider);
  return repository.getAll();
});

final baseCalculatorPlanEditorProvider = Provider((ref) {
  return BaseCalculatorPlanEditor(
    ref.watch(baseCalculatorPlanRepositoryProvider),
    ref,
  );
});

class BaseCalculatorPlanEditor {
  final BaseCalculatorPlanRepository _repository;
  final Ref _ref;

  BaseCalculatorPlanEditor(this._repository, this._ref);

  void _invalidatePlans() {
    _ref.invalidate(baseCalculatorPlansProvider);
  }

  Future<BaseCalculatorPlan> saveNew({
    required String name,
    required BaseCalculatorState state,
    String? characterId,
    String? baseId,
  }) async {
    final plan = BaseCalculatorPlan.fromState(
      id: const Uuid().v4(),
      name: name.trim(),
      state: state,
      characterId: characterId,
      baseId: baseId,
    );
    await _repository.upsert(plan);
    _invalidatePlans();
    _ref.read(baseCalculatorProvider.notifier).markActivePlan(plan);
    return plan;
  }

  Future<BaseCalculatorPlan> updateExisting({
    required String planId,
    required String name,
    required BaseCalculatorState state,
    String? characterId,
    String? baseId,
  }) async {
    final existing = await _repository.getById(planId);
    final now = DateTime.now();
    final plan = BaseCalculatorPlan.fromState(
      id: planId,
      name: name.trim(),
      state: state,
      characterId: characterId,
      baseId: baseId,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await _repository.upsert(plan);
    _invalidatePlans();
    _ref.read(baseCalculatorProvider.notifier).markActivePlan(plan);
    return plan;
  }

  Future<BaseCalculatorPlan> duplicate(
    BaseCalculatorPlan source, {
    required String copyName,
  }) async {
    final copy = source.copyWith(
      id: const Uuid().v4(),
      name: copyName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _repository.upsert(copy);
    _invalidatePlans();
    return copy;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    _invalidatePlans();
    final activeId = _ref.read(baseCalculatorProvider).activePlanId;
    if (activeId == id) {
      _ref.read(baseCalculatorProvider.notifier).reset();
    }
  }

  void loadIntoCalculator(BaseCalculatorPlan plan) {
    _ref.read(baseCalculatorProvider.notifier).loadPlan(plan);
  }
}
