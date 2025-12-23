# Dune Awakening Companion App - Handoff Document

**Date:** December 22, 2024  
**Status:** v1.0.5-beta RELEASED - Cross-platform desktop builds available
**Repository:** https://github.com/StarTuz/dune-awakening-companion

---

## 🚀 RELEASE STATUS

### Latest Release: v1.0.5-beta

**Download:** [GitHub Releases](https://github.com/StarTuz/dune-awakening-companion/releases/tag/v1.0.5-beta)

| Platform | Status | File |
|----------|--------|------|
| 🐧 **Linux x64** | ✅ Tested | `dune-awakening-companion-v1.0.5-beta-linux-x64.tar.gz` |
| 🪟 **Windows x64** | ⚠️ Untested | `dune-awakening-companion-v1.0.5-beta-windows-x64.zip` |
| 🍎 **macOS** | ⚠️ Untested | `dune-awakening-companion-v1.0.5-beta-macos.zip` |
| 🤖 **Android** | ❌ Disabled | SDK 35 compatibility issue with flutter_local_notifications |

### CI/CD Pipeline ✅ WORKING

Automated GitHub Actions workflow that:
- Triggers on version tags (`v*`)
- Builds Linux, Windows, macOS in parallel
- Creates GitHub Release with attached binaries
- Marks beta/alpha releases as pre-release

**Workflow:** `.github/workflows/build-release.yml`

---

## 📱 Application Overview

The Dune Awakening Companion App is a cross-platform Flutter application designed to help players manage their characters, bases, and power countdown timers across multiple Dune Awakening servers.

### Key Features Implemented

✅ **Multi-Character Management**
- Track unlimited characters across regions and servers
- Support for Official servers (227 worlds across 5 regions)
- Support for Private servers (5 major hosting providers)
- Full character context: Region, World, Sietch

✅ **Unlimited Base Tracking per Character**
- Each character can have unlimited bases
- Individual power countdown per base (Days/Hours/Minutes format)
- Color-coded status indicators:
  - 🔴 Red: < 6 hours (Critical)
  - 🟡 Yellow: < 24 hours (Warning)
  - 🟢 Green: > 24 hours (Safe)

✅ **Tax Tracking for Advanced Fiefs**
- Tax Per Cycle with built-in calculator
- Smart Auto-Increment for missed tax cycles
- Separate tracking for Current/Overdue/Defaulted
- Status badges: PAID / DUE / OVERDUE / DEFAULTED

✅ **Smart Alert System**
- Automatic alerts for bases expiring in < 48 hours
- Visual alert icon with badge count and color
- Detailed alerts screen with severity and countdown
- One-tap navigation to manage bases

✅ **Notifications & System Tray** ⭐ FIXED!
- Cross-platform notification service (Desktop + Mobile)
- System tray icon with right-click menu
- Window close → Minimize to tray
- **State sync between tray toggle and Settings UI** ✅ FIXED!
- Configurable check intervals (15/30/60 min)

✅ **Data Management (Export/Import)**
- Export all data to JSON backup files
- Import from backups with Merge or Replace options
- Custom save/load locations via file picker
- Platform-agnostic

✅ **Character Portraits**
- Add custom portraits to characters
- Auto-resize to 512×512
- CircleAvatar display in character list
- Automatic cleanup on character delete

✅ **Adaptive Navigation**
- Desktop: NavigationRail (side panel)
- Mobile: BottomNavigationBar

✅ **Database with Migrations**
- SQLite with proper migration system
- Version 4 schema
- Desktop (FFI) and mobile compatibility

---

## 🔧 Session Work Completed (December 22, 2024)

### Bug Fixes

#### 1. Notification Toggle State Sync (HIGH PRIORITY) ✅ FIXED

**Problem:** When toggling notifications via the system tray menu, the Settings UI switch did not update to reflect the change (and vice-versa).

**Root Cause:** The `_NotificationSettingsWidget` in `settings_screen.dart` was a `StatefulWidget` maintaining its own local state, initialized only once in `initState()`. Changes from the system tray directly updated `SharedPreferences` but didn't trigger a UI rebuild.

**Solution:** Implemented a Riverpod `StateNotifierProvider` as a single source of truth.

**Files Created/Modified:**
- **NEW:** `lib/core/providers/notification_settings_provider.dart`
  - `NotificationSettingsState` - holds state
  - `NotificationSettingsNotifier` - manages state and persists to SharedPreferences
  - `notificationSettingsProvider` - the provider instance

- **MODIFIED:** `lib/features/settings/screens/settings_screen.dart`
  - Converted `_NotificationSettingsWidget` from `StatefulWidget` to `ConsumerWidget`
  - Now uses `ref.watch(notificationSettingsProvider)` for state
  - Removed unused `notification_settings.dart` import

- **MODIFIED:** `lib/main.dart`
  - Added global `ProviderContainer` for system tray access
  - Updated `onToggleNotifications` callback to use provider
  - Uses `UncontrolledProviderScope` to link widget tree

#### 2. "Notifications Disabled" Popup Disappearing ✅ FIXED

**Problem:** When disabling notifications via system tray, the feedback notification appeared briefly then vanished.

**Root Cause:** `NotificationService.setNotificationsEnabled(false)` calls `cancelAllNotifications()`. The feedback was shown *before* the manager updated, causing immediate cancellation.

**Solution:** Reordered logic in `main.dart` to call `manager.updateSettings()` first, then show feedback notification.

### CI/CD Pipeline Implementation

Created automated cross-platform build pipeline:

#### Workflow: `.github/workflows/build-release.yml`

**Features:**
- Triggers on version tags (`v*`)
- Manual trigger via `workflow_dispatch`
- Parallel builds for Linux, Windows, macOS
- Code generation step (`build_runner`)
- Creates GitHub Release with binaries

**Issues Resolved:**

| Issue | Resolution |
|-------|------------|
| Missing platform configs | `flutter create --platforms=android,windows,macos .` |
| Missing `.g.dart` files | Added `dart run build_runner build` step |
| Linux missing system_tray deps | Added `libayatana-appindicator3-dev` to apt install |
| Flutter 3.24 vs 3.27 API | Changed `CardThemeData` → `CardTheme`, `DialogThemeData` → `DialogTheme` |
| Linux `fl_view_set_background_color` | Removed (3.27+ only API) |
| Android SDK 35 conflict | Temporarily disabled Android build |

### Documentation Updates

- **README.md:** Complete rewrite with all v1.0-beta features
- **RELEASE_NOTES_v1.0.0-beta.md:** Initial release notes
- **RELEASE_NOTES_v1.0.5-beta.md:** Cross-platform release notes
- Updated roadmap: Replaced "Multi-Account Support" with "Character Sorting"

### Git History

```
efa08bb docs: Add v1.0.5-beta release notes
2f45e3c fix(ci): Flutter 3.24 compatibility for Linux, disable Android
3fbc0d8 fix: Flutter 3.24 compatibility and Android SDK version
6887ef7 fix(ci): Add build_runner step to generate .g.dart files
00b51d3 fix: Add missing platform configs and fix CI dependencies
ab8d041 docs: Add v1.0.1-beta release notes for CI/CD test
3ba331f ci: Add GitHub Actions workflow for cross-platform builds
a42cb02 docs: Replace Multi-Account with Character Sorting in roadmap
ebccb38 docs: Update README with complete v1.0-beta feature list
30ab665 v1.0.0-beta: Complete app with notification sync fix
```

---

## 🏗️ Architecture

### Directory Structure

```
lib/
├── core/
│   ├── database/
│   │   ├── app_database.dart          # Database initialization
│   │   └── migrations/
│   │       ├── migration_001_initial.dart
│   │       ├── migration_002_add_server_fields.dart
│   │       ├── migration_003_add_tax_fields.dart
│   │       └── migration_004_add_portraits.dart
│   ├── providers/
│   │   ├── notification_settings_provider.dart  # ⭐ NEW!
│   │   ├── notification_provider.dart
│   │   ├── notification_manager_provider.dart
│   │   └── ...
│   ├── services/
│   │   ├── notification_service.dart
│   │   ├── notification_manager.dart
│   │   ├── system_tray_service.dart
│   │   └── image_service.dart
│   └── utils/
│       └── constants.dart
├── features/
│   ├── characters/
│   ├── bases/
│   ├── alerts/
│   ├── dashboard/
│   └── settings/
│       ├── providers/import_export_provider.dart
│       ├── services/
│       │   ├── export_service.dart
│       │   └── import_service.dart
│       └── screens/settings_screen.dart
└── shared/
    ├── navigation/main_navigation.dart
    └── theme/
        ├── app_colors.dart
        └── app_theme.dart
```

### Key Design Decisions

#### Centralized Notification State

```dart
// lib/core/providers/notification_settings_provider.dart
class NotificationSettingsState {
  final bool enabled;
  final int intervalMinutes;
  final bool includeWarnings;
  final bool startMinimized;
  final bool isLoading;
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsState> {
  // Manages state and persists to SharedPreferences
  Future<void> setEnabled(bool enabled) async {
    await NotificationSettings.setNotificationsEnabled(enabled);
    state = state.copyWith(enabled: enabled);
  }
}
```

#### Global ProviderContainer for System Tray

```dart
// lib/main.dart
late final ProviderContainer globalContainer;

void main() async {
  globalContainer = ProviderContainer();
  // ... initialization
  runApp(UncontrolledProviderScope(
    container: globalContainer,
    child: const DuneAwakeningCompanionApp(),
  ));
}

// In system tray callback:
onToggleNotifications: () async {
  final currentState = globalContainer.read(notificationSettingsProvider);
  final newState = !currentState.enabled;
  globalContainer.read(notificationSettingsProvider.notifier).setEnabled(newState);
  // UI updates automatically!
}
```

---

## 🎯 Roadmap Status

### ✅ Completed (v1.0.5-beta)

| Feature | Status |
|---------|--------|
| Multi-character management | ✅ Complete |
| Unlimited base tracking | ✅ Complete |
| Power countdown (D/H/M) | ✅ Complete |
| Tax tracking + auto-increment | ✅ Complete |
| Character portraits | ✅ Complete |
| Export/Import (JSON) | ✅ Complete |
| Alert system | ✅ Complete |
| Notifications & System Tray | ✅ Complete |
| Tray ↔ Settings state sync | ✅ Fixed |
| Dashboard statistics | ✅ Complete |
| Adaptive navigation | ✅ Complete |
| Database v4 + migrations | ✅ Complete |
| Linux release | ✅ Tested |
| Windows release | ✅ Built (Untested) |
| macOS release | ✅ Built (Untested) |
| CI/CD pipeline | ✅ Working |

### 🚧 In Progress / Pending

| Feature | Status | Notes |
|---------|--------|-------|
| Android build | ❌ Blocked | `flutter_local_notifications` SDK 35 issue |
| Multi-language (i18n) | 📋 Planned | Next major feature |
| Windows testing | ⚠️ Untested | Needs Windows machine |
| macOS testing | ⚠️ Untested | Needs Mac |

### 📋 Future Features

| Feature | Priority |
|---------|----------|
| Character Sorting | Medium |
| Quest Journal | Low |
| Theme Customization | Low |
| Dashboard Charts | Low |
| Cloud Sync | Low |

---

## 🧪 Testing Status

### Platform Testing

| Platform | Build | Run | Features | Notes |
|----------|-------|-----|----------|-------|
| 🐧 Linux | ✅ | ✅ | ✅ | Fully tested |
| 🪟 Windows | ✅ | ⚠️ | ⚠️ | Build successful, needs Windows testing |
| 🍎 macOS | ✅ | ⚠️ | ⚠️ | Build successful, needs Mac testing |
| 🤖 Android | ❌ | ❌ | ❌ | SDK 35 compatibility issue |

### Wine Testing (Windows build on Linux)

- **Result:** Executable runs but no window displays
- **Cause:** Flutter uses DirectX/ANGLE for rendering, Wine can't handle it
- **Conclusion:** Windows build is valid, just needs actual Windows to test

### Feature Testing Checklist

- [x] Add/Edit/Delete characters
- [x] Add/Edit/Delete bases
- [x] Power countdown updates
- [x] Tax auto-increment
- [x] Alerts show correct bases
- [x] Dashboard counts accurate
- [x] Export to JSON
- [x] Import with Merge/Replace
- [x] Character portraits
- [x] System tray integration
- [x] Notification toggle sync ⭐ Fixed this session
- [x] Minimize to tray
- [ ] Windows full test
- [ ] macOS full test
- [ ] Android test (blocked)

---

## 🐛 Known Issues

### Current Issues

| Issue | Severity | Status |
|-------|----------|--------|
| Linux tray tooltip not supported | Low | Gracefully handled |
| Windows/macOS untested | Medium | Need testers |
| Android build disabled | Medium | Package compatibility issue |

### Resolved This Session

| Issue | Resolution |
|-------|------------|
| Tray notification toggle not syncing with UI | Riverpod StateNotifierProvider |
| "Notifications Disabled" popup disappearing | Reordered notification/update calls |
| Flutter 3.24 API compatibility | Changed CardThemeData/DialogThemeData |
| Missing .g.dart files in CI | Added build_runner step |

---

## 🚀 Release Process

### Creating a New Release

1. **Update version** in `pubspec.yaml`
2. **Create release notes:** `RELEASE_NOTES_vX.Y.Z-beta.md`
3. **Commit and push:**
   ```bash
   git add -A
   git commit -m "release: vX.Y.Z-beta"
   git push origin Beta
   ```
4. **Create and push tag:**
   ```bash
   git tag -a vX.Y.Z-beta -m "vX.Y.Z-beta: Description"
   git push origin vX.Y.Z-beta
   ```
5. **Wait for CI** (~5-7 minutes)
6. **Check release:** https://github.com/StarTuz/dune-awakening-companion/releases

### CI/CD Configuration

**File:** `.github/workflows/build-release.yml`

```yaml
# Triggers
on:
  push:
    tags: ['v*']
  workflow_dispatch:

# Jobs
jobs:
  build-linux:    # Ubuntu, tarball
  build-windows:  # Windows, zip
  build-macos:    # macOS, zip (.app bundle)
  release:        # Creates GitHub Release
```

---

## 📦 Dependencies

### Core
- `flutter: sdk`
- `flutter_riverpod: ^2.6.1`
- `riverpod_annotation: ^2.6.1`

### Database
- `sqflite: ^2.3.0`
- `sqflite_common_ffi: ^2.3.0`
- `path: ^1.8.3`
- `path_provider: ^2.1.1`

### Notifications & System Tray
- `flutter_local_notifications: ^16.3.3`
- `system_tray: (platform integration)`
- `tray_manager: ^0.2.4`
- `window_manager: ^0.3.9`
- `workmanager: ^0.5.2` (mobile background)

### Utilities
- `uuid: ^4.2.2`
- `intl: ^0.18.1`
- `json_annotation: ^4.8.1`
- `file_picker: ^6.2.1`
- `image: (for portraits)`
- `shared_preferences: (for settings)`

### Dev Dependencies
- `build_runner: ^2.4.6`
- `json_serializable: ^6.8.0`
- `riverpod_generator: ^2.4.0`

---

## 🏃 Running the Application

### Development
```bash
# Install dependencies
flutter pub get

# Generate code (models, providers)
dart run build_runner build --delete-conflicting-outputs

# Run on desktop (Linux)
flutter run -d linux

# Run on mobile (Android) - currently broken
# flutter run -d android
```

### Production Build
```bash
# Linux
flutter build linux --release
# Output: build/linux/x64/release/bundle/

# Windows (requires Windows machine)
flutter build windows --release

# macOS (requires Mac)
flutter build macos --release
```

---

## 📞 Contact & Support

**Repository:** https://github.com/StarTuz/dune-awakening-companion

**Development Stack:**
- Flutter (Dart)
- Riverpod for state management
- SQLite for data persistence
- Google Antigravity IDE + Claude Sonnet 4.5

**Legal:**
- Unofficial fan project
- No Funcom affiliation
- MIT License
- Use at your own risk

---

**Last Updated:** December 22, 2024  
**Version:** 1.0.5-beta  
**Build:** Database v4, Full Feature Set, CI/CD Pipeline

---

**🌟 May your power stay charged and your taxes stay paid! 🌟**
