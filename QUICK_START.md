# Quick Start Guide - Dune Awakening Companion App

## Overview
A cross-platform companion app for tracking power expiration across multiple bases, characters, and servers in Dune Awakening.

## Key Features

### ✅ Confirmed Requirements
1. **Manual Entry**: You manually enter power expiration times (no API available)
2. **Configurable Alerts**: 
   - Set custom warning thresholds (e.g., 24h, 12h, 6h, 1h)
   - Configure how often alerts repeat (once, every X minutes, etc.)
   - Configure check interval (how often the app checks for alerts)
3. **Dune-Inspired Theme**: Desert/sand color palette (copyright-safe)
4. **System Tray**: Minimize to system tray, can quit from tray menu
5. **Cross-Platform**: Single codebase for Linux, Windows, macOS, iOS, Android

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
│   ├── servers/     # Server management
│   └── [future]/    # Easy to add new features
├── shared/          # Shared across features
│   ├── widgets/     # Reusable UI components
│   └── theme/       # Dune-inspired color scheme
└── platform/        # Platform-specific code
```

Each feature is self-contained and can be added/modified independently.

## Development Phases

### Phase 1: Foundation
- Flutter project setup
- Database schema
- Basic CRUD operations
- Theme implementation
- Basic UI layout

### Phase 2: Core Features
- Alert system with configurable thresholds
- Platform notifications
- System tray integration
- Base/Character/Server management
- Settings panel

### Phase 3: Polish & Testing
- Cross-platform testing
- UI refinements
- Error handling
- Documentation

## Next Steps

1. Initialize Flutter project
2. Set up database schema
3. Implement Dune theme
4. Build core features
5. Add alert system
6. Test on all platforms

## Color Scheme Preview

- **Background**: Deep desert night (#1A1612)
- **Safe Status**: Spice gold (#D4A574)
- **Warning**: Desert amber (#E6B84F)
- **Caution**: Burnt orange (#C97D60)
- **Critical**: Deep rust (#A84D3A)

See `COLOR_SCHEME.md` for full palette.

