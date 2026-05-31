import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../models/base_calculator_catalog.dart';
import '../models/base_calculator_item.dart';
import '../models/base_calculator_summary.dart';
import '../models/storage_catalog.dart';
import '../models/storage_option.dart';
import '../providers/base_calculator_provider.dart';

String _formatVolume(double v) {
  final rounded = v.roundToDouble();
  final text = (v == rounded) ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  return '${text}V';
}

/// Base Calculator: pick placeable items and storage, and see live power
/// netting, material totals, transport volume, and estimated hauling trips.
/// An optional Deep Desert 50% material discount applies to materials only.
class BaseCalculatorScreen extends ConsumerStatefulWidget {
  const BaseCalculatorScreen({super.key});

  @override
  ConsumerState<BaseCalculatorScreen> createState() =>
      _BaseCalculatorScreenState();
}

class _BaseCalculatorScreenState extends ConsumerState<BaseCalculatorScreen> {
  bool _showVolumes = false;

  String _categoryLabel(AppLocalizations l10n, BaseCalculatorCategory c) {
    switch (c) {
      case BaseCalculatorCategory.utilities:
        return l10n.baseCalculatorCategoryUtilities;
      case BaseCalculatorCategory.fabricators:
        return l10n.baseCalculatorCategoryFabricators;
      case BaseCalculatorCategory.refineries:
        return l10n.baseCalculatorCategoryRefineries;
      case BaseCalculatorCategory.storage:
        return l10n.baseCalculatorCategoryStorage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(baseCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.baseCalculatorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: l10n.baseCalculatorResetAll,
            onPressed: state.isPristine
                ? null
                : () => ref.read(baseCalculatorProvider.notifier).reset(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final controls = _ControlsAndSummary(
            state: state,
            showVolumes: _showVolumes,
            onShowVolumesChanged: (v) => setState(() => _showVolumes = v),
          );
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
  const _ControlsAndSummary({
    required this.state,
    required this.showVolumes,
    required this.onShowVolumesChanged,
  });

  final BaseCalculatorState state;
  final bool showVolumes;
  final ValueChanged<bool> onShowVolumesChanged;

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
        _SummaryCard(
          state: state,
          showVolumes: showVolumes,
          onShowVolumesChanged: onShowVolumesChanged,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.state,
    required this.showVolumes,
    required this.onShowVolumesChanged,
  });

  final BaseCalculatorState state;
  final bool showVolumes;
  final ValueChanged<bool> onShowVolumesChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final summary = state.summary;
    final resourceVolumes = summary.resourceVolumes;

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.baseCalculatorMaterialsTitle,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      l10n.baseCalculatorShowVolumes,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: DuneColors.mutedText),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Switch(
                    value: showVolumes,
                    onChanged: onShowVolumesChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...summary.resourceTotals.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key),
                            if (showVolumes && resourceVolumes[e.key] != null)
                              Text(
                                _formatVolume(resourceVolumes[e.key]!),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: DuneColors.mutedText),
                              ),
                          ],
                        ),
                      ),
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
              const SizedBox(height: 8),
              _HaulingSummaryTile(state: state),
            ],
          ],
        ),
      ),
    );
  }
}

/// Collapsed-by-default trip summary — secondary to power and materials.
class _HaulingSummaryTile extends StatelessWidget {
  const _HaulingSummaryTile({required this.state});

  final BaseCalculatorState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final trips = state.trips;
    final hasHauling = state.totalStorage > 0;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(l10n.baseCalculatorStorageTitle),
        subtitle: Text(
          hasHauling && trips != null
              ? '${l10n.baseCalculatorTripsNeeded}: $trips'
              : l10n.baseCalculatorHaulingOptional,
          style:
              theme.textTheme.bodySmall?.copyWith(color: DuneColors.mutedText),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _TransportSection(state: state),
          ),
        ],
      ),
    );
  }
}

class _TransportSection extends StatelessWidget {
  const _TransportSection({required this.state});

  final BaseCalculatorState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final summary = state.summary;
    final storage = state.storageSummary;
    final trips = state.trips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryRow(
          label: l10n.baseCalculatorTotalVolume,
          value: _formatVolume(summary.totalVolume),
        ),
        _SummaryRow(
          label: l10n.baseCalculatorStorageCapacity,
          value: '${storage.totalVolumeCapacity}V',
        ),
        if (trips == null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.baseCalculatorConfigureStorage,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: DuneColors.mutedText),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.baseCalculatorTripsNeeded,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  '$trips',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: DuneColors.primaryAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
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
    final theme = Theme.of(context);

    final byCategory = <BaseCalculatorCategory, List<BaseCalculatorItem>>{};
    for (final item in baseCalculatorCatalog) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }

    Widget sectionHeader(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
          child: Text(
            text,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final category in baseCalculatorCategoryOrder)
          if ((byCategory[category] ?? []).isNotEmpty) ...[
            sectionHeader(categoryLabel(l10n, category)),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final item in byCategory[category]!)
                    _ItemRow(item: item),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Text(l10n.baseCalculatorStorageTitle),
            subtitle: Text(
              l10n.baseCalculatorHaulingOptional,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: DuneColors.mutedText),
            ),
            children: [
              for (final option in baseCalculatorStorageOptions)
                _StorageRow(option: option),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ItemRow extends ConsumerWidget {
  const _ItemRow({required this.item});

  final BaseCalculatorItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(baseCalculatorProvider.notifier);
    final quantity = ref.watch(
      baseCalculatorProvider.select((s) => s.quantities[item.code] ?? 0),
    );
    final powerColor = item.isPassive
        ? DuneColors.mutedText
        : item.isGenerator
            ? DuneColors.success
            : DuneColors.warningPrimary;
    final powerText = item.isPassive
        ? '0'
        : item.powerDelta >= 0
            ? '+${item.powerDelta}'
            : '${item.powerDelta}';

    return ListTile(
      title: Text(item.name),
      subtitle: Row(
        children: [
          if (!item.isPassive) Icon(Icons.bolt, size: 14, color: powerColor),
          Text(
            item.isPassive ? l10n.baseCalculatorNoPowerDraw : powerText,
            style: TextStyle(color: powerColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      trailing: _Stepper(
        quantity: quantity,
        onRemove: quantity == 0 ? null : () => notifier.decrement(item.code),
        onAdd: () => notifier.increment(item.code),
      ),
    );
  }
}

class _StorageRow extends ConsumerWidget {
  const _StorageRow({required this.option});

  final StorageOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(baseCalculatorProvider.notifier);
    final quantity = ref.watch(
      baseCalculatorProvider
          .select((s) => s.storageQuantities[option.code] ?? 0),
    );

    return ListTile(
      title: Text(option.name),
      subtitle: Text(
        l10n.baseCalculatorStorageSpec(
          option.volumeCapacity,
          option.slotCapacity,
        ),
      ),
      trailing: _Stepper(
        quantity: quantity,
        onRemove:
            quantity == 0 ? null : () => notifier.decrementStorage(option.code),
        onAdd: () => notifier.incrementStorage(option.code),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.quantity,
    required this.onRemove,
    required this.onAdd,
  });

  final int quantity;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onRemove,
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
          onPressed: onAdd,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
