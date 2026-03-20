import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/providers/character_provider.dart';
import '../../characters/models/character.dart';
import '../../bases/providers/base_provider.dart';
import '../../bases/models/base.dart';
import '../../../shared/theme/app_colors.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(charactersProvider);
          ref.invalidate(basesProvider);
        },
        child: charactersAsync.when(
          data: (characters) => basesAsync.when(
            data: (bases) => _DashboardContent(
              characters: characters,
              bases: bases,
              l10n: l10n,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('${l10n.error}: $error')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('${l10n.error}: $error')),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.characters,
    required this.bases,
    required this.l10n,
  });

  final List<Character> characters;
  final List<Base> bases;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final expiringSoon = bases.where((base) {
      if (!base.notificationsEnabled) return false;
      final powerHours =
          base.powerExpirationTime.difference(now).inMinutes / 60.0;
      return powerHours < base.effectiveWarningThresholdHours && powerHours > 0;
    }).length;
    final criticalBases = bases.where((base) {
      if (!base.notificationsEnabled) return false;
      final powerHours =
          base.powerExpirationTime.difference(now).inMinutes / 60.0;
      return powerHours < base.effectiveCriticalThresholdHours;
    }).length;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatCard(
              title: l10n.charactersTitle,
              value: characters.length.toString(),
              icon: Icons.person,
              color: DuneColors.primaryAccent,
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: l10n.basesTitle,
              value: bases.length.toString(),
              icon: Icons.home,
              color: DuneColors.secondaryAccent,
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: l10n.expiringSoonTitle,
              value: expiringSoon.toString(),
              icon: Icons.warning,
              color: DuneColors.warningPrimary,
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: l10n.activeAlertsTitle,
              value: criticalBases.toString(),
              icon: Icons.notifications,
              color: DuneColors.criticalPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Characters by Region',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: _RegionChart(characters: characters),
            ),
            const SizedBox(height: 24),
            Text(
              'Base Alert Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: _AlertDistributionChart(bases: bases),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionChart extends StatelessWidget {
  const _RegionChart({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final character in characters) {
      counts.update(character.region, (value) => value + 1, ifAbsent: () => 1);
    }

    final entries = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return const Center(
          child: Text('Add characters to unlock region analytics.'));
    }

    final maxVal = entries.map((e) => e.value).reduce(math.max);
    final maxY = math.max(maxVal + 1, 2).toDouble();
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 12, 8),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            minY: 0,
            maxY: maxY,
            barTouchData: const BarTouchData(enabled: false),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value < meta.min || value > meta.max) {
                      return const SizedBox.shrink();
                    }
                    if ((value - value.round()).abs() > 0.001) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        value.toInt().toString(),
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    final label = entries[index].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        label,
                        style: textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (var i = 0; i < entries.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: entries[i].value.toDouble(),
                      color: Theme.of(context).colorScheme.primary,
                      width: 22,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertDistributionChart extends StatelessWidget {
  const _AlertDistributionChart({required this.bases});

  final List<Base> bases;

  @override
  Widget build(BuildContext context) {
    var critical = 0;
    var warning = 0;
    var safe = 0;

    for (final base in bases) {
      final hours = base.hoursRemaining;
      if (!base.notificationsEnabled) {
        safe++;
      } else if (hours < base.effectiveCriticalThresholdHours) {
        critical++;
      } else if (hours < base.effectiveWarningThresholdHours) {
        warning++;
      } else {
        safe++;
      }
    }

    if (bases.isEmpty) {
      return const Center(child: Text('Add bases to unlock alert analytics.'));
    }

    const ringRadius = 64.0;
    const holeRadius = 38.0;

    final pieSections = <PieChartSectionData>[
      if (critical > 0)
        PieChartSectionData(
          value: critical.toDouble(),
          title: '',
          color: DuneColors.criticalPrimary,
          radius: ringRadius,
        ),
      if (warning > 0)
        PieChartSectionData(
          value: warning.toDouble(),
          title: '',
          color: DuneColors.warningPrimary,
          radius: ringRadius,
        ),
      if (safe > 0)
        PieChartSectionData(
          value: safe.toDouble(),
          title: '',
          color: DuneColors.secondaryAccent,
          radius: ringRadius,
        ),
    ];

    return Card(
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final side = math.min(constraints.maxWidth, constraints.maxHeight);
                  return Center(
                    child: SizedBox(
                      width: side,
                      height: side,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: holeRadius,
                          sections: pieSections.isEmpty
                              ? [
                                  PieChartSectionData(
                                    value: 1,
                                    title: '',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    radius: ringRadius,
                                  ),
                                ]
                              : pieSections,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                _ChartLegendItem(
                  color: DuneColors.criticalPrimary,
                  label: 'Critical',
                  value: critical,
                ),
                _ChartLegendItem(
                  color: DuneColors.warningPrimary,
                  label: 'Warning',
                  value: warning,
                ),
                _ChartLegendItem(
                  color: DuneColors.secondaryAccent,
                  label: 'Safe',
                  value: safe,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  const _ChartLegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text('$label: $value', style: style),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
