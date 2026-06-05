import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../bases/providers/base_provider.dart';
import '../../characters/providers/character_provider.dart';
import '../models/base_calculator_plan.dart';
import '../providers/base_calculator_plan_provider.dart';
import '../providers/base_calculator_provider.dart';
import 'base_calculator_save_plan_dialog.dart';

Future<void> showBaseCalculatorPlansSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _PlansSheet(),
  );
}

class _PlansSheet extends ConsumerWidget {
  const _PlansSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final plansAsync = ref.watch(baseCalculatorPlansProvider);
    final calculatorState = ref.watch(baseCalculatorProvider);

    final maxHeight = MediaQuery.sizeOf(context).height * 0.55;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.baseCalculatorSavedPlans,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: calculatorState.isPristine
                      ? null
                      : () async {
                          await showBaseCalculatorSavePlanDialog(
                            context: context,
                            ref: ref,
                            state: calculatorState,
                            existingPlanId: calculatorState.activePlanId,
                            initialName: calculatorState.activePlanName,
                          );
                        },
                  icon: const Icon(Icons.save_outlined),
                  label: Text(l10n.baseCalculatorSavePlan),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: maxHeight,
              child: plansAsync.when(
                data: (plans) {
                  if (plans.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        l10n.baseCalculatorNoSavedPlans,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: DuneColors.mutedText),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _PlanTile(plan: plans[index]);
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(error.toString()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends ConsumerWidget {
  const _PlanTile({required this.plan});

  final BaseCalculatorPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);
    final activePlanId = ref.watch(baseCalculatorProvider).activePlanId;
    final dateFormat = DateFormat.yMMMd().add_jm();
    final isActive = activePlanId == plan.id;

    final characterName = charactersAsync.maybeWhen(
      data: (characters) {
        if (plan.characterId == null) return null;
        return characters
            .where((c) => c.id == plan.characterId)
            .map((c) => c.name)
            .firstOrNull;
      },
      orElse: () => null,
    );

    final baseName = basesAsync.maybeWhen(
      data: (bases) {
        if (plan.baseId == null) return null;
        return bases.where((b) => b.id == plan.baseId).map((b) => b.name).firstOrNull;
      },
      orElse: () => null,
    );

    final subtitleParts = <String>[
      l10n.baseCalculatorPlanItemCount(plan.totalItems),
      if (plan.deepDesertDiscountEnabled) l10n.baseCalculatorDeepDesertToggle,
      if (characterName != null) characterName,
      if (baseName != null) baseName,
      dateFormat.format(plan.updatedAt),
    ];

    return ListTile(
      leading: Icon(
        isActive ? Icons.bookmark : Icons.bookmark_outline,
        color: isActive ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        plan.name.isEmpty ? l10n.baseCalculatorUnnamedPlan : plan.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitleParts.join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        ref.read(baseCalculatorPlanEditorProvider).loadIntoCalculator(plan);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.baseCalculatorPlanLoaded(plan.name))),
        );
      },
      trailing: PopupMenuButton<_PlanAction>(
        onSelected: (action) => _handleAction(context, ref, action),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _PlanAction.load,
            child: Text(l10n.baseCalculatorLoadPlan),
          ),
          PopupMenuItem(
            value: _PlanAction.duplicate,
            child: Text(l10n.baseCalculatorDuplicatePlan),
          ),
          PopupMenuItem(
            value: _PlanAction.delete,
            child: Text(l10n.baseCalculatorDeletePlan),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _PlanAction action,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final editor = ref.read(baseCalculatorPlanEditorProvider);

    switch (action) {
      case _PlanAction.load:
        editor.loadIntoCalculator(plan);
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.baseCalculatorPlanLoaded(plan.name))),
          );
        }
      case _PlanAction.duplicate:
        await editor.duplicate(
          plan,
          copyName: l10n.baseCalculatorPlanCopyName(plan.name),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.baseCalculatorPlanDuplicated)),
          );
        }
      case _PlanAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.baseCalculatorPlanDeleteConfirmTitle),
            content: Text(l10n.baseCalculatorPlanDeleteConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await editor.delete(plan.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.baseCalculatorPlanDeleted)),
            );
          }
        }
    }
  }
}

enum _PlanAction { load, duplicate, delete }
