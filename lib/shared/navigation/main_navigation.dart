import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/characters/screens/character_management_screen.dart';
import '../../features/alerts/screens/alerts_screen.dart';
import '../../features/alerts/providers/alert_provider.dart';
import '../../features/bases/providers/base_provider.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../theme/app_colors.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// Provider to track current navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final activeAlertsAsync = ref.watch(activeAlertsProvider);
    final basesAsync = ref.watch(basesProvider);
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const DashboardScreen(),
      const CharacterManagementScreen(),
      const AlertsScreen(),
      const SettingsScreen(),
    ];

    // Use NavigationRail for desktop, BottomNavigationBar for mobile
    final isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;

    // Get alert count
    final alertCount = activeAlertsAsync.maybeWhen(
      data: (alerts) => alerts.length,
      orElse: () => 0,
    );

    // Calculate most urgent base severity for icon color
    Color? alertIconColor;
    basesAsync.whenData((bases) {
      if (bases.isEmpty) return;
      
      // Find minimum hours remaining across all bases
      double minHours = double.infinity;
      for (final base in bases) {
        final hours = base.hoursRemaining;
        if (hours < minHours) {
          minHours = hours;
        }
      }
      
      // Color code: red < 24h, yellow < 48h
      if (minHours < 24) {
        alertIconColor = DuneColors.criticalPrimary; // Red
      } else if (minHours < 48) {
        alertIconColor = DuneColors.warningPrimary; // Yellow
      }
    });

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                ref.read(navigationIndexProvider.notifier).state = index;
              },
              extended: true,
              labelType: NavigationRailLabelType.none,
              minExtendedWidth: 200,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.dashboard_outlined),
                  selectedIcon: const Icon(Icons.dashboard),
                  label: Text(l10n.navDashboard),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: Text(l10n.navCharacters),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    label: Text('$alertCount'),
                    isLabelVisible: alertCount > 0,
                    child: Icon(
                      Icons.notification_important_outlined,
                      color: alertIconColor,
                    ),
                  ),
                  selectedIcon: Badge(
                    label: Text('$alertCount'),
                    isLabelVisible: alertCount > 0,
                    child: Icon(
                      Icons.notification_important,
                      color: alertIconColor,
                    ),
                  ),
                  label: Text(l10n.navAlerts),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(l10n.navSettings),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout with bottom navigation
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: l10n.navCharacters,
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$alertCount'),
              isLabelVisible: alertCount > 0,
              child: Icon(
                Icons.notification_important,
                color: alertIconColor,
              ),
            ),
            label: l10n.navAlerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
