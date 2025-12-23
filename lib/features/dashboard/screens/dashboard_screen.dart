import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';
import '../../../shared/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                    title: 'Characters',
                    value: characters.length.toString(),
                    icon: Icons.person,
                    color: DuneColors.primaryAccent,
                  ),
                  loading: () => const _StatCard(
                    title: 'Characters',
                    value: '...',
                    icon: Icons.person,
                    color: DuneColors.primaryAccent,
                  ),
                  error: (_, __) => const _StatCard(
                    title: 'Characters',
                    value: 'Error',
                    icon: Icons.person,
                    color: DuneColors.error,
                  ),
                ),
                const SizedBox(height: 16),
                basesAsync.when(
                  data: (bases) => _StatCard(
                    title: 'Bases',
                    value: bases.length.toString(),
                    icon: Icons.home,
                    color: DuneColors.secondaryAccent,
                  ),
                  loading: () => const _StatCard(
                    title: 'Bases',
                    value: '...',
                    icon: Icons.home,
                    color: DuneColors.secondaryAccent,
                  ),
                  error: (_, __) => const _StatCard(
                    title: 'Bases',
                    value: 'Error',
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
                      title: 'Expiring Soon',
                      value: expiringSoon.toString(),
                      icon: Icons.warning,
                      color: DuneColors.warningPrimary,
                    );
                  },
                  loading: () => const _StatCard(
                    title: 'Expiring Soon',
                    value: '...',
                    icon: Icons.warning,
                    color: DuneColors.warningPrimary,
                  ),
                  error: (_, __) => const _StatCard(
                    title: 'Expiring Soon',
                    value: 'Error',
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
                      title: 'Active Alerts',
                      value: criticalBases.toString(),
                      icon: Icons.notifications,
                      color: DuneColors.criticalPrimary,
                    );
                  },
                  loading: () => const _StatCard(
                    title: 'Active Alerts',
                    value: '...',
                    icon: Icons.notifications,
                    color: DuneColors.criticalPrimary,
                  ),
                  error: (_, __) => const _StatCard(
                    title: 'Active Alerts',
                    value: 'Error',
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
