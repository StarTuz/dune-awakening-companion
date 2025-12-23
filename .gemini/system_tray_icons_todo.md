# System Tray Icons - TODO

## Required Icons:

### For System Tray:
- `assets/app_icon.png` - Linux/macOS (256x256 PNG)
- `assets/app_icon.ico` - Windows (ICO format, multiple sizes)

### Icon Requirements:
- Simple, recognizable design
- Visible at small sizes (16x16, 24x24, 32x32)
- Monochrome or simple color scheme
- Represents Dune Awakening / base tracking

### Suggested Design:
- Sandworm icon (simple silhouette)
- Power symbol (⚡)
- Desert/dune symbol
- Base/building icon

### Generation Tools:
- Use online icon generator (favicon.io, realfavicongenerator.net)
- Or create in GIMP/Inkscape
- Export as PNG (256x256) and ICO (multiple sizes)

### pubspec.yaml Addition:
```yaml
flutter:
  assets:
    - assets/app_icon.png
    - assets/app_icon.ico
```

## Temporary Workaround:
The app will run without icons on desktop, but won't show a tray icon until these are added.

## Priority:
Medium - App works without icons, but they improve UX significantly.
