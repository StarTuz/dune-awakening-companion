import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_info.dart';
import '../../features/bases/providers/base_provider.dart';
import '../../features/field_timers/providers/field_timer_provider.dart';
import '../theme/app_colors.dart';
import 'navigation_rail_settings.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

/// Bottom-anchored footer for the desktop navigation rail.
///
/// Shows glanceable live status (running field timer, next base power
/// expiry) above a collapse toggle and the app version. Status rows are
/// hidden when there is nothing to report.
class NavigationRailFooter extends ConsumerWidget {
  const NavigationRailFooter({
    super.key,
    required this.extended,
    required this.onFieldTimerTap,
    required this.onBaseExpiryTap,
  });

  final bool extended;
  final VoidCallback onFieldTimerTap;
  final VoidCallback onBaseExpiryTap;

  /// Keep in sync with the NavigationRail config in main_navigation.dart:
  /// [_extendedWidth] matches minExtendedWidth, [_collapsedWidth] matches the
  /// default M3 rail width. The rail passes unbounded width constraints to
  /// its trailing widget, so the footer must size itself.
  static const _extendedWidth = 200.0;
  static const _collapsedWidth = 80.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(fieldTimerProvider);
    final basesAsync = ref.watch(basesProvider);

    // Soonest power expiry among bases with notifications on, if it is
    // inside the 48 h warning window (matches the alert icon thresholds).
    double? expiryHours;
    basesAsync.whenData((bases) {
      double minHours = double.infinity;
      for (final base in bases) {
        if (!base.notificationsEnabled) continue;
        if (base.hoursRemaining < minHours) minHours = base.hoursRemaining;
      }
      if (minHours < 48) expiryHours = minHours;
    });

    final statusRows = <Widget>[
      if (!session.isIdle)
        _StatusRow(
          extended: extended,
          icon: session.isFiring ? Icons.alarm_on : Icons.timer,
          color: session.isFiring
              ? DuneColors.criticalPrimary
              : DuneColors.secondaryAccent,
          label: l10n.railFieldTimerLabel,
          value: _formatDuration(session.remaining),
          onTap: onFieldTimerTap,
        ),
      if (expiryHours != null)
        _StatusRow(
          extended: extended,
          icon: Icons.power_off,
          color: expiryHours! < 24
              ? DuneColors.criticalPrimary
              : DuneColors.warningPrimary,
          label: l10n.railBaseExpiryLabel,
          value: _formatHours(expiryHours!),
          onTap: onBaseExpiryTap,
        ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: extended ? _extendedWidth : _collapsedWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...statusRows,
          if (statusRows.isNotEmpty) const Divider(height: 1),
          _BottomBar(extended: extended),
        ],
      ),
    );
  }

  static String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$m:$ss';
  }

  static String _formatHours(double hours) =>
      hours < 1 ? '<1h' : '${hours.floor()}h';
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.extended,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final bool extended;
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: color, fontWeight: FontWeight.w600);

    if (!extended) {
      return Tooltip(
        message: '$label: $value',
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 2),
                Text(value, style: valueStyle),
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(value, style: valueStyle),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final toggle = IconButton(
      icon: Icon(extended ? Icons.chevron_left : Icons.chevron_right),
      tooltip: extended ? l10n.navRailCollapse : l10n.navRailExpand,
      onPressed: () =>
          ref.read(navigationRailExpandedProvider.notifier).toggle(),
    );

    if (!extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: toggle,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'v${AppInfo.version}',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          toggle,
        ],
      ),
    );
  }
}
