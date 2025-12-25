# Notifications Guide

Complete guide to notifications, alerts, and sound customization.

---

## 🔔 Overview

The Dune Awakening Companion sends notifications when:
- **Power Critical** ⚡ - A base has less than 24 hours of power remaining
- **Tax Overdue** 💰 - An Advanced Fief has overdue taxes

---

## ⚙️ Notification Settings

Access notification settings via **Settings** → **Notifications** section.

### Alert Check Interval

Configure how often the app checks for alerts:

| Setting | Description |
|---------|-------------|
| **15 minutes** | Most responsive, higher battery usage |
| **30 minutes** | Balanced (recommended) |
| **60 minutes** | Lower frequency, better battery life |

### Sound & Vibration

| Toggle | Effect |
|--------|--------|
| **Sound** | Enable/disable notification sounds |
| **Vibration** | Enable/disable haptic feedback (mobile) |

### 🌙 Quiet Hours (Do Not Disturb)

Prevent notifications during sleep or focus time:

1. Enable **Quiet Hours** toggle
2. Set **Start Time** (e.g., 10:00 PM)
3. Set **End Time** (e.g., 8:00 AM)

During quiet hours:
- Notifications are still generated but silently
- The system tray icon will still update
- Alerts are queued for when quiet hours end

**Tip:** Quiet hours work based on your device's local time.

---

## 📜 Notification History

View past notifications:

1. Go to **Settings** → **Notifications**
2. Tap **View Notification History**
3. See all past alerts with timestamps
4. Tap any notification to mark as read
5. Use **Clear All** to remove history

---

## 🎵 Custom Notification Sounds

### Installing the Dune Sound Pack

A free, Dune-themed sound pack is available:

1. Download `dune-sound-pack-v1.0.zip` from [Releases](https://github.com/StarTuz/dune-awakening-companion/releases)
2. Extract the ZIP file

### Platform-Specific Setup

#### 🪟 Windows

1. Open: `%APPDATA%\dune_awakening_companion\`
2. Create a folder called `sounds` if it doesn't exist
3. Copy `power_alert.wav` and `tax_alert.wav` into the `sounds` folder
4. Restart the app

#### 🐧 Linux

1. Open: `~/.local/share/dune_awakening_companion/`
2. Create a folder called `sounds` if it doesn't exist
3. Copy sound files into `sounds/`
4. Restart the app

#### 🤖 Android

1. The app will automatically use the sound pack if placed in:
   - `/storage/emulated/0/Android/data/com.example.dune_awakening_companion/files/sounds/`
2. Alternatively, use the system notification sound

### Sound File Requirements

| Requirement | Value |
|-------------|-------|
| **Format** | WAV or OGG (preferred) |
| **Length** | Under 5 seconds |
| **Size** | Under 500KB |

### Creating Custom Sounds

1. Find or record a sound effect
2. Convert to WAV/OGG format (use Audacity or online converter)
3. Rename to `power_alert.wav` or `tax_alert.wav`
4. Place in the appropriate sounds folder

**Ideas for sounds:**
- Stillsuit activation beep
- Sandworm rumble
- Spice harvester alarm
- Ornithopter engine

---

## 🖥️ System Tray (Desktop Only)

### Features

The system tray icon provides:
- **Alert Badge:** Shows count of active alerts
- **Right-click Menu:**
  - Show Window
  - Check Alerts
  - Toggle Notifications
  - Quit

### Minimize to Tray

Closing the window **minimizes to tray** instead of quitting. To fully exit:
- Right-click tray icon → Quit
- Or use Ctrl+Q in the app

### Linux Tray Notes

⚠️ **Known Limitation:** Tooltips don't work on Linux due to `libayatana-appindicator` limitations.

**Workaround:** The alert count is shown in the tray menu instead.

---

## 🔧 Troubleshooting

### Notifications Not Appearing

1. Check that Notifications are **enabled** in Settings
2. Verify you're outside Quiet Hours
3. Ensure system notification permissions are granted
4. Check your system's Do Not Disturb settings

### Sounds Not Playing

1. Verify sound files are in the correct location
2. Check that Sound toggle is enabled
3. Ensure your system volume is up
4. Try a fresh copy of the sound files

### Mobile Background Notifications

On Android, background notifications use WorkManager. Ensure:
- Battery optimization is disabled for the app
- Background data is allowed
- The app isn't force-stopped

---

## 📱 Mobile vs Desktop

| Feature | Desktop | Mobile |
|---------|---------|--------|
| System Tray | ✅ | ❌ |
| Background Checks | Via tray | Via WorkManager |
| Vibration | ❌ | ✅ |
| Notification Grouping | Basic | Full Android/iOS support |
| Sound Customization | ✅ | System sounds |

---

*The spice must flow... and so must your alerts!* 🏜️
