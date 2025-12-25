import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                charactersAsync.when(
                  data: (characters) => _StatCard(
                    title: l10n.charactersTitle,
                    value: characters.length.toString(),
                    icon: Icons.person,
                    color: DuneColors.primaryAccent,
                  ),
                  loading: () => _StatCard(
                    title: l10n.charactersTitle,
                    value: '...',
                    icon: Icons.person,
                    color: DuneColors.primaryAccent,
                  ),
                  error: (_, __) => _StatCard(
                    title: l10n.charactersTitle,
                    value: l10n.error,
                    icon: Icons.person,
                    color: DuneColors.error,
                  ),
                ),
                const SizedBox(height: 16),
                basesAsync.when(
                  data: (bases) => _StatCard(
                    title: l10n.basesTitle,
                    value: bases.length.toString(),
                    icon: Icons.home,
                    color: DuneColors.secondaryAccent,
                  ),
                  loading: () => _StatCard(
                    title: l10n.basesTitle,
                    value: '...',
                    icon: Icons.home,
                    color: DuneColors.secondaryAccent,
                  ),
                  error: (_, __) => _StatCard(
                    title: l10n.basesTitle,
                    value: l10n.error,
                    icon: Icons.home,
                    color: DuneColors.error,
                  ),
                ),
                const SizedBox(height: 16),
                // Expiring Soon: Power < 48h OR Tax < 48h
                basesAsync.when(
                  data: (bases) {
                    final now = DateTime.now();
                    final expiringSoon = bases.where((base) {
                      // Power expiring soon
                      final powerHours = base.powerExpirationTime.difference(now).inMinutes / 60.0;
                      final powerExpiring = powerHours < 48 && powerHours > 0;
                      
                      // Tax expiring soon (if applicable)
                      bool taxExpiring = false;
                      if (base.isAdvancedFief && base.nextTaxDueDate != null) {
                        final taxHours = base.nextTaxDueDate!.difference(now).inMinutes / 60.0;
                        taxExpiring = taxHours < 48;
                      }
                      
                      return powerExpiring || taxExpiring;
                    }).length;
                    
                    return _StatCard(
                      title: l10n.expiringSoonTitle,
                      value: expiringSoon.toString(),
                      icon: Icons.warning,
                      color: DuneColors.warningPrimary,
                    );
                  },
                  loading: () => _StatCard(
                    title: l10n.expiringSoonTitle,
                    value: '...',
                    icon: Icons.warning,
                    color: DuneColors.warningPrimary,
                  ),
                  error: (_, __) => _StatCard(
                    title: l10n.expiringSoonTitle,
                    value: l10n.error,
                    icon: Icons.warning,
                    color: DuneColors.error,
                  ),
                ),
                const SizedBox(height: 16),
                // Active Alerts: Critical power (< 24h) OR Critical tax (overdue/defaulted)
                basesAsync.when(
                  data: (bases) {
                    final now = DateTime.now();
                    final criticalBases = bases.where((base) {
                      // Critical power (< 24 hours)
                      final powerHours = base.powerExpirationTime.difference(now).inMinutes / 60.0;
                      final powerCritical = powerHours < 24;
                      
                      // Critical tax (overdue or defaulted)
                      final taxCritical = base.isTaxCritical;
                      
                      return powerCritical || taxCritical;
                    }).length;
                    
                    return _StatCard(
                      title: l10n.activeAlertsTitle,
                      value: criticalBases.toString(),
                      icon: Icons.notifications,
                      color: DuneColors.criticalPrimary,
                    );
                  },
                  loading: () => _StatCard(
                    title: l10n.activeAlertsTitle,
                    value: '...',
                    icon: Icons.notifications,
                    color: DuneColors.criticalPrimary,
                  ),
                  error: (_, __) => _StatCard(
                    title: l10n.activeAlertsTitle,
                    value: l10n.error,
                    icon: Icons.notifications,
                    color: DuneColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
