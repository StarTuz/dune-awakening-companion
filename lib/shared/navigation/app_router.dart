import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/bases/screens/base_management_screen.dart';
import '../../features/characters/screens/character_management_screen.dart';
import '../../features/servers/screens/server_management_screen.dart';
import '../../features/alerts/screens/alerts_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case '/bases':
        return MaterialPageRoute(
          builder: (_) => const BaseManagementScreen(),
        );

      case '/characters':
        return MaterialPageRoute(
          builder: (_) => const CharacterManagementScreen(),
        );

      case '/servers':
        return MaterialPageRoute(
          builder: (_) => const ServerManagementScreen(),
        );

      case '/alerts':
        return MaterialPageRoute(
          builder: (_) => const AlertsScreen(),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

