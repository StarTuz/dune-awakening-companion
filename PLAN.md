# Dune Awakening Companion Application - Development Plan

## Project Overview
A cross-platform companion application for Dune Awakening that tracks power levels across multiple bases, characters, and servers, with alert notifications when power is running low (24 hours remaining).

## Target Platforms
- **Phase 1**: Linux (initial development)
- **Phase 2**: Windows, macOS
- **Phase 3**: Mobile (iOS, Android)

## Core Requirements

### 1. Multi-Character Support
- Track multiple characters/accounts
- Each character can have multiple bases
- Each base belongs to a specific server

### 2. Power Tracking System
- Store power expiration timestamps for each base
- Calculate time remaining until power runs out
- Support multiple bases per character
- Support multiple servers

### 3. Alert System
- Alert when 24 hours remain until power expiration
- Support multiple simultaneous alerts (multiple bases)
- Persistent notifications
- Visual and audio alerts (optional)

### 4. User Interface
- Modern, attractive UI
- Easy base management (add/edit/remove)
- Clear visualization of power status
- Server/character organization
- Settings/preferences panel

## Technical Architecture

### Recommended Technology Stack

#### Option 1: Flutter (RECOMMENDED - True Cross-Platform)
- **Language**: Dart
- **Benefits**: 
  - ✅ **Single codebase** for Linux, Windows, macOS, iOS, Android
  - ✅ Excellent mobile support (native performance)
  - ✅ Good desktop support (stable on all platforms)
  - ✅ Modern, beautiful UI capabilities
  - ✅ Strong state management solutions
  - ✅ Good performance across all platforms
  - ✅ Active development and large community
- **Limitations**: 
  - Desktop support is mature but less common than web-based solutions
  - Requires Dart knowledge (but similar to TypeScript/JavaScript)

#### Option 2: React Native + Electron (Hybrid Approach)
- **Desktop**: Electron (React + TypeScript)
- **Mobile**: React Native
- **Benefits**: 
  - Web technology stack (JavaScript/TypeScript)
  - Large ecosystem
- **Limitations**: 
  - Two separate codebases to maintain
  - Electron has larger bundle size
  - More complex build process

#### Option 3: Tauri + Separate Mobile App
- **Desktop**: Tauri (Rust + React)
- **Mobile**: React Native or Flutter
- **Benefits**: 
  - Lightweight desktop app
  - Native performance
- **Limitations**: 
  - Two codebases
  - More maintenance overhead

**RECOMMENDATION**: **Flutter** - Best choice for true cross-platform with single codebase, excellent mobile support, and good desktop performance.

### Extensibility & Modular Architecture

**Core Principle**: Build a solid, extensible foundation that makes adding new features straightforward without breaking existing functionality.

#### Architectural Patterns

1. **Clean Architecture / Layered Architecture**
   ```
   Presentation Layer (UI/Screens)
        ↓
   Business Logic Layer (Providers/Services)
        ↓
   Data Layer (Database/Repositories)
   ```
   - Clear separation of concerns
   - Easy to test each layer independently
   - Changes in one layer don't affect others

2. **Service-Oriented Design**
   - Each major feature is a self-contained service
   - Services communicate through well-defined interfaces
   - Easy to add new services (e.g., `StatisticsService`, `ExportService`, `SyncService`)

3. **Repository Pattern**
   - Abstract data access behind repository interfaces
   - Easy to swap implementations (SQLite → cloud storage, etc.)
   - Centralized data access logic

4. **Provider/State Management**
   - Use Riverpod or Provider for state management
   - Each feature has its own provider
   - Providers can depend on other providers (composition)
   - Easy to add new stateful features

5. **Plugin/Extension Points**
   - Define interfaces for extensible features
   - Example: `AlertHandler` interface for different alert types
   - Example: `ExportFormat` interface for different export formats
   - Example: `ThemeProvider` interface for custom themes

#### Code Organization for Extensibility

```
lib/
├── core/                    # Core functionality (never changes)
│   ├── database/
│   │   ├── database.dart    # Database setup
│   │   ├── migrations/      # Database migrations
│   │   └── repositories/    # Repository interfaces
│   ├── models/              # Base models
│   ├── services/            # Core services
│   └── utils/               # Shared utilities
│
├── features/                # Feature modules (easily add new ones)
│   ├── bases/               # Base management feature
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   ├── alerts/              # Alert system feature
│   ├── characters/          # Character management
│   ├── servers/             # Server management
│   ├── settings/            # Settings feature
│   └── dashboard/           # Dashboard feature
│
├── shared/                  # Shared across features
│   ├── widgets/             # Reusable widgets
│   ├── theme/               # Theme system
│   └── constants/           # Shared constants
│
└── extensions/              # Future extensions (plugins)
    ├── statistics/          # Statistics feature (future)
    ├── export/              # Export feature (future)
    └── sync/                # Cloud sync (future)
```

#### Design Principles for Extensibility

1. **Open/Closed Principle**
   - Open for extension, closed for modification
   - Add new features by extending, not modifying existing code

2. **Dependency Injection**
   - Services depend on interfaces, not concrete implementations
   - Easy to swap implementations for testing or new features

3. **Interface Segregation**
   - Small, focused interfaces
   - Features only depend on what they need

4. **Single Responsibility**
   - Each class/service has one clear purpose
   - Easy to understand and modify

5. **Composition over Inheritance**
   - Build complex features by composing simple ones
   - More flexible than deep inheritance hierarchies

#### Database Extensibility

- **Migration System**: Versioned migrations for schema changes
- **JSON Columns**: Store flexible data for future features
- **Extension Tables**: New features can add their own tables without modifying core tables

```dart
// Example: Easy to add new fields via migrations
class Migration {
  static Future<void> addStatisticsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS base_statistics (
        id TEXT PRIMARY KEY,
        base_id TEXT,
        data TEXT,  -- JSON for flexible schema
        created_at INTEGER
      )
    ''');
  }
}
```

#### UI Extensibility

- **Widget Composition**: Build complex UIs from simple, reusable widgets
- **Theme System**: Centralized theme, easy to add new themes
- **Navigation**: Modular navigation, easy to add new screens
- **Plugin Widgets**: Define widget interfaces for extensible UI components

#### Adding New Features - Example Workflow

**Example: Adding a "Statistics" Feature**

1. Create feature directory: `lib/features/statistics/`
2. Add models: `lib/features/statistics/models/statistics_model.dart`
3. Add service: `lib/features/statistics/services/statistics_service.dart`
4. Add provider: `lib/features/statistics/providers/statistics_provider.dart`
5. Add screen: `lib/features/statistics/screens/statistics_screen.dart`
6. Add widgets: `lib/features/statistics/widgets/`
7. Register in navigation: Add route to main navigation
8. Database migration: Add statistics table if needed

**No modification to existing features required!**

#### Testing Strategy for Extensibility

- **Unit Tests**: Test each service/provider independently
- **Integration Tests**: Test feature interactions
- **Widget Tests**: Test UI components in isolation
- **Mock Interfaces**: Easy to mock dependencies for testing

#### Documentation for Extensibility

- **Architecture Documentation**: How the app is structured
- **Extension Guide**: How to add new features
- **API Documentation**: Documented interfaces and services
- **Code Comments**: Clear comments explaining design decisions

#### Future Extension Examples

1. **Statistics Dashboard**: Track power usage patterns
2. **Export/Import**: Multiple format support (JSON, CSV, Excel)
3. **Cloud Sync**: Sync data across devices
4. **API Integration**: If Dune Awakening adds an API later
5. **Custom Alerts**: User-defined alert conditions
6. **Widgets/Plugins**: Third-party extensions
7. **Multi-language Support**: i18n system
8. **Custom Themes**: User-created themes
9. **Backup/Restore**: Automated backups
10. **Analytics**: Usage analytics

### Data Model

```dart
// Dart/Flutter data models

class Server {
  final String id;
  final String name;
  final DateTime createdAt;
  
  Server({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class Character {
  final String id;
  final String name;
  final String serverId;
  final DateTime createdAt;
  
  Character({
    required this.id,
    required this.name,
    required this.serverId,
    required this.createdAt,
  });
}

class Base {
  final String id;
  final String characterId;
  final String name;
  final DateTime powerExpirationTime; // Manual entry
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Base({
    required this.id,
    required this.characterId,
    required this.name,
    required this.powerExpirationTime,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Alert {
  final String id;
  final String baseId;
  final DateTime triggeredAt;
  final bool acknowledged;
  
  Alert({
    required this.id,
    required this.baseId,
    required this.triggeredAt,
    required this.acknowledged,
  });
}

class AlertSettings {
  final List<int> warningThresholds; // e.g., [24, 12, 6, 1] hours
  final int checkIntervalMinutes; // How often to check (default: 1)
  final int repeatIntervalMinutes; // How often to repeat alerts (0 = once, >0 = repeat)
  final bool enableSound;
  final bool enableDesktopNotifications;
  final bool minimizeToTray;
  
  AlertSettings({
    this.warningThresholds = const [24], // Default: 24 hours
    this.checkIntervalMinutes = 1,
    this.repeatIntervalMinutes = 0, // Default: alert once
    this.enableSound = false,
    this.enableDesktopNotifications = true,
    this.minimizeToTray = true,
  });
}
```

### Data Storage
- **Local Storage**: SQLite database (via `sqflite` package for Flutter)
- **File Location**: 
  - Linux: `~/.config/dune-awakening-companion/`
  - Windows: `%APPDATA%/dune-awakening-companion/`
  - macOS: `~/Library/Application Support/dune-awakening-companion/`
  - Android: App-specific data directory
  - iOS: App-specific documents directory

### Alert System Architecture

1. **Background Service**: 
   - Check power expiration times at user-configured intervals (default: 1 minute)
   - Calculate time remaining for each base
   - Trigger alerts based on user-configured thresholds (default: 24 hours)
   - Support multiple thresholds (e.g., 24h, 12h, 6h, 1h warnings)

2. **Notification System**:
   - Desktop notifications (system tray integration)
   - Mobile push notifications (platform-specific)
   - In-app notification panel
   - Optional: Sound alerts (user-configurable)
   - Visual indicators (color-coded status)

3. **Alert Management**:
   - User-configurable alert thresholds (how many hours before expiration)
   - User-configurable repeat frequency (once, every X minutes, etc.)
   - Mark alerts as acknowledged
   - Dismiss alerts
   - Auto-dismiss when power is renewed/updated
   - Alert history/log

4. **System Tray Integration**:
   - Minimize to system tray (user-configurable)
   - Tray icon with status indicator (badge showing alert count)
   - Right-click menu: Show window, Quit
   - Click tray icon to restore window

## Application Structure (Flutter) - Extensible Architecture

```
dune-awakening-companion/
├── lib/
│   ├── main.dart                    # App entry point
│   │
│   ├── core/                        # Core functionality (stable)
│   │   ├── database/
│   │   │   ├── app_database.dart    # Database setup
│   │   │   ├── migrations/          # Versioned migrations
│   │   │   │   ├── migration_001_initial.dart
│   │   │   │   └── migration_002_add_statistics.dart  # Future
│   │   │   └── repositories/
│   │   │       ├── repository_interface.dart
│   │   │       └── base_repository.dart
│   │   ├── models/                  # Base models
│   │   │   └── base_model.dart      # Abstract base class
│   │   ├── services/
│   │   │   └── service_interface.dart
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── constants.dart
│   │
│   ├── features/                    # Feature modules (extensible)
│   │   ├── bases/
│   │   │   ├── models/
│   │   │   │   └── base.dart
│   │   │   ├── providers/
│   │   │   │   └── base_provider.dart
│   │   │   ├── services/
│   │   │   │   └── base_service.dart
│   │   │   ├── screens/
│   │   │   │   └── base_management_screen.dart
│   │   │   └── widgets/
│   │   │       ├── base_card.dart
│   │   │       └── base_list.dart
│   │   │
│   │   ├── alerts/
│   │   │   ├── models/
│   │   │   │   ├── alert.dart
│   │   │   │   └── alert_settings.dart
│   │   │   ├── providers/
│   │   │   │   └── alert_provider.dart
│   │   │   ├── services/
│   │   │   │   ├── alert_service.dart
│   │   │   │   ├── alert_handler_interface.dart  # Extensible
│   │   │   │   └── handlers/
│   │   │   │       ├── desktop_alert_handler.dart
│   │   │   │       └── mobile_alert_handler.dart
│   │   │   ├── screens/
│   │   │   │   └── alerts_screen.dart
│   │   │   └── widgets/
│   │   │       └── alert_panel.dart
│   │   │
│   │   ├── characters/
│   │   │   ├── models/character.dart
│   │   │   ├── providers/character_provider.dart
│   │   │   ├── services/character_service.dart
│   │   │   ├── screens/character_management_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── servers/
│   │   │   ├── models/server.dart
│   │   │   ├── providers/server_provider.dart
│   │   │   ├── services/server_service.dart
│   │   │   ├── screens/server_management_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── dashboard/
│   │   │   ├── providers/dashboard_provider.dart
│   │   │   ├── screens/dashboard_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── settings/
│   │   │   ├── models/settings.dart
│   │   │   ├── providers/settings_provider.dart
│   │   │   ├── services/settings_service.dart
│   │   │   ├── screens/settings_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   └── [future_features]/      # Easy to add new features
│   │       ├── statistics/          # Example: Future feature
│   │       ├── export/              # Example: Future feature
│   │       └── sync/                # Example: Future feature
│   │
│   ├── shared/                      # Shared across features
│   │   ├── widgets/
│   │   │   ├── time_remaining_indicator.dart
│   │   │   ├── status_badge.dart
│   │   │   └── common_button.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # Dune-inspired color scheme
│   │   │   ├── app_colors.dart
│   │   │   └── theme_provider.dart  # Extensible theme system
│   │   └── navigation/
│   │       └── app_router.dart      # Centralized routing
│   │
│   └── platform/                    # Platform-specific code
│       ├── notifications/
│       │   ├── notification_service.dart
│       │   ├── desktop_notifications.dart
│       │   └── mobile_notifications.dart
│       └── system_tray/
│           └── system_tray_service.dart
│
├── test/
│   ├── unit/                        # Unit tests
│   ├── integration/                 # Integration tests
│   └── widget/                      # Widget tests
│
├── android/                          # Android-specific config
├── ios/                              # iOS-specific config
├── linux/                            # Linux-specific config
├── windows/                          # Windows-specific config
├── macos/                            # macOS-specific config
├── pubspec.yaml                      # Dependencies
└── README.md
```

## UI/UX Design Considerations

### Design Principles
- **Modern & Clean**: Minimalist design with good spacing
- **Dune-Inspired Theme**: Desert/sand color palette (copyright-safe)
- **Dark Theme**: Default dark theme (easier on eyes, gaming aesthetic)
- **Color Coding** (Dune-inspired palette): 
  - **Safe** (> 24h): Deep sand/beige (#D4A574, #C9A961)
  - **Warning** (24-12h): Amber/golden (#E6B84F, #D4A574)
  - **Caution** (12-6h): Burnt orange/rust (#C97D60, #B85D47)
  - **Critical** (< 6h): Deep rust/terracotta (#A84D3A, #8B3A2A)
- **Responsive**: Works well on different screen sizes (desktop and mobile)

### Dune-Inspired Color Palette (Copyright-Safe)
- **Primary Background**: Deep desert night (#1A1612, #2B2419)
- **Secondary Background**: Sand dune (#3D3528, #4A4132)
- **Accent Colors**: 
  - Spice gold (#D4A574)
  - Desert amber (#E6B84F)
  - Rust orange (#C97D60)
  - Deep terracotta (#A84D3A)
- **Text**: Warm sand (#E8DCC8, #D4C4B0)
- **Borders**: Subtle sand (#5A4F3F)

### Main Views

1. **Dashboard View**
   - Overview of all bases
   - Quick status indicators
   - Upcoming alerts

2. **Base Management**
   - Add new base (character, server, expiration time)
   - Edit existing base
   - Delete base
   - Bulk operations

3. **Character/Server Management**
   - Add/edit characters
   - Add/edit servers
   - Organize bases by character/server

4. **Alerts View**
   - List of active alerts
   - Acknowledge/dismiss actions
   - Alert history

5. **Settings**
   - **Alert Configuration**:
     - Warning thresholds (multiple hours before expiration)
     - Check interval (how often to check for alerts)
     - Repeat interval (how often to repeat alerts, or "once only")
     - Enable/disable sound alerts
     - Enable/disable desktop notifications
   - **System Behavior**:
     - Minimize to system tray option
     - Auto-start on boot (optional)
   - **Theme settings** (light/dark, future: custom colors)
   - **Data Management**:
     - Export data to JSON/CSV
     - Import data
     - Clear all data
   - **About/help**

## Development Phases

### Phase 1: Foundation (Week 1)
- [ ] Set up Flutter project structure
- [ ] Configure for all target platforms (Linux, Windows, macOS, Android, iOS)
- [ ] Create database schema and migrations (SQLite)
- [ ] Implement basic CRUD operations for servers, characters, bases
- [ ] Set up state management (Riverpod or Provider)
- [ ] Basic UI layout and navigation
- [ ] Implement Dune-inspired theme/color scheme

### Phase 2: Core Features (Week 2)
- [ ] Implement alert checking logic with configurable thresholds
- [ ] Alert repeat frequency system
- [ ] Platform notification system (desktop + mobile)
- [ ] System tray integration (desktop platforms)
- [ ] Base management UI (add/edit/delete with manual expiration entry)
- [ ] Character/server management UI
- [ ] Time remaining calculations and display
- [ ] Settings screen with alert configuration

### Phase 3: Polish & Testing (Week 3)
- [ ] Alert panel UI with acknowledge/dismiss
- [ ] Complete settings panel (all configuration options)
- [ ] Data persistence testing
- [ ] Cross-platform testing (Linux, Windows, macOS, Mobile)
- [ ] System tray testing on all desktop platforms
- [ ] Notification testing on all platforms
- [ ] UI/UX refinements (Dune theme polish)
- [ ] Error handling and validation
- [ ] Manual testing of alert system with various configurations

### Phase 4: Enhancement (Future)
- [ ] Export/import functionality
- [ ] Statistics/analytics
- [ ] Sound alerts
- [ ] Customizable alert thresholds
- [ ] Auto-refresh mechanisms
- [ ] Mobile app development

## Key Features to Implement

### MVP Features
1. ✅ Add/edit/delete servers
2. ✅ Add/edit/delete characters
3. ✅ Add/edit/delete bases with **manual** power expiration entry
4. ✅ **Configurable** alert detection (user-defined thresholds)
5. ✅ **Configurable** alert repeat frequency
6. ✅ Platform notifications (desktop + mobile)
7. ✅ System tray integration (minimize to tray, quit option)
8. ✅ Visual status indicators (Dune-inspired color coding)
9. ✅ Time remaining display
10. ✅ Settings panel for alert configuration

### Nice-to-Have Features (Post-MVP)
- Export data to JSON/CSV
- Import data
- Statistics dashboard
- Sound alerts (user-configurable)
- Auto-start on boot
- Alert history/log
- Custom themes
- Cloud sync (future)

## Technical Considerations

### Performance
- Efficient database queries
- Minimal background checking (every 1-5 minutes)
- Lazy loading for large base lists
- **Extensibility**: Services are lazy-loaded, only initialize when needed

### Security
- Local data storage only (no cloud by default)
- Secure data encryption (optional, for sensitive data)
- **Extensibility**: Security layer can be extended without modifying core

### Accessibility
- Keyboard navigation
- Screen reader support
- High contrast mode option
- **Extensibility**: Accessibility features are modular and can be extended

### Maintainability & Extensibility
- **Modular Code**: Each feature is self-contained
- **Clear Interfaces**: Well-defined contracts between modules
- **Versioned Migrations**: Database schema evolves without breaking changes
- **Dependency Injection**: Easy to swap implementations
- **Comprehensive Tests**: Ensure extensions don't break existing features
- **Documentation**: Clear guides for adding new features

## Dependencies (Flutter)

### Core Packages
- `flutter` - Framework
- `sqflite` - SQLite database
- `path_provider` - File system paths
- `intl` - Date/time formatting
- `riverpod` or `provider` - State management
- `shared_preferences` - Settings storage

### Platform-Specific
- `flutter_local_notifications` - Local notifications (all platforms)
- `system_tray` - System tray integration (desktop)
- `window_manager` - Window management (desktop)
- `permission_handler` - Permissions (mobile)
- `workmanager` - Background tasks (mobile)

### UI/UX
- `flutter_svg` or `flutter_launcher_icons` - Icons
- Custom theme implementation (Dune-inspired colors)

## Next Steps

1. **✅ Technology Stack Confirmed**: Flutter for true cross-platform support
2. **Initialize Project**: Set up Flutter project with all platform configurations
3. **Database Design**: Create SQLite schema and migrations
4. **Theme Implementation**: Create Dune-inspired color scheme
5. **UI Components**: Build initial UI components with Dune theme
6. **Implement Core Logic**: Start with data models and CRUD operations
7. **Alert System**: Implement configurable alert checking and notifications
8. **System Tray**: Add system tray integration for desktop platforms

---

## Requirements Summary (Confirmed)

1. ✅ **Manual Entry**: Power expiration times entered manually (no API)
2. ✅ **Configurable Alerts**: User can set warning thresholds and repeat frequency
3. ✅ **Dune-Inspired Theme**: Desert/sand color palette (copyright-safe)
4. ✅ **System Tray**: Minimize to tray, user can quit
5. ✅ **Cross-Platform**: Linux, Windows, macOS, iOS, Android (single codebase with Flutter)

