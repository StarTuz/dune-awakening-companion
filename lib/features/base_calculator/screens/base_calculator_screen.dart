import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../models/base_calculator_catalog.dart';
import '../models/base_calculator_item.dart';
import '../models/base_calculator_summary.dart';
import '../providers/base_calculator_provider.dart';

/// Phase 1 Base Calculator: pick placeable items and see live power netting and
/// material totals, with an optional Deep Desert 50% material discount.
class BaseCalculatorScreen extends ConsumerWidget {
  const BaseCalculatorScreen({super.key});

  String _categoryLabel(AppLocalizations l10n, BaseCalculatorCategory c) {
    switch (c) {
      case BaseCalculatorCategory.utilities:
        return l10n.baseCalculatorCategoryUtilities;
      case BaseCalculatorCategory.fabricators:
        return l10n.baseCalculatorCategoryFabricators;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(baseCalculatorProvider);
    final summary = state.summary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.baseCalculatorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: l10n.baseCalculatorResetAll,
            onPressed: state.totalItems == 0 && !state.deepDesertDiscount
                ? null
                : () => ref.read(baseCalculatorProvider.notifier).reset(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final controls = _ControlsAndSummary(summary: summary, state: state);
          final catalog = _CatalogList(categoryLabel: _categoryLabel);

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: catalog),
                const VerticalDivider(width: 1, thickness: 1),
                SizedBox(
                  width: 360,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: controls,
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: controls,
              ),
              const Divider(height: 1),
              Expanded(child: catalog),
            ],
          );
        },
      ),
    );
  }
}

class _ControlsAndSummary extends ConsumerWidget {
  const _ControlsAndSummary({required this.summary, required this.state});

  final BaseCalculatorSummary summary;
  final BaseCalculatorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: SwitchListTile(
            value: state.deepDesertDiscount,
            onChanged: (v) => ref
                .read(baseCalculatorProvider.notifier)
                .setDeepDesertDiscount(v),
            title: Text(l10n.baseCalculatorDeepDesertToggle),
            subtitle: Text(l10n.baseCalculatorDeepDesertSubtitle),
            secondary: const Icon(Icons.wb_sunny_outlined),
          ),
        ),
        const SizedBox(height: 12),
        _SummaryCard(summary: summary),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final BaseCalculatorSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.baseCalculatorSummaryTitle,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (summary.isEmpty)
              Text(
                l10n.baseCalculatorEmpty,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: DuneColors.mutedText),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _PowerStat(
                      label: l10n.baseCalculatorGenerated,
                      value: '+${summary.generatedPower}',
                      color: DuneColors.success,
                    ),
                  ),
                  Expanded(
                    child: _PowerStat(
                      label: l10n.baseCalculatorUsed,
                      value: '-${summary.usedPower}',
                      color: DuneColors.warningPrimary,
                    ),
                  ),
                  Expanded(
                    child: _PowerStat(
                      label: l10n.baseCalculatorNetPower,
                      value: summary.netPower >= 0
                          ? '+${summary.netPower}'
                          : '${summary.netPower}',
                      color: summary.hasPowerDeficit
                          ? DuneColors.criticalPrimary
                          : DuneColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _PowerStatusBanner(summary: summary),
              const SizedBox(height: 16),
              Text(
                l10n.baseCalculatorMaterialsTitle,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...summary.resourceTotals.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(e.key)),
                      Text(
                        '${e.value}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.baseCalculatorVerifyInGame,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DuneColors.mutedText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PowerStat extends StatelessWidget {
  const _PowerStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style:
              theme.textTheme.bodySmall?.copyWith(color: DuneColors.mutedText),
        ),
      ],
    );
  }
}

class _PowerStatusBanner extends StatelessWidget {
  const _PowerStatusBanner({required this.summary});

  final BaseCalculatorSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (color, icon, text) = summary.hasPowerDeficit
        ? (
            DuneColors.criticalPrimary,
            Icons.warning_amber_rounded,
            l10n.baseCalculatorPowerDeficit(-summary.netPower),
          )
        : summary.netPower == 0
            ? (
                DuneColors.info,
                Icons.check_circle_outline,
                l10n.baseCalculatorPowerBalanced,
              )
            : (
                DuneColors.success,
                Icons.check_circle_outline,
                l10n.baseCalculatorPowerSurplus(summary.netPower),
              );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogList extends ConsumerWidget {
  const _CatalogList({required this.categoryLabel});

  final String Function(AppLocalizations, BaseCalculatorCategory) categoryLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final byCategory = <BaseCalculatorCategory, List<BaseCalculatorItem>>{};
    for (final item in baseCalculatorCatalog) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final category in byCategory.keys) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Text(
              categoryLabel(l10n, category),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (final item in byCategory[category]!) _ItemRow(item: item),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ItemRow extends ConsumerWidget {
  const _ItemRow({required this.item});

  final BaseCalculatorItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(baseCalculatorProvider.notifier);
    final quantity = ref.watch(
      baseCalculatorProvider.select((s) => s.quantities[item.code] ?? 0),
    );
    final powerColor =
        item.isGenerator ? DuneColors.success : DuneColors.warningPrimary;
    final powerText =
        item.powerDelta >= 0 ? '+${item.powerDelta}' : '${item.powerDelta}';

    return ListTile(
      title: Text(item.name),
      subtitle: Row(
        children: [
          Icon(Icons.bolt, size: 14, color: powerColor),
          Text(
            powerText,
            style: TextStyle(color: powerColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed:
                quantity == 0 ? null : () => notifier.decrement(item.code),
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => notifier.increment(item.code),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
