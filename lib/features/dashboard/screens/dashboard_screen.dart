import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/providers/character_provider.dart';
import '../../characters/models/character.dart';
import '../../bases/providers/base_provider.dart';
import '../../bases/models/base.dart';
import '../../bases/screens/base_management_screen.dart';
import '../../../core/models/activity_event.dart';
import '../../../core/providers/activity_log_provider.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/navigation/main_navigation.dart';
import '../../../shared/theme/app_colors.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);
    final recentEvents = ref.watch(recentActivityProvider).maybeWhen(
          data: (events) => events,
          orElse: () => const <ActivityEvent>[],
        );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(charactersProvider);
          ref.invalidate(basesProvider);
          ref.invalidate(recentActivityProvider);
        },
        child: charactersAsync.when(
          data: (characters) => basesAsync.when(
            data: (bases) => _DashboardContent(
              characters: characters,
              bases: bases,
              recentEvents: recentEvents,
              l10n: l10n,
              onCharactersTap: () {
                ref.read(navigationIndexProvider.notifier).state =
                    navIndexCharacters;
              },
              onBasesTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BaseManagementScreen(),
                  ),
                );
              },
              onAddBaseTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const BaseManagementScreen(openAddDialog: true),
                  ),
                );
              },
              onAlertsTap: () {
                ref.read(navigationIndexProvider.notifier).state =
                    navIndexAlerts;
              },
              onJournalTap: () {
                ref.read(navigationIndexProvider.notifier).state =
                    navIndexJournal;
              },
              onFieldTimersTap: () {
                ref.read(navigationIndexProvider.notifier).state =
                    navIndexFieldTimers;
              },
              onClosedWorldsTap: () {
                ref.read(closedWorldCharacterFilterProvider.notifier).state =
                    true;
                ref.read(navigationIndexProvider.notifier).state =
                    navIndexCharacters;
              },
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
    required this.recentEvents,
    required this.l10n,
    required this.onCharactersTap,
    required this.onBasesTap,
    required this.onAlertsTap,
    required this.onJournalTap,
    required this.onFieldTimersTap,
    required this.onAddBaseTap,
    required this.onClosedWorldsTap,
  });

  final List<Character> characters;
  final List<Base> bases;
  final List<ActivityEvent> recentEvents;
  final AppLocalizations l10n;
  final VoidCallback onCharactersTap;
  final VoidCallback onBasesTap;
  final VoidCallback onAlertsTap;
  final VoidCallback onJournalTap;
  final VoidCallback onFieldTimersTap;
  final VoidCallback onAddBaseTap;
  final VoidCallback onClosedWorldsTap;

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
    final closedWorldCharacters = characters
        .where((c) =>
            AppConstants.isClosedWorld(c.world) && !c.closedWorldAcknowledged)
        .length;

    final tiles = <Widget>[
      _StatTile(
        title: l10n.charactersTitle,
        value: characters.length.toString(),
        icon: Icons.person,
        color: DuneColors.primaryAccent,
        onTap: onCharactersTap,
      ),
      _StatTile(
        title: l10n.basesTitle,
        value: bases.length.toString(),
        icon: Icons.home,
        color: DuneColors.secondaryAccent,
        onTap: onBasesTap,
        actions: [
          _TileAction(
            icon: Icons.home_outlined,
            label: l10n.dashboardActionManageBases,
            onSelected: onBasesTap,
          ),
          _TileAction(
            icon: Icons.add_home_outlined,
            label: l10n.dashboardActionAddBase,
            onSelected: onAddBaseTap,
          ),
        ],
      ),
      _StatTile(
        title: l10n.expiringSoonTitle,
        value: expiringSoon.toString(),
        icon: Icons.warning,
        color: DuneColors.warningPrimary,
        onTap: onAlertsTap,
      ),
      _StatTile(
        title: l10n.activeAlertsTitle,
        value: criticalBases.toString(),
        icon: Icons.notifications,
        color: DuneColors.criticalPrimary,
        onTap: onAlertsTap,
      ),
      if (closedWorldCharacters > 0)
        _StatTile(
          title: l10n.dashboardClosedWorldsTitle,
          value: closedWorldCharacters.toString(),
          icon: Icons.public_off,
          color: DuneColors.warningPrimary,
          onTap: onClosedWorldsTap,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;
        final tileColumns = constraints.maxWidth >= 600 ? 4 : 2;

        final charts = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardCharactersByRegion,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: _RegionChart(characters: characters, l10n: l10n),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.dashboardAlertDistribution,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: _AlertDistributionChart(bases: bases, l10n: l10n),
            ),
          ],
        );

        final activity = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardRecentActivity,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _RecentActivityCard(
              events: recentEvents,
              l10n: l10n,
              onJournalTap: onJournalTap,
              onCharactersTap: onCharactersTap,
              onBasesTap: onBasesTap,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.dashboardQuickActions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.timer_outlined,
                        color: DuneColors.cautionPrimary),
                    title: Text(l10n.dashboardActionStartTimer),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onFieldTimersTap,
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_outlined,
                        color: DuneColors.secondaryAccent),
                    title: Text(l10n.dashboardActionManageBases),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onBasesTap,
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_note,
                        color: DuneColors.primaryAccent),
                    title: Text(l10n.dashboardActionWriteChronicle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onJournalTap,
                  ),
                ],
              ),
            ),
          ],
        );

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: tileColumns,
                    mainAxisExtent: 104,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: tiles,
                ),
                const SizedBox(height: 24),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: charts),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: activity),
                    ],
                  )
                else ...[
                  charts,
                  const SizedBox(height: 24),
                  activity,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({
    required this.events,
    required this.l10n,
    required this.onJournalTap,
    required this.onCharactersTap,
    required this.onBasesTap,
  });

  final List<ActivityEvent> events;
  final AppLocalizations l10n;
  final VoidCallback onJournalTap;
  final VoidCallback onCharactersTap;
  final VoidCallback onBasesTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (events.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.history, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.dashboardRecentActivityEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final event in events)
            ListTile(
              onTap: _onTapFor(event.type),
              leading: CircleAvatar(
                backgroundColor: _colorFor(event.type).withOpacity(0.2),
                child: Icon(
                  _iconFor(event.type),
                  size: 20,
                  color: _colorFor(event.type),
                ),
              ),
              title: Text(
                _titleFor(event),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _subtitleFor(context, event),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  String _titleFor(ActivityEvent event) {
    switch (event.type) {
      case ActivityEventType.characterCreated:
        return l10n.activityCharacterCreated(event.subject);
      case ActivityEventType.characterDeleted:
        return l10n.activityCharacterDeleted(event.subject);
      case ActivityEventType.baseCreated:
        return l10n.activityBaseCreated(event.subject);
      case ActivityEventType.baseDeleted:
        return l10n.activityBaseDeleted(event.subject);
      case ActivityEventType.journalEntryWritten:
        return l10n.activityJournalEntry(event.subject);
    }
  }

  /// Same-day events show the time; older ones show the date.
  String _subtitleFor(BuildContext context, ActivityEvent event) {
    final materialL10n = MaterialLocalizations.of(context);
    final now = DateTime.now();
    final isToday = event.createdAt.year == now.year &&
        event.createdAt.month == now.month &&
        event.createdAt.day == now.day;
    final when = isToday
        ? materialL10n.formatTimeOfDay(TimeOfDay.fromDateTime(event.createdAt))
        : materialL10n.formatShortDate(event.createdAt);
    final name = event.characterName;
    return name == null ? when : '$name \u2022 $when';
  }

  IconData _iconFor(ActivityEventType type) {
    switch (type) {
      case ActivityEventType.characterCreated:
        return Icons.person_add_alt;
      case ActivityEventType.characterDeleted:
        return Icons.person_off_outlined;
      case ActivityEventType.baseCreated:
        return Icons.add_home_outlined;
      case ActivityEventType.baseDeleted:
        return Icons.home_outlined;
      case ActivityEventType.journalEntryWritten:
        return Icons.menu_book_outlined;
    }
  }

  Color _colorFor(ActivityEventType type) {
    switch (type) {
      case ActivityEventType.characterCreated:
      case ActivityEventType.journalEntryWritten:
        return DuneColors.primaryAccent;
      case ActivityEventType.baseCreated:
        return DuneColors.secondaryAccent;
      case ActivityEventType.characterDeleted:
      case ActivityEventType.baseDeleted:
        return DuneColors.criticalPrimary;
    }
  }

  VoidCallback _onTapFor(ActivityEventType type) {
    switch (type) {
      case ActivityEventType.characterCreated:
      case ActivityEventType.characterDeleted:
        return onCharactersTap;
      case ActivityEventType.baseCreated:
      case ActivityEventType.baseDeleted:
        return onBasesTap;
      case ActivityEventType.journalEntryWritten:
        return onJournalTap;
    }
  }
}

class _RegionChart extends StatelessWidget {
  const _RegionChart({required this.characters, required this.l10n});

  final List<Character> characters;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final character in characters) {
      counts.update(character.region, (value) => value + 1, ifAbsent: () => 1);
    }

    final entries = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return Center(child: Text(l10n.dashboardRegionEmptyHint));
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
  const _AlertDistributionChart({required this.bases, required this.l10n});

  final List<Base> bases;
  final AppLocalizations l10n;

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
      return Center(child: Text(l10n.dashboardAlertsEmptyHint));
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
                  final side =
                      math.min(constraints.maxWidth, constraints.maxHeight);
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
                  label: l10n.chartLegendCritical,
                  value: critical,
                ),
                _ChartLegendItem(
                  color: DuneColors.warningPrimary,
                  label: l10n.chartLegendWarning,
                  value: warning,
                ),
                _ChartLegendItem(
                  color: DuneColors.secondaryAccent,
                  label: l10n.chartLegendSafe,
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

/// A context-menu action attached to a [_StatTile] (right-click on
/// desktop, long-press on touch).
class _TileAction {
  const _TileAction({
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onSelected;
}

class _StatTile extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final List<_TileAction> actions;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.actions = const [],
  });

  @override
  State<_StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<_StatTile> {
  bool _hovered = false;
  Offset _menuPosition = Offset.zero;

  Future<void> _showActionsMenu() async {
    if (widget.actions.isEmpty) return;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final action = await showMenu<_TileAction>(
      context: context,
      position: RelativeRect.fromRect(
        _menuPosition & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        for (final action in widget.actions)
          PopupMenuItem<_TileAction>(
            value: action,
            child: Row(
              children: [
                Icon(action.icon, size: 20),
                const SizedBox(width: 12),
                Text(action.label),
              ],
            ),
          ),
      ],
    );
    action?.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasActions = widget.actions.isNotEmpty;
    return Card(
      elevation: _hovered ? 6 : null,
      color: Color.alphaBlend(
        widget.color.withOpacity(_hovered ? 0.18 : 0.12),
        theme.cardTheme.color ?? theme.colorScheme.surface,
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovered) => setState(() => _hovered = hovered),
        onTapDown: (details) => _menuPosition = details.globalPosition,
        onSecondaryTapDown: hasActions
            ? (details) {
                _menuPosition = details.globalPosition;
                _showActionsMenu();
              }
            : null,
        onLongPress: hasActions ? _showActionsMenu : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: widget.color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
