# Installation Guide

## 📥 Download

**[👉 Get the Latest Release](https://github.com/StarTuz/dune-awakening-companion/releases/latest)**

---

## Platform-Specific Instructions

### 🪟 Windows

1. Download the `.zip` file from the releases page
2. Extract the ZIP to a folder (e.g., `C:\Games\DuneCompanion`)
3. Run `dune_awakening_companion.exe`

**If the app fails to start:**
- Run the included `vc_redist.x64.exe` (Visual C++ Redistributable)
- Restart the app

**Optional:** Create a desktop shortcut by right-clicking the `.exe` → Send to → Desktop

---

### 🐧 Linux

#### Prerequisites

The system tray feature requires `libayatana-appindicator`. Install it first:

**Arch Linux:**
```bash
sudo pacman -S libayatana-appindicator
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libayatana-appindicator3-1
```

**Fedora:**
```bash
sudo dnf install libayatana-appindicator-gtk3
```

#### Installation

1. Download the `.tar.gz` file
2. Extract it:
   ```bash
   tar -xzf dune-awakening-companion-linux-x64.tar.gz
   ```
3. Run the app:
   ```bash
   cd dune_awakening_companion
   ./dune_awakening_companion
   ```

**Optional:** Create a desktop entry for application menu integration.

---

### 🤖 Android

1. Download the `.apk` file
2. Enable "Install from Unknown Sources" in Settings → Security
3. Open the APK file and tap Install
4. Launch the app from your app drawer

**Note:** You may need to allow installation from your browser or file manager.

---

### 🍎 macOS

1. Download the `.zip` file
2. Extract it to reveal the `.app` file
3. Move `Dune Awakening Companion.app` to your Applications folder
4. Double-click to launch

**If you see "App cannot be opened":**
1. Right-click the app → Open
2. Click "Open" in the security dialog
3. This only needs to be done once

---

## 🔄 Updating

1. Download the new version
2. Replace the old files with the new ones
3. Your data is stored separately and will be preserved

**Your data location:**
- **Windows:** `%APPDATA%\dune_awakening_companion\`
- **Linux:** `~/.local/share/dune_awakening_companion/`
- **macOS:** `~/Library/Application Support/dune_awakening_companion/`
- **Android:** Internal app storage

---

## ⚠️ Troubleshooting

See [Troubleshooting](Troubleshooting.md) for common installation issues.
