# System Tray Behavior Guide

## Overview
The Dune Awakening Companion App runs in the system tray on desktop platforms (Linux, Windows, macOS) to provide persistent notifications even when the window is closed.

---

## System Tray Icon

**Icon Location:** `assets/app_icon.png`

**What You'll See:**
- A dune/desert themed icon in your system tray
- Icon appears in the system tray area (usually top-right on Linux, bottom-right on Windows)
- The icon shows the app is running in the background

**Alert Badge:**
- Future enhancement: Badge will show number of critical alerts
- Example: "3" overlaid on icon = 3 bases need attention

---

## Window Behavior

### **Closing the Window (X button):**
- ❌ **Does NOT quit** the app
- ✅ **Minimizes to tray**
- ✅ App keeps running in background
- ✅ Notifications continue to work
- ✅ Periodic alert checks continue

### **Showing the Window:**
- **Click** the tray icon → Window appears
- OR use tray menu: Right-click → "Show Window"

### **Actually Quitting:**
- Right-click tray icon → "Quit"
- This fully exits the app

---

## Tray Menu (Right-Click)

**Menu Items:**
1. **Show Window**
   - Restores and focuses the main window
   - Keyboard shortcut: Click tray icon

2. **Check Alerts (N)**
   - Shows number of critical alerts in parentheses
   - Example: "Check Alerts (3)" = 3 bases critical
   - Clicking opens the Alerts screen
   - Triggers immediate notification check

3. **Toggle Notifications**
   - Quick enable/disable notifications
   - Alternative to going to Settings

4. **Quit**
   - **Fully exits** the application
   - Stops all background checks
   - Removes tray icon
   - This is the ONLY way to actually quit

---

## Settings Integration

**Start Minimized to Tray** (Linux/Windows/macOS only):
- Settings → Notifications → "Start Minimized to Tray"
- When enabled: App launches hidden in tray
- When disabled: App opens window normally

---

## Platform Differences

### **Linux:**
- Icon appears in system tray (top panel, usually right side)
- Requires notification daemon (dunst, notify-osd, etc.)
- Icon file: PNG format

### **Windows:**
- Icon appears in system tray (taskbar, bottom-right)
- Native Windows notifications
- Icon file: ICO format (falls back to PNG)

### **macOS:**
- Icon appears in menu bar (top-right)
- Native macOS notifications
- Icon file: PNG format

---

## Troubleshooting

### **Icon Doesn't Appear:**
1. Check `assets/app_icon.png` exists
2. Run `flutter pub get` to refresh assets
3. Restart the app
4. On Linux: Ensure you have a system tray extension installed

### **Can't Close/Quit:**
- Window close (X) = Minimize to tray (app still running)
- To fully quit: Right-click tray icon → "Quit"

### **Notifications Not Working:**
- Check Settings → Enable Notifications is ON
- Linux: Install notification daemon (`dunst`)
  ```bash
  sudo pacman -S dunst  # Arch
  sudo apt install dunst  # Ubuntu
  ```
- Test: `notify-send "Test" "Hello"`

---

## Future Enhancements (v1.1+)

- **Badge count** on icon showing critical alerts
- **Icon color changes** based on alert severity
- **Notification sounds** customization
- **Quick actions** in tray menu (add base, quick check)
- **Multi-tray icons** for different alert types

---

**Current Status:** Basic tray functionality complete ✅  
**Icon:** Simple dune/desert theme  
**Next:** Add proper icon badge for alert count

