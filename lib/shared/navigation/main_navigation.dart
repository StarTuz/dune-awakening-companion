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

// Provider to track current navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final activeAlertsAsync = ref.watch(activeAlertsProvider);
    final basesAsync = ref.watch(basesProvider);

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
                const NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Characters'),
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
                  label: const Text('Alerts'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
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
          const NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Characters',
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
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
