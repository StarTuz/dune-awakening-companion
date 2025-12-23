# Extensibility Guide - Adding New Features

This guide explains how to extend the Dune Awakening Companion App with new features.

## Architecture Overview

The app follows a **feature-based modular architecture** where each feature is self-contained and can be added without modifying existing code.

## Core Principles

1. **Separation of Concerns**: Each layer has a clear responsibility
2. **Dependency Inversion**: Depend on interfaces, not implementations
3. **Open/Closed**: Open for extension, closed for modification
4. **Single Responsibility**: Each class/service does one thing well

## Adding a New Feature - Step by Step

### Example: Adding a "Statistics" Feature

#### Step 1: Create Feature Directory Structure

```bash
lib/features/statistics/
├── models/
│   └── statistics_model.dart
├── providers/
│   └── statistics_provider.dart
├── services/
│   └── statistics_service.dart
├── screens/
│   └── statistics_screen.dart
└── widgets/
    ├── statistics_chart.dart
    └── statistics_card.dart
```

#### Step 2: Define the Model

```dart
// lib/features/statistics/models/statistics_model.dart
class BaseStatistics {
  final String id;
  final String baseId;
  final Map<String, dynamic> data; // Flexible JSON data
  final DateTime createdAt;
  
  BaseStatistics({
    required this.id,
    required this.baseId,
    required this.data,
    required this.createdAt,
  });
  
  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'baseId': baseId,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
  };
  
  factory BaseStatistics.fromJson(Map<String, dynamic> json) {
    return BaseStatistics(
      id: json['id'],
      baseId: json['baseId'],
      data: json['data'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
```

#### Step 3: Create the Service (Business Logic)

```dart
// lib/features/statistics/services/statistics_service.dart
import 'package:riverpod/riverpod.dart';
import '../models/statistics_model.dart';
import '../../../core/database/app_database.dart';

class StatisticsService {
  final AppDatabase _database;
  
  StatisticsService(this._database);
  
  Future<List<BaseStatistics>> getBaseStatistics(String baseId) async {
    // Implement statistics retrieval
    // This is isolated - doesn't affect other features
  }
  
  Future<void> recordStatistics(BaseStatistics stats) async {
    // Save statistics
  }
}

// Provider for dependency injection
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  final database = ref.watch(databaseProvider);
  return StatisticsService(database);
});
```

#### Step 4: Create the Provider (State Management)

```dart
// lib/features/statistics/providers/statistics_provider.dart
import 'package:riverpod/riverpod.dart';
import '../models/statistics_model.dart';
import '../services/statistics_service.dart';

final statisticsProvider = FutureProvider.family<List<BaseStatistics>, String>(
  (ref, baseId) async {
    final service = ref.watch(statisticsServiceProvider);
    return await service.getBaseStatistics(baseId);
  },
);
```

#### Step 5: Create the UI Screen

```dart
// lib/features/statistics/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../providers/statistics_provider.dart';
import '../widgets/statistics_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final String baseId;
  
  const StatisticsScreen({required this.baseId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Consumer(
        builder: (context, ref, child) {
          final statsAsync = ref.watch(statisticsProvider(baseId));
          
          return statsAsync.when(
            data: (statistics) => StatisticsChart(statistics: statistics),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}
```

#### Step 6: Add Database Migration (if needed)

```dart
// lib/core/database/migrations/migration_002_add_statistics.dart
class Migration002AddStatistics {
  static Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS base_statistics (
        id TEXT PRIMARY KEY,
        base_id TEXT NOT NULL,
        data TEXT NOT NULL,  -- JSON
        created_at INTEGER NOT NULL,
        FOREIGN KEY (base_id) REFERENCES bases(id)
      )
    ''');
    
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_statistics_base_id 
      ON base_statistics(base_id)
    ''');
  }
  
  static Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF NOT EXISTS base_statistics');
  }
}
```

#### Step 7: Register in Navigation

```dart
// lib/shared/navigation/app_router.dart
import '../features/statistics/screens/statistics_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ... existing routes
      
      case '/statistics':
        final baseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => StatisticsScreen(baseId: baseId),
        );
        
      // ... other routes
    }
  }
}
```

#### Step 8: Add to Main App (Optional - if needed in main menu)

```dart
// lib/main.dart or navigation drawer
ListTile(
  leading: Icon(Icons.bar_chart),
  title: Text('Statistics'),
  onTap: () => Navigator.pushNamed(context, '/statistics'),
),
```

## Extension Points

### 1. Alert Handlers

Add custom alert types by implementing the `AlertHandler` interface:

```dart
abstract class AlertHandler {
  Future<void> handleAlert(Alert alert);
  String get handlerType;
}

class CustomAlertHandler implements AlertHandler {
  @override
  String get handlerType => 'custom';
  
  @override
  Future<void> handleAlert(Alert alert) async {
    // Custom alert logic
  }
}
```

### 2. Export Formats

Add new export formats:

```dart
abstract class ExportFormat {
  String get formatName;
  String get fileExtension;
  Future<String> export(List<Base> bases);
}

class ExcelExportFormat implements ExportFormat {
  @override
  String get formatName => 'Excel';
  
  @override
  String get fileExtension => 'xlsx';
  
  @override
  Future<String> export(List<Base> bases) async {
    // Excel export logic
  }
}
```

### 3. Theme Providers

Add custom themes:

```dart
abstract class ThemeProvider {
  ThemeData getTheme();
  String get themeName;
}

class CustomDuneTheme implements ThemeProvider {
  @override
  String get themeName => 'Custom Dune';
  
  @override
  ThemeData getTheme() {
    return ThemeData(
      // Custom theme
    );
  }
}
```

## Best Practices

### 1. Keep Features Independent
- Don't create circular dependencies
- Use interfaces for cross-feature communication
- Prefer composition over direct dependencies

### 2. Database Migrations
- Always use migrations for schema changes
- Never modify existing migrations
- Test migrations up and down

### 3. State Management
- Use providers for state
- Keep providers focused
- Don't put UI logic in providers

### 4. Testing
- Write unit tests for services
- Write widget tests for UI
- Test feature integration

### 5. Documentation
- Document public interfaces
- Add code comments for complex logic
- Update this guide with new patterns

## Common Extension Scenarios

### Adding a New Data Type

1. Create model in `lib/features/[feature]/models/`
2. Add database table via migration
3. Create repository/service
4. Add provider for state management
5. Create UI components

### Adding a New Screen

1. Create screen in `lib/features/[feature]/screens/`
2. Add route to `app_router.dart`
3. Add navigation item (if needed)
4. Test navigation flow

### Adding a New Service

1. Create service in `lib/features/[feature]/services/`
2. Create provider for dependency injection
3. Implement interface if extending existing functionality
4. Add tests

### Adding Platform-Specific Code

1. Use conditional imports or platform checks
2. Put platform code in `lib/platform/`
3. Create platform-specific implementations
4. Use dependency injection to swap implementations

## Migration Strategy

When adding features that require database changes:

1. **Create Migration**: Add new migration file
2. **Update Version**: Increment database version
3. **Test Migration**: Test both up and down migrations
4. **Backward Compatibility**: Ensure old data still works
5. **Document Changes**: Update migration documentation

## Example: Complete Feature Addition

See `examples/statistics_feature/` for a complete example of adding a statistics feature from scratch.

## Questions?

- Check existing features for patterns
- Review `ARCHITECTURE.md` for design decisions
- Ask in development discussions

