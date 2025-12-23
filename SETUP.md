# Setup Guide - Dune Awakening Companion App

## Initial Setup Complete ✅

The project structure has been initialized with an extensible architecture. Here's what's been set up:

### ✅ Completed

1. **Project Structure**: Full directory tree with feature-based architecture
2. **Dependencies**: `pubspec.yaml` with all required packages
3. **Data Models**: Server, Character, Base, Alert, AlertSettings
4. **Database**: SQLite schema with migrations system
5. **Theme**: Complete Dune-inspired color scheme
6. **Navigation**: App router with all routes defined
7. **Core Utilities**: Date formatting, constants
8. **Placeholder Screens**: All main screens created (ready for implementation)

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
│   ├── services/            # Core services (future)
│   └── utils/               # Utilities (date, constants)
│
├── features/                # Feature modules
│   ├── bases/              # Base management
│   ├── alerts/             # Alert system
│   ├── characters/         # Character management
│   ├── servers/            # Server management
│   ├── dashboard/          # Dashboard
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

### Phase 1: Core Features (Next)
1. **Database Services**: Implement repositories for CRUD operations
2. **State Management**: Set up Riverpod providers
3. **Base Management**: Full CRUD UI for bases
4. **Character/Server Management**: Full CRUD UI

### Phase 2: Alert System
1. **Alert Service**: Background checking logic
2. **Notification Service**: Platform notifications
3. **Alert UI**: Alert panel and management

### Phase 3: Polish
1. **Dashboard**: Overview with statistics
2. **Settings**: Complete settings UI
3. **System Tray**: Full tray integration
4. **Testing**: Cross-platform testing

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
The database will be created automatically on first run. Location:
- Linux: `~/.local/share/dune-awakening-companion/dune_companion.db`
- Windows: `%APPDATA%/dune-awakening-companion/dune_companion.db`
- macOS: `~/Library/Application Support/dune-awakening-companion/dune_companion.db`

## Development Tips

1. **Hot Reload**: Press `r` in the terminal while app is running
2. **Hot Restart**: Press `R` in the terminal
3. **DevTools**: Run `flutter pub global activate devtools` then `flutter pub global run devtools`

## Next Development Session

When you're ready to continue development:
1. Implement database repositories
2. Create Riverpod providers
3. Build the Base Management UI
4. Implement the alert checking service

See `PLAN.md` for the complete development roadmap.

