import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../models/base_calculator_optimizer.dart';
import '../models/base_calculator_presets.dart';
import '../models/base_calculator_state.dart';
import '../models/base_calculator_summary.dart';
import '../models/generator_running_cost.dart';
import '../providers/base_calculator_provider.dart';

class BaseCalculatorOptimizationPanel extends ConsumerStatefulWidget {
  const BaseCalculatorOptimizationPanel({super.key, required this.state});

  final BaseCalculatorState state;

  @override
  ConsumerState<BaseCalculatorOptimizationPanel> createState() =>
      _BaseCalculatorOptimizationPanelState();
}

class _BaseCalculatorOptimizationPanelState
    extends ConsumerState<BaseCalculatorOptimizationPanel> {
  int _powerBuffer = 0;
  int _runningCostHours = GeneratorRunningCost.planningHoursPresets.first;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = widget.state.summary;
    final powerNeeded = BaseCalculatorOptimizer.targetPowerNeeded(
      summary: summary,
      buffer: _powerBuffer,
    );
    final fewest = BaseCalculatorOptimizer.recommendFewestGenerators(powerNeeded);
    final fuelOnly =
        BaseCalculatorOptimizer.recommendFuelGenerators(powerNeeded);
    final runningCost = GeneratorRunningCost.estimateConsumption(
      quantities: widget.state.quantities,
      hours: _runningCostHours,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(l10n.baseCalculatorOptimizationTitle),
        subtitle: Text(
          l10n.baseCalculatorOptimizationSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DuneColors.mutedText,
              ),
        ),
        children: [
          _PowerHelperSection(
            summary: summary,
            powerNeeded: powerNeeded,
            powerBuffer: _powerBuffer,
            onBufferChanged: (value) => setState(() => _powerBuffer = value),
            fewest: fewest,
            fuelOnly: fuelOnly,
          ),
          const SizedBox(height: 12),
          _RunningCostSection(
            hours: _runningCostHours,
            runningCost: runningCost,
            fuelGeneratorCount:
                GeneratorRunningCost.countFuelGenerators(widget.state.quantities),
            onHoursChanged: (value) => setState(() => _runningCostHours = value),
          ),
          const SizedBox(height: 12),
          _PresetsSection(
            isPristine: widget.state.isPristine,
            onApplyPreset: (preset) => _applyPreset(context, preset),
          ),
        ],
      ),
    );
  }

  Future<void> _applyPreset(
    BuildContext context,
    BaseCalculatorPreset preset,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.state.isPristine) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.baseCalculatorPresetConfirmTitle),
          content: Text(l10n.baseCalculatorPresetConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.baseCalculatorApplyPreset),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    ref.read(baseCalculatorProvider.notifier).applyPreset(preset);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.baseCalculatorPresetApplied(_presetLabel(l10n, preset.id)))),
    );
  }

  String _presetLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'starter_camp':
        return l10n.baseCalculatorPresetStarterCamp;
      case 'deep_desert_refinery':
        return l10n.baseCalculatorPresetDeepDesertRefinery;
      case 'crafting_hub':
        return l10n.baseCalculatorPresetCraftingHub;
      case 'guild_haul':
        return l10n.baseCalculatorPresetGuildHaul;
      default:
        return id;
    }
  }
}

class _PowerHelperSection extends ConsumerWidget {
  const _PowerHelperSection({
    required this.summary,
    required this.powerNeeded,
    required this.powerBuffer,
    required this.onBufferChanged,
    required this.fewest,
    required this.fuelOnly,
  });

  final BaseCalculatorSummary summary;
  final int powerNeeded;
  final int powerBuffer;
  final ValueChanged<int> onBufferChanged;
  final List<GeneratorRecommendation> fewest;
  final List<GeneratorRecommendation> fuelOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final deficit = BaseCalculatorOptimizer.powerDeficit(summary);
    final surplus = BaseCalculatorOptimizer.powerSurplus(summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.baseCalculatorPowerHelperTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (deficit > 0)
          Text(l10n.baseCalculatorPowerDeficitHint(deficit))
        else if (surplus > 0)
          Text(l10n.baseCalculatorPowerSurplusHint(surplus))
        else
          Text(l10n.baseCalculatorPowerBalanced),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text(l10n.baseCalculatorPowerBuffer)),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: powerBuffer > 0
                  ? () => onBufferChanged(powerBuffer - 25)
                  : null,
            ),
            Text('$powerBuffer'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: powerBuffer < 500
                  ? () => onBufferChanged(powerBuffer + 25)
                  : null,
            ),
          ],
        ),
        if (powerNeeded > 0) ...[
          Text(
            l10n.baseCalculatorPowerNeeded(powerNeeded),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DuneColors.mutedText,
                ),
          ),
          const SizedBox(height: 8),
          _RecommendationBlock(
            title: l10n.baseCalculatorRecommendFewest,
            recommendations: fewest,
          ),
          const SizedBox(height: 8),
          _RecommendationBlock(
            title: l10n.baseCalculatorRecommendFuel,
            recommendations: fuelOnly,
          ),
        ],
      ],
    );
  }
}

class _RecommendationBlock extends ConsumerWidget {
  const _RecommendationBlock({
    required this.title,
    required this.recommendations,
  });

  final String title;
  final List<GeneratorRecommendation> recommendations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        ...recommendations.map(
          (rec) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.baseCalculatorRecommendationLine(
                      rec.quantity,
                      rec.name,
                      rec.totalPower,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(baseCalculatorProvider.notifier)
                      .addRecommendations([rec]),
                  child: Text(l10n.baseCalculatorAddRecommendation),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RunningCostSection extends StatelessWidget {
  const _RunningCostSection({
    required this.hours,
    required this.runningCost,
    required this.fuelGeneratorCount,
    required this.onHoursChanged,
  });

  final int hours;
  final Map<String, int> runningCost;
  final int fuelGeneratorCount;
  final ValueChanged<int> onHoursChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.baseCalculatorRunningCostTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: hours,
          decoration: InputDecoration(labelText: l10n.baseCalculatorRunningCostPeriod),
          items: [
            DropdownMenuItem(
              value: 24,
              child: Text(l10n.baseCalculatorRunningCostPeriod1Day),
            ),
            DropdownMenuItem(
              value: 72,
              child: Text(l10n.baseCalculatorRunningCostPeriod3Day),
            ),
            DropdownMenuItem(
              value: 168,
              child: Text(l10n.baseCalculatorRunningCostPeriod7Day),
            ),
          ],
          onChanged: (value) {
            if (value != null) onHoursChanged(value);
          },
        ),
        const SizedBox(height: 8),
        if (fuelGeneratorCount == 0)
          Text(
            l10n.baseCalculatorRunningCostNoFuelGens,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DuneColors.mutedText,
                ),
          )
        else ...[
          Text(
            l10n.baseCalculatorRunningCostFuelGens(fuelGeneratorCount),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          ...runningCost.entries.map(
            (entry) => Text(l10n.baseCalculatorRunningCostFuelCells(entry.value)),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          l10n.baseCalculatorRunningCostFuelNote,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DuneColors.mutedText,
              ),
        ),
        Text(
          l10n.baseCalculatorVerifyRunningCost,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DuneColors.mutedText,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

class _PresetsSection extends StatelessWidget {
  const _PresetsSection({
    required this.isPristine,
    required this.onApplyPreset,
  });

  final bool isPristine;
  final ValueChanged<BaseCalculatorPreset> onApplyPreset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.baseCalculatorPresetsTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...baseCalculatorPresets.map((preset) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_presetTitle(l10n, preset.id)),
            subtitle: Text(_presetDescription(l10n, preset.id)),
            trailing: FilledButton.tonal(
              onPressed: () => onApplyPreset(preset),
              child: Text(l10n.baseCalculatorApplyPreset),
            ),
          );
        }),
        if (!isPristine)
          Text(
            l10n.baseCalculatorPresetReplaceHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DuneColors.mutedText,
                ),
          ),
      ],
    );
  }

  String _presetTitle(AppLocalizations l10n, String id) {
    switch (id) {
      case 'starter_camp':
        return l10n.baseCalculatorPresetStarterCamp;
      case 'deep_desert_refinery':
        return l10n.baseCalculatorPresetDeepDesertRefinery;
      case 'crafting_hub':
        return l10n.baseCalculatorPresetCraftingHub;
      case 'guild_haul':
        return l10n.baseCalculatorPresetGuildHaul;
      default:
        return id;
    }
  }

  String _presetDescription(AppLocalizations l10n, String id) {
    switch (id) {
      case 'starter_camp':
        return l10n.baseCalculatorPresetStarterCampDesc;
      case 'deep_desert_refinery':
        return l10n.baseCalculatorPresetDeepDesertRefineryDesc;
      case 'crafting_hub':
        return l10n.baseCalculatorPresetCraftingHubDesc;
      case 'guild_haul':
        return l10n.baseCalculatorPresetGuildHaulDesc;
      default:
        return '';
    }
  }
}
