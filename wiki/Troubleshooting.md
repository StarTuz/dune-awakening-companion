# Troubleshooting

Common issues and their solutions.

---

## 🔔 Notifications Not Working

### Check Settings

1. Ensure notifications are **enabled** in Settings
2. Verify you're outside **Quiet Hours**
3. Check the alert check interval

### Check System Permissions

**Android:**
- Settings → Apps → Dune Companion → Notifications → Allow

**Windows:**
- Settings → System → Notifications → Dune Awakening Companion

**Linux:**
- Install `libayatana-appindicator` (see Installation guide)

### Check Background Execution

**Android:**
- Disable battery optimization for the app
- Allow background data

**Desktop:**
- Keep app running (minimized to tray)

---

## 🖥️ System Tray Issues

### Tray Icon Not Appearing

**Linux:**
```bash
# Install required library
sudo apt-get install libayatana-appindicator3-1  # Ubuntu/Debian
sudo pacman -S libayatana-appindicator            # Arch
```

**Windows:**
- Tray icon may be hidden; check system tray overflow

### Tooltip Not Showing (Linux)

This is a known limitation of `libayatana-appindicator`.

**Workaround:** The alert count is shown in the right-click menu instead.

---

## 🎵 Sound Not Playing

### Check Sound Settings

1. Verify **Sound** is enabled in Settings → Notifications
2. Check your system volume
3. Ensure the app has audio permissions

### Custom Sounds Not Working

1. Verify files are in the correct location:
   - Windows: `%APPDATA%\dune_awakening_companion\sounds\`
   - Linux: `~/.local/share/dune_awakening_companion/sounds/`
2. Ensure file names are correct: `power_alert.wav`, `tax_alert.wav`
3. Verify WAV/OGG format
4. Restart the app

---

## 📱 App Won't Start

### Windows

**"VCRUNTIME140.dll not found"**
- Run the included `vc_redist.x64.exe`
- Or download from [Microsoft](https://aka.ms/vs/17/release/vc_redist.x64.exe)

### Linux

**"libsqlite3.so.0 not found"**
```bash
sudo apt-get install libsqlite3-0  # Ubuntu/Debian
```

### macOS

**"App cannot be opened" / "Unidentified developer"**
1. Right-click the app → Open
2. Click "Open" in the dialog
3. This is only needed once

---

## 💾 Data Issues

### Data Not Saving

- Ensure write permissions on data directory
- Check disk space
- Try Export to verify data exists

### Import Failed

1. Verify it's a valid JSON backup
2. Check file isn't corrupted
3. Try re-exporting from source

### Data Lost After Update

- Always export before updating
- Check if backup exists
- Data directory may have changed

---

## 🎨 Theme/Display Issues

### Text Too Small/Large

- Go to Settings → Accessibility → Text Size
- Reset to Medium if needed

### Colors Look Wrong

- Check if High Contrast is enabled
- Try switching factions
- Toggle Light/Dark mode

### UI Elements Overlapping

- Try different text size
- Check window size (desktop)
- Rotate device (mobile)

---

## 🐛 App Crashes

### General Steps

1. Restart the app
2. Check for updates
3. Export data (if possible)
4. Clear cache (mobile)
5. Reinstall if needed

### Crash on Startup

- Delete corrupted database:
  - Windows: `%APPDATA%\dune_awakening_companion\app_database.db`
  - Linux: `~/.local/share/dune_awakening_companion/app_database.db`
- ⚠️ **This deletes all data!** Try export first.

---

## 🔄 Sync Issues

### Data Not Appearing on New Device

1. Export from old device
2. Transfer the JSON file
3. Import on new device with **Replace** mode

### Portraits Not Transferring

- Portraits are embedded in exports
- Large exports are normal (several MB)
- Verify export completed successfully

---

## 📞 Getting Help

If issues persist:

1. Check [FAQ](FAQ.md)
2. Search [Issues](https://github.com/StarTuz/dune-awakening-companion/issues)
3. [Open a new issue](https://github.com/StarTuz/dune-awakening-companion/issues/new)

Include:
- Platform and version
- App version
- Steps to reproduce
- Error messages (if any)

---

*Even the desert has solutions for those who seek them.* 🏜️
