# 🏜️ Dune Awakening Companion App - Handoff Document

**Date:** December 25, 2025  
**Version:** v1.0.3  
**Status:** Stable Release  

---

## 📋 Executive Summary

The Dune Awakening Companion App is a **feature-complete** cross-platform application for tracking character bases, power countdowns, and taxes in Dune Awakening. The v1.0.3 release adds comprehensive notification polish features.

### Key Achievements
- ✅ Multi-character & multi-base management
- ✅ Power countdown with visual alerts
- ✅ Tax tracking for Advanced Fiefs
- ✅ Export/Import data backups
- ✅ Character portraits
- ✅ Desktop system tray integration
- ✅ Mobile background notifications
- ✅ Multi-language support (EN, ES, FR, DE, UK, IT, CY)
- ✅ Automated CI/CD pipeline
- ✅ Quiet hours (Do Not Disturb)
- ✅ Sound/Vibration toggles
- ✅ Notification history with mark as read
- ✅ Tray icon alert badge

---

## 🏗️ Architecture Overview

### Technology Stack
| Component | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.38.5 | Cross-platform UI framework |
| Dart | 3.8.x | Programming language |
| Riverpod | 2.6.1 | State management |
| SQLite | sqflite 2.3.0 | Local database |
| intl | 0.20.2 | Internationalization |

### Project Structure
```
lib/
├── core/                    # Core services & infrastructure
│   ├── database/           # SQLite + migrations (v5)
│   ├── models/             # Core data models
│   ├── providers/          # Riverpod providers
│   ├── repositories/       # Data access layer
│   ├── services/           # Notifications, system tray, images
│   └── utils/              # Constants, helpers
├── features/               # Feature modules
│   ├── alerts/             # Alert system + notification history
│   ├── bases/              # Base management
│   ├── characters/         # Character management
│   ├── dashboard/          # Overview screen
│   └── settings/           # Export/import, preferences
├── l10n/                   # Localization
│   ├── app_en.arb          # English (source)
│   ├── app_*.arb           # Translations
│   └── app_localizations.dart  # Generated
├── shared/                 # Shared components
│   ├── navigation/         # Adaptive nav (desktop/mobile)
│   ├── theme/              # Dune-themed colors
│   └── widgets/            # Reusable UI components
└── main.dart               # Entry point
```

---

## 🌍 Internationalization (i18n)

### Supported Languages
| Code | Language | Status |
|------|----------|--------|
| `en` | English | ✅ Complete (source) |
| `es` | Spanish | ✅ Complete |
| `fr` | French | ✅ Complete |
| `de` | German | ✅ Complete |
| `uk` | Ukrainian | ✅ Complete |
| `it` | Italian | ✅ Complete |
| `cy` | Welsh | ✅ Complete |

### How It Works
1. **ARB Files:** Translations in `lib/l10n/app_*.arb`
2. **Generation:** `flutter gen-l10n` auto-generates Dart code
3. **Usage:** `AppLocalizations.of(context)!.keyName`
4. **Persistence:** Language saved via `SharedPreferences`
5. **Selector:** Settings screen dropdown

### Adding a New Language
1. Create `lib/l10n/app_XX.arb` (copy from `app_en.arb`)
2. Translate all strings
3. Add locale to `supportedLocales` in `main.dart`
4. Add to language selector in `settings_screen.dart`
5. Run `flutter gen-l10n`

---

## 🔧 Development Setup

### Prerequisites
- Flutter SDK 3.38.5+
- Dart 3.8+
- For Linux: `sudo apt install libsqlite3-dev libayatana-appindicator3-dev`
- For Android: Android SDK, Java 17

### Commands
```bash
# Get dependencies
flutter pub get

# Generate localization
flutter gen-l10n

# Generate JSON serialization (if models change)
dart run build_runner build --delete-conflicting-outputs

# Run (development)
flutter run -d linux

# Build (release)
flutter build linux --release
flutter build windows --release
flutter build macos --release
flutter build apk --release
```

---

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow
**File:** `.github/workflows/build-release.yml`

**Trigger:** Push tag matching `v*`

**Jobs:**
1. `build-linux` - Ubuntu, creates `.tar.gz`
2. `build-windows` - Windows, creates `.zip` with VC++ redistributable
3. `build-macos` - macOS, creates `.zip` with `.app`
4. `build-android` - Ubuntu, creates `.apk`
5. `release` - Creates GitHub Release with all artifacts

### Release Process
```bash
# 1. Make changes on main branch
git add . && git commit -m "feat: Your feature"

# 2. Bump version in pubspec.yaml and settings_screen.dart

# 3. Create release notes
# Create RELEASE_NOTES_vX.X.X.md

# 4. Tag and push
git tag vX.X.X
git push origin main --tags

# 5. Wait for CI (8-10 min)
# 6. Release appears at https://github.com/StarTuz/dune-awakening-companion/releases

# 7. Optional: Upload sound pack manually to release
```

### Important: Release Notes
The workflow expects `RELEASE_NOTES_vX.X.X.md` to exist for the tag being released.

---

## 📦 Key Dependencies

### Production
| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | 2.6.1 | State management |
| sqflite | 2.3.0 | SQLite (mobile) |
| sqflite_common_ffi | 2.3.0+1 | SQLite (desktop) |
| flutter_local_notifications | 19.0.0 | Notifications |
| system_tray | 2.0.3 | System tray (Linux) |
| tray_manager | 0.5.2 | System tray (Windows/macOS) |
| window_manager | 0.3.9 | Window control |
| file_picker | 8.0.0 | File dialogs |
| workmanager | 0.6.0 | Background tasks (mobile) |
| flutter_localizations | SDK | i18n support |
| intl | 0.20.2 | Date/number formatting |
| shared_preferences | 2.2.2 | Settings persistence |

### Dev
| Package | Version | Purpose |
|---------|---------|---------|
| build_runner | 2.4.13 | Code generation |
| json_serializable | 6.8.0 | JSON serialization |

---

## 💾 Database

### Version: 5

### Tables
- `characters` - id, name, region, serverType, serverName, sietch, portraitPath
- `bases` - id, characterId, name, powerExpiresAt, isAdvancedFief, taxPerCycle, etc.
- `notification_history` - id, type, title, body, baseId, baseName, severity, sentAt, read

### Migrations
Located in `lib/core/database/migrations/`
- `migration_001_*` - Initial schema
- `migration_002_*` - Add serverType
- `migration_003_*` - Add tax fields
- `migration_004_*` - Add portraitPath
- `migration_005_*` - Add notification_history table

---

## 🔔 Notification System

### Features
| Feature | Description |
|---------|-------------|
| **Quiet Hours** | Customizable DND period (default: 10 PM - 8 AM) |
| **Sound Toggle** | Enable/disable notification sounds |
| **Vibration Toggle** | Enable/disable vibration (mobile) |
| **History** | View past notifications, mark as read |
| **Tray Badge** | Alert count in tooltip and menu |

### Desktop
- **Timer-based:** Checks every 15/30/60 minutes (configurable)
- **System Tray:** Right-click menu with Show/Check/Toggle/Quit
- **Close to tray:** Window close minimizes, doesn't quit

### Mobile
- **WorkManager:** Background periodic tasks
- **Push notifications:** Via `flutter_local_notifications`

### Notification Channels
- `critical_alerts` - Power < 24h or tax defaulted
- `warning_alerts` - Power < 48h or tax overdue
- `app_messages` - General notifications

### Settings Persistence
All notification settings stored in `SharedPreferences`:
- `notifications_enabled`
- `notification_interval_minutes`
- `notifications_include_warnings`
- `start_minimized_to_tray`
- `quiet_hours_enabled`
- `quiet_hours_start` / `quiet_hours_end`
- `notification_sound_enabled`
- `notification_vibration_enabled`

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, initialization, MaterialApp |
| `lib/core/database/app_database.dart` | SQLite setup + migrations |
| `lib/core/services/notification_coordinator.dart` | Alert checking & notification dispatch |
| `lib/core/services/notification_settings.dart` | Settings persistence layer |
| `lib/core/providers/notification_settings_provider.dart` | Settings state management |
| `lib/features/alerts/screens/alerts_screen.dart` | Alerts UI + history button |
| `lib/features/alerts/widgets/notification_history_widget.dart` | History list UI |
| `lib/features/settings/screens/settings_screen.dart` | Settings UI + toggles |
| `lib/core/providers/language_provider.dart` | Language state management |
| `l10n.yaml` | Localization configuration |
| `.github/workflows/build-release.yml` | CI/CD pipeline |

---

## 🐛 Known Issues

1. **Linux tooltip** - System tray tooltip not supported (gracefully handled)
2. **file_picker warnings** - Benign warnings about inline implementations
3. **libayatana deprecated** - Warning about deprecated API (functional)

---

## 📝 Documentation Index

| Document | Description |
|----------|-------------|
| `README.md` | User-facing README |
| `NEXT_STEPS.md` | Development roadmap |
| `FAQ.md` | Frequently asked questions |
| `QUICK_START.md` | Developer quick start |
| `EXTENSIBILITY_GUIDE.md` | How to add features |
| `COLOR_SCHEME.md` | Dune theme colors |
| `SECURITY_AUDIT.md` | Security review |
| `SETUP.md` | Detailed setup instructions |
| `docs/CUSTOM_SOUNDS.md` | Custom notification sounds guide |

---

## 🎯 Future Roadmap (v1.1+)

### Polish Items
- [x] Custom notification sounds (Sound on/off, Vibration on/off) ✅
- [x] Quiet hours (customizable) ✅
- [ ] Per-base notification overrides
- [x] Notification history ✅
- [x] Tray icon badge with alert count ✅

### Major Features
- [ ] **Quest Journal** - Track multi-step quests with notes
- [ ] **Theme Customization** - Multiple Dune-inspired themes
- [ ] **Dashboard Charts** - Analytics and visualizations

---

## 🎵 Optional Sound Pack

Available as separate download: `dune-sound-pack-v1.0.zip`

Contains 10 Dune-themed notification sounds:
- **Atreides** - Noble, dignified
- **Fremen** - Mystical, desert winds
- **Harkonnen** - Dark, industrial
- **Shai-Hulud** - Deep, ominous
- **Smugglers** - Gritty, underworld

See `docs/CUSTOM_SOUNDS.md` for installation instructions.

---

## 👥 Contact & Repository

- **Repository:** https://github.com/StarTuz/dune-awakening-companion
- **Releases:** https://github.com/StarTuz/dune-awakening-companion/releases
- **Issues:** https://github.com/StarTuz/dune-awakening-companion/issues

---

*Generated December 25, 2025*
