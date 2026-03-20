# Quick Start Guide - Dune Awakening Companion App

## Overview
A cross-platform companion app for tracking characters, bases, quests, and Chapter 3 progression systems in Dune Awakening.

## Key Features

### ✅ Current Scope
1. **Manual Base Tracking**: Enter power expiration times directly
2. **Character Management**: Official/private server support plus portraits
3. **Per-base Alerts**: Enable/disable notifications and override thresholds
4. **Quest Journal**: Track quests, steps, notes, contracts, and repeatables
5. **Character Progression**: Specializations, faction ranks, and augmentations
6. **Dashboard Analytics**: Region and alert distribution charts
7. **Cross-Platform**: Linux, Windows, macOS, iOS, Android

## Technology Stack

**Flutter** - Single codebase for all platforms
- Modern, performant UI framework
- Excellent mobile support
- Good desktop support
- Active development and community

## Architecture Philosophy

**Extensible & Modular Design**
- Feature-based architecture - each feature is self-contained
- Easy to add new features without breaking existing ones
- Clean separation of concerns (UI, Business Logic, Data)
- Well-defined interfaces for extension points
- See `EXTENSIBILITY_GUIDE.md` for details on adding features

## Project Structure (Extensible)

```
lib/
├── core/            # Core functionality (stable, rarely changes)
├── features/        # Feature modules (easily add new ones)
│   ├── bases/       # Base management
│   ├── alerts/      # Alert system
│   ├── characters/  # Character management
│   ├── quest_journal/ # Quest journal + steps
│   ├── specializations/ # Chapter 3 progression
│   ├── factions/    # Faction rank tracking
│   ├── augmentations/ # Augmentation tracking
│   └── settings/    # Export/import + app settings
├── shared/          # Shared across features
│   ├── widgets/     # Reusable UI components
│   └── theme/       # Dune-inspired color scheme
└── platform/        # Platform-specific code
```

Each feature is self-contained and can be added/modified independently.

## Current Architecture

- **UI**: Flutter + Material 3 + adaptive navigation
- **State**: Riverpod providers and notifiers
- **Storage**: SQLite with migrations up to database v8
- **Charts**: `fl_chart`
- **Export/Import**: ZIP backup with JSON data and portraits
- **Background alerts**: local notifications + WorkManager/system tray flows

## Next Steps

1. Keep `dart run build_runner build --delete-conflicting-outputs` in your workflow after model changes
2. Add tests for any new feature module or repository you introduce
3. Use `README.md`, `NEXT_STEPS.md`, and `docs/ROADMAP_2026.md` for roadmap context
4. Follow `EXTENSIBILITY_GUIDE.md` when adding new feature modules

## Color Scheme Preview

- **Background**: Deep desert night (#1A1612)
- **Safe Status**: Spice gold (#D4A574)
- **Warning**: Desert amber (#E6B84F)
- **Caution**: Burnt orange (#C97D60)
- **Critical**: Deep rust (#A84D3A)

See `COLOR_SCHEME.md` for full palette.

