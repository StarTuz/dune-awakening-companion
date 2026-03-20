# Setup Guide - Dune Awakening Companion App

## Current Setup Status ✅

The project is actively implemented and uses a feature-based architecture with SQLite migrations, Riverpod state management, and generated JSON serialization.

### ✅ Completed

1. **Project Structure**: Full directory tree with feature-based architecture
2. **Dependencies**: `pubspec.yaml` with all required packages
3. **Data Models**: Server, Character, Base, Alert, AlertSettings
4. **Database**: SQLite schema with migrations system
5. **Theme**: Complete Dune-inspired color scheme
6. **Navigation**: Adaptive desktop/mobile navigation
7. **Core Utilities**: Date formatting, constants
8. **Feature Modules**: Quest journal, specializations, faction progress, and augmentations

## Next Steps

### 1. Install Flutter (if not already installed)

On Garuda/Arch Linux:
```bash
# Install Flutter
sudo pacman -S flutter

# Or use AUR
yay -S flutter
```

Verify installation:
```bash
flutter --version
flutter doctor
```

### 2. Get Dependencies

```bash
cd "/home/startux/code/Dune Awakening Companion App."
flutter pub get
```

### 3. Generate Code

The models use JSON serialization, so you need to generate the code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `server.g.dart`
- `character.g.dart`
- `base.g.dart`
- `alert.g.dart`
- `alert_settings.g.dart`
- `character_specialization.g.dart`
- `faction_progress.g.dart`
- `augmentation.g.dart`
- `quest.g.dart`
- `quest_step.g.dart`

### 4. Enable Desktop Support (Linux)

```bash
flutter config --enable-linux-desktop
```

### 5. Run the App

```bash
# Linux
flutter run -d linux

# Or check available devices
flutter devices
```

## Project Structure Overview

```
lib/
├── core/                    # Core functionality
│   ├── database/            # Database setup & migrations
│   ├── models/              # Base model interface
│   ├── services/            # Notifications, tray, alert orchestration
│   └── utils/               # Utilities (date, constants)
│
├── features/                # Feature modules
│   ├── bases/              # Base management
│   ├── alerts/             # Alert system
│   ├── characters/         # Character management
│   ├── servers/            # Server management
│   ├── dashboard/          # Dashboard
│   ├── quest_journal/      # Quest tracking
│   ├── specializations/    # Chapter 3 progression
│   ├── factions/           # Faction progress
│   ├── augmentations/      # Augment tracker
│   └── settings/           # Settings
│
├── shared/                  # Shared components
│   ├── theme/              # Dune theme & colors
│   └── navigation/         # App router
│
└── platform/                # Platform-specific
    └── system_tray/        # System tray service
```

## Implementation Priority

### Current Development Priorities
1. **Polish and refinement**: sort/filter UX, cloud sync research, deeper analytics
2. **Release hardening**: SBOMs, checksums, and signing workflow validation
3. **Quality**: additional widget/integration coverage for new feature modules

## Troubleshooting

### Flutter not found
If `flutter` command is not found:
```bash
# Add Flutter to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Or use the system-installed Flutter
which flutter
```

### Code generation errors
If build_runner fails:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database errors
The database will be created automatically on first run. Current schema version: `v8`.
Location:
- Linux: `~/.local/share/dune-awakening-companion/dune_companion.db`
- Windows: `%APPDATA%/dune-awakening-companion/dune_companion.db`
- macOS: `~/Library/Application Support/dune-awakening-companion/dune_companion.db`

## Development Tips

1. **Hot Reload**: Press `r` in the terminal while app is running
2. **Hot Restart**: Press `R` in the terminal
3. **DevTools**: Run `flutter pub global activate devtools` then `flutter pub global run devtools`

## Current Workflow

When continuing development:
1. Run `flutter pub get`
2. Run `dart run build_runner build --delete-conflicting-outputs` after model changes
3. Run `flutter analyze`
4. Run `flutter test`

See `README.md`, `NEXT_STEPS.md`, and `docs/ROADMAP_2026.md` for the current roadmap.

