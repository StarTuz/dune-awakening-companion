# Release Notes v1.0.4 - Themes & Accessibility

**Release Date:** December 25, 2025  
**Previous Version:** v1.0.3

---

## 🎨 New Features

### Faction Themes
Choose from 5 immersive Dune-inspired color schemes:

| Theme | Colors | Description |
|-------|--------|-------------|
| **Desert** (Default) | Sand & Spice Gold | The original warm desert aesthetic |
| **House Atreides** | Green & Black | The noble house of Caladan |
| **House Harkonnen** | Red & Black | The brutal rulers of Giedi Prime |
| **Fremen** | Tan & Blue | Desert warriors with blue-within-blue eyes |
| **Smuggler** | Purple & Bronze | Shadow traders of Arrakis |

### Light/Dark Mode Toggle
- Switch between Desert Night (dark) and Desert Day (light) themes
- Works with all faction themes
- Setting persists between app restarts

### Accessibility Features
Four new accessibility options in Settings:

1. **Text Size Slider** - Adjust from Small → Medium → Large → Extra Large
2. **Text Weight** - Choose Light / Regular / Bold for all text
3. **High Contrast Mode** - Enhanced color contrast for better readability
4. **Reduce Motion** - Disable animations throughout the app

---

## 🔧 Improvements

### UI Polish
- Dune-themed tooltips with spice gold accents
- Full tooltip localization (7 languages)
- Consistent styling across the app

### Localization
Added tooltip translations for all supported languages:
- English, Spanish, French, German, Ukrainian, Italian, Welsh

---

## 📁 Files Changed

### New Files
- `lib/core/providers/theme_provider.dart` - Theme mode and faction management
- `lib/core/providers/accessibility_provider.dart` - Accessibility settings

### Modified Files
- `lib/main.dart` - Dynamic theme and accessibility application
- `lib/shared/theme/app_colors.dart` - Added faction color palettes
- `lib/shared/theme/app_theme.dart` - Added faction themes
- `lib/features/settings/screens/settings_screen.dart` - New Appearance & Accessibility sections
- All `lib/l10n/app_*.arb` files - Tooltip translations

---

## ⬆️ Upgrade Notes

- No database migrations required
- All new settings use SharedPreferences and are optional
- Existing users will start with default settings (Desert theme, Dark mode, Medium text size)

---

## 🐛 Known Issues

- **Linux System Tray Tooltip**: Not supported due to libayatana-appindicator limitation (documented workaround: alert count shown in menu)

---

*Made with ❤️ for Dune Awakening players*
