import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/characters/screens/character_management_screen.dart';
import '../../features/journal/screens/journal_hub_screen.dart';
import '../../features/field_timers/screens/field_timer_screen.dart';
import '../../features/blueprints/screens/blueprint_tracker_screen.dart';
import '../../features/base_calculator/screens/base_calculator_screen.dart';
import '../../features/alerts/screens/alerts_screen.dart';
import '../../features/alerts/providers/alert_provider.dart';
import '../../features/bases/providers/base_provider.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../theme/app_colors.dart';
import 'navigation_rail_footer.dart';
import 'navigation_rail_settings.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

// Provider to track current navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Nav indices — keep in sync with the screens list below.
// 0 Dashboard | 1 Characters | 2 Journal | 3 FieldTimers |
// 4 Blueprints | 5 Calculator | 6 Alerts | 7 Settings
const navIndexDashboard = 0;
const navIndexCharacters = 1;
const navIndexJournal = 2;
const navIndexFieldTimers = 3;
const navIndexBlueprints = 4;
const navIndexCalculator = 5;
const navIndexAlerts = 6;
const navIndexSettings = 7;

/// Mobile bottom nav shows the first four destinations plus "More";
/// any screen index past Field Timers highlights the More slot.
const mobileMoreSlot = 4;

int mobileNavSelectedIndex(int currentIndex) =>
    currentIndex < mobileMoreSlot ? currentIndex : mobileMoreSlot;

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final activeAlertsAsync = ref.watch(activeAlertsProvider);
    final basesAsync = ref.watch(basesProvider);
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const DashboardScreen(), // 0
      const CharacterManagementScreen(), // 1
      const JournalHubScreen(), // 2
      const FieldTimerScreen(), // 3
      const BlueprintTrackerScreen(), // 4
      const BaseCalculatorScreen(), // 5
      const AlertsScreen(), // 6
      const SettingsScreen(), // 7
    ];

    final isDesktop = defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS;

    final alertCount = activeAlertsAsync.maybeWhen(
      data: (alerts) => alerts.length,
      orElse: () => 0,
    );

    Color? alertIconColor;
    basesAsync.whenData((bases) {
      if (bases.isEmpty) return;
      double minHours = double.infinity;
      for (final base in bases) {
        if (!base.notificationsEnabled) continue;
        final hours = base.hoursRemaining;
        if (hours < minHours) minHours = hours;
      }
      if (minHours < 24) {
        alertIconColor = DuneColors.criticalPrimary;
      } else if (minHours < 48) {
        alertIconColor = DuneColors.warningPrimary;
      }
    });

    if (isDesktop) {
      final railExpanded = ref.watch(navigationRailExpandedProvider);
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                ref.read(navigationIndexProvider.notifier).state = index;
              },
              extended: railExpanded,
              labelType: NavigationRailLabelType.none,
              minExtendedWidth: 200,
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: NavigationRailFooter(
                    extended: railExpanded,
                    onFieldTimerTap: () => ref
                        .read(navigationIndexProvider.notifier)
                        .state = navIndexFieldTimers,
                    onBaseExpiryTap: () => ref
                        .read(navigationIndexProvider.notifier)
                        .state = navIndexAlerts,
                  ),
                ),
              ),
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
                  icon: const Icon(Icons.menu_book_outlined),
                  selectedIcon: const Icon(Icons.menu_book),
                  label: Text(l10n.navJournal),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.timer_outlined),
                  selectedIcon: const Icon(Icons.timer),
                  label: Text(l10n.navFieldTimers),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.construction_outlined),
                  selectedIcon: const Icon(Icons.construction),
                  label: Text(l10n.navBlueprints),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.calculate_outlined),
                  selectedIcon: const Icon(Icons.calculate),
                  label: Text(l10n.navCalculator),
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

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: mobileNavSelectedIndex(currentIndex),
        onDestinationSelected: (index) {
          if (index < mobileMoreSlot) {
            ref.read(navigationIndexProvider.notifier).state = index;
          } else {
            showModalBottomSheet<void>(
              context: context,
              builder: (_) => MoreNavigationSheet(
                alertCount: alertCount,
                alertIconColor: alertIconColor,
              ),
            );
          }
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
            icon: const Icon(Icons.menu_book),
            label: l10n.navJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.timer),
            label: l10n.navFieldTimers,
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$alertCount'),
              isLabelVisible: alertCount > 0,
              child: Icon(
                Icons.more_horiz,
                color: alertIconColor,
              ),
            ),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet listing the overflow destinations on mobile.
class MoreNavigationSheet extends ConsumerWidget {
  const MoreNavigationSheet({
    super.key,
    required this.alertCount,
    this.alertIconColor,
  });

  final int alertCount;
  final Color? alertIconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    void goTo(int index) {
      Navigator.of(context).pop();
      ref.read(navigationIndexProvider.notifier).state = index;
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.construction),
            title: Text(l10n.navBlueprints),
            onTap: () => goTo(navIndexBlueprints),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: Text(l10n.navCalculator),
            onTap: () => goTo(navIndexCalculator),
          ),
          ListTile(
            leading: Badge(
              label: Text('$alertCount'),
              isLabelVisible: alertCount > 0,
              child: Icon(
                Icons.notification_important,
                color: alertIconColor,
              ),
            ),
            title: Text(l10n.navAlerts),
            onTap: () => goTo(navIndexAlerts),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.navSettings),
            onTap: () => goTo(navIndexSettings),
          ),
        ],
      ),
    );
  }
}
