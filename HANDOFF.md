# 🏜️ Dune Awakening Companion App - Handoff Document

**Date:** June 5, 2026  
**Version:** v1.3.0-beta (main; Base Calculator Phases 1–5 on branch)  
**Database:** v16  
**Status:** Release candidate — documentation sync for calculator, chronicle, and blueprints expansion  

---

## 📋 Executive Summary

The Dune Awakening Companion App is a **feature-complete** cross-platform application for tracking character bases, power countdowns, quest progress, and Chapter 3 progression systems in Dune Awakening.

### Key Achievements
- ✅ Multi-character & multi-base management
- ✅ Power countdown with visual alerts
- ✅ Export/Import data backups
- ✅ Character portraits
- ✅ Desktop system tray integration
- ✅ Mobile background notifications
- ✅ Full Multi-language support (EN, ES, FR, DE, UK, IT, CY) with zero missing keys
- ✅ Automated CI/CD pipeline
- ✅ Quiet hours (Do Not Disturb)
- ✅ Sound/Vibration toggles
- ✅ Notification history with mark as read
- ✅ Tray icon alert badge
- ✅ Android UI Layout Fixes (Text Weight)
- ✅ Quest Journal with steps and reminders
- ✅ Specialization, faction progress, and augmentation tracking
- ✅ Dashboard charts and analytics
- ✅ Per-base notification overrides
- ✅ Hagga Basin South blueprint/schematic tracker
- ✅ Multi-region blueprint catalogs, filters, respawn timers
- ✅ Class quests and skill planner
- ✅ Character Chronicle (RPG journal with markdown, screenshots)
- ✅ **Base Calculator** (build planner: power/materials, saved plans, share codes, optimization helpers)

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
│   ├── database/           # SQLite + migrations (v16)
│   ├── models/             # Core data models
│   ├── providers/          # Riverpod providers
│   ├── repositories/       # Data access layer
│   ├── services/           # Notifications, system tray, images
│   └── utils/              # Constants, helpers
├── features/               # Feature modules
│   ├── alerts/             # Alert system + notification history
│   ├── bases/              # Base management
│   ├── characters/         # Character management
│   ├── dashboard/          # Overview screen + charts
│   ├── base_calculator/    # Build planner (power, materials, plans, share)
│   ├── journal/            # Character Chronicle (RPG journal)
│   ├── skills/             # Skill rank planner
│   ├── class_quests/       # Trainer quest paths
│   ├── blueprints/         # Blueprint and schematic tracker
│   ├── quest_journal/      # Quest and step tracking
│   ├── specializations/    # Chapter 3 specialization progress
│   ├── factions/           # Faction rank tracking
│   ├── augmentations/      # Augmentation tracker
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
5. `release` - Creates GitHub Release with all artifacts + SHA-256 checksums

### Pull Request Workflow
**File:** `.github/workflows/ci.yml`

**Trigger:** Pull requests and manual dispatch

**Checks:**
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- Dependency report (`scripts/ci/deps_audit.sh`)
- `flutter test --coverage` with 15% threshold enforcement
- Coverage summary
- Code metrics (`scripts/ci/metrics.sh`) — informational, non-blocking
- SBOM generation (`scripts/ci/sbom.sh`)
- `flutter build linux --debug`

### Qodo Merge Review (Required)
Qodo Merge (PR-Agent) runs automatically on PR open via `.pr_agent.toml`
(`/describe`, `/review`, `/improve`). Every PR must include:

- A link to the Qodo review output in the PR description or comments
- Applied suggestions or a brief rationale for deferring them
- Any added user-facing strings must be localized (ARB + `flutter gen-l10n`)

### Git Pre-Commit Hook
**Files:** `scripts/git/pre-commit`, `scripts/git/install-hooks.sh`

Auto-formats staged Dart files on every commit to prevent formatting drift
(especially from merges, AI tools, and terminal edits that bypass IDE
format-on-save). Install once after cloning:
```bash
bash scripts/git/install-hooks.sh
```

### Local CI (Parity Script)
**File:** `scripts/ci/local.sh`

Run the same checks locally:
```bash
bash scripts/ci/local.sh
```

### Performance Regression Check
**File:** `scripts/ci/perf_baseline.sh`

Capture baselines and compare future runs:
```bash
# Save a baseline
bash scripts/ci/perf_baseline.sh --save

# Compare against baseline (fails if >25% regression)
bash scripts/ci/perf_baseline.sh
```

### Release Signing
See `docs/SIGNING_GUIDE.md` for Android, macOS, Windows, and Linux.

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

### Version: 16

### Core tables (non-exhaustive)
- `characters`, `bases`, `servers` — core tracking
- `notification_history` — alert history
- `quests`, `quest_steps` — quest journal
- `character_specializations`, `faction_progress`, `augmentations` — Chapter 3 progression
- `blueprints` — per-character schematic progress
- `character_class_quests`, `character_class_quest_steps`, `character_skills` — class progression
- `journal_entries` — Character Chronicle
- `base_calculator_plans` — saved Base Calculator builds (migration 016)

### Migrations
Located in `lib/core/database/migrations/` (001–016). Bump `version:` in
`lib/core/database/app_database.dart` when adding a migration.

Legacy note: migration_003 tax columns remain nullable but are unused (Chapter 3
removed in-game taxes).

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
- `critical_alerts` - Power < 24h
- `warning_alerts` - Power < 48h
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
| `docs/CHAPTER3_RESEARCH.md` | Chapter 3 patch research & impact |
| `docs/ENGINEERING_HOUSEKEEPING.md` | Engineering assessment & gaps |
| `docs/ENGINEERING_TASKLIST.md` | Concrete engineering task list |
| `docs/ROADMAP_2026.md` | Phased engineering + product roadmap |
| `docs/RESEARCH_BASE_CALCULATOR.md` | Base Calculator phases, catalog sourcing, fuel rates |
| `docs/RESEARCH_RPG_JOURNAL_NOTES.md` | Character Chronicle design |
| `docs/SIGNING_GUIDE.md` | Release signing for all platforms |
| `docs/RELEASE_CHECKLIST.md` | Pre-release checklist |
| `docs/RELEASE_NOTES_TEMPLATE.md` | Standardized release notes template |
| `docs/SECURITY_CHECKLIST.md` | Ongoing security review checklist |

---

## 🎯 Future Roadmap

Most v1.1–v1.3 items below are **shipped**. See `README.md` roadmap and
`docs/ROADMAP_2026.md` for current priorities (Hagga map research, catalog
validation, optional cloud sync).

### Polish Items — complete
- [x] Custom notification sounds ✅
- [x] Quiet hours ✅
- [x] Per-base notification overrides ✅
- [x] Notification history ✅
- [x] Tray icon badge ✅

### Major Features — complete on `main`
- [x] Quest Journal ✅
- [x] Theme customization ✅
- [x] Dashboard charts ✅
- [x] Base Calculator ✅
- [x] Character Chronicle ✅

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

*Last updated June 5, 2026*
