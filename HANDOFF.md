# 🏜️ Dune Awakening Companion App - Handoff Document

**Date:** December 24, 2025  
**Version:** v1.0.2  
**Status:** Stable Release  

---

## 📋 Executive Summary

The Dune Awakening Companion App is a **feature-complete** cross-platform application for tracking character bases, power countdowns, and taxes in Dune Awakening. The v1.0.2 release includes multi-language support for 7 languages.

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

---

## 🏗️ Architecture Overview

### Technology Stack
| Component | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.38.5 | Cross-platform UI framework |
| Dart | 3.10.4 | Programming language |
| Riverpod | 2.6.1 | State management |
| SQLite | sqflite 2.3.0 | Local database |
| intl | 0.20.2 | Internationalization |

### Project Structure
```
lib/
├── core/                    # Core services & infrastructure
│   ├── database/           # SQLite + migrations (v4)
│   ├── providers/          # Riverpod providers
│   ├── services/           # Notifications, system tray, images
│   └── utils/              # Constants, helpers
├── features/               # Feature modules
│   ├── alerts/             # Alert system
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
- Dart 3.10+
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
# 1. Make changes on Beta branch
git checkout Beta
# ... make changes ...
git add . && git commit -m "feat: Your feature"

# 2. Tag and push
git tag v1.0.X
git checkout main && git merge Beta
git push origin main Beta --tags

# 3. Wait for CI (8-10 min)
# 4. Release appears at https://github.com/StarTuz/dune-awakening-companion/releases
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

### Dev
| Package | Version | Purpose |
|---------|---------|---------|
| build_runner | 2.4.13 | Code generation |
| json_serializable | 6.8.0 | JSON serialization |

---

## 💾 Database

### Version: 4

### Tables
- `characters` - id, name, region, serverType, serverName, sietch, portraitPath
- `bases` - id, characterId, name, powerExpiresAt, isAdvancedFief, taxPerCycle, etc.

### Migrations
Located in `lib/core/database/migrations/`
- `migration_001_*` - Initial schema
- `migration_002_*` - Add serverType
- `migration_003_*` - Add tax fields
- `migration_004_*` - Add portraitPath

---

## 🔔 Notification System

### Desktop
- **Timer-based:** Checks every 15/30/60 minutes (configurable)
- **System Tray:** Right-click menu with Show/Check/Toggle/Quit
- **Close to tray:** Window close minimizes, doesn't quit

### Mobile
- **WorkManager:** Background periodic tasks
- **Push notifications:** Via `flutter_local_notifications`

### Channels
- `critical_alerts` - Power < 24h or tax defaulted
- `warning_alerts` - Power < 48h or tax overdue
- `app_messages` - General notifications

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, initialization, MaterialApp |
| `lib/core/database/app_database.dart` | SQLite setup + migrations |
| `lib/features/settings/screens/settings_screen.dart` | Settings UI + language selector |
| `lib/core/providers/language_provider.dart` | Language state management |
| `l10n.yaml` | Localization configuration |
| `.github/workflows/build-release.yml` | CI/CD pipeline |
| `linux/CMakeLists.txt` | Linux build config |

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

---

## 🎯 Future Roadmap (v1.1+)

### Polish Items
- [ ] Custom notification sounds
- [ ] Quiet hours (10 PM - 8 AM)
- [ ] Per-base notification overrides
- [ ] Notification history
- [ ] Tray icon badge with alert count

### Major Features
- [ ] **Quest Journal** - Track multi-step quests with notes
- [ ] **Theme Customization** - Multiple Dune-inspired themes
- [ ] **Dashboard Charts** - Analytics and visualizations

---

## 👥 Contact & Repository

- **Repository:** https://github.com/StarTuz/dune-awakening-companion
- **Releases:** https://github.com/StarTuz/dune-awakening-companion/releases
- **Issues:** https://github.com/StarTuz/dune-awakening-companion/issues

---

*Generated December 24, 2025*
