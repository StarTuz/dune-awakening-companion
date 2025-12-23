# 🏜️ Dune Awakening Companion v1.0.0-beta

**First public beta release!** A cross-platform companion app for managing characters, bases, power countdowns, and taxes in Dune Awakening.

> ⚠️ **Disclaimer:** This is an unofficial, fan-made companion app. NOT affiliated with, endorsed by, or supported by Funcom.

---

## ✨ Features

### Character & Base Management
- 🎮 **Unlimited Characters** across all servers (227 official + private servers)
- 🏰 **Unlimited Bases** per character with individual power tracking
- ⏱️ **Real-time Countdown** (Days/Hours/Minutes)
- 📸 **Character Portraits** (auto-resize to 512×512)

### Tax Tracking
- 💰 **Advanced Fief Tax System** with calculator
- 🔄 **Smart Auto-Increment** for missed tax cycles
- 📊 Track Current, Overdue, and Defaulted amounts

### Alerts & Notifications
- 🔔 **System Tray Integration** (right-click menu, minimize to tray)
- ⚡ **Power Alerts** (< 24h critical, < 48h warning)
- 💸 **Tax Alerts** (overdue/defaulted warnings)
- 🎛️ **Configurable Check Intervals** (15/30/60 min)

### Data Management
- 📤 **Export** all data to JSON backups
- 📥 **Import** with Merge or Replace options
- 💾 **Local SQLite Database** (your data never leaves your device)

### User Interface
- 🎨 **Dune-themed Design** with color-coded status
- 📱 **Adaptive Navigation** (sidebar on desktop, bottom bar on mobile)
- 📊 **Dashboard** with real-time statistics

---

## 📦 Downloads

| Platform | File | Size |
|----------|------|------|
| **Linux x64** | `dune-awakening-companion-v1.0.0-beta-linux-x64.tar.gz` | ~17 MB |

### Linux Installation

1. Download and extract:
   ```bash
   tar -xzf dune-awakening-companion-v1.0.0-beta-linux-x64.tar.gz
   cd bundle
   ```

2. Run the application:
   ```bash
   ./dune_awakening_companion
   ```

3. (Optional) Create a desktop shortcut for convenience

### Requirements
- Linux x64 (Ubuntu 20.04+, Fedora 35+, or equivalent)
- `libsqlite3` (usually pre-installed)
- GTK 3.x (usually pre-installed)

---

## 🐛 Known Issues

- Linux: System tray tooltip not supported (gracefully handled)
- System tray icon loaded from temp file (works fine)

---

## 📋 What's Next

- [ ] Windows & macOS builds
- [ ] Android APK
- [ ] Multi-language support (i18n)
- [ ] Character sorting options

---

## 📝 Full Changelog

### Added
- Multi-character management across all Dune Awakening servers
- Unlimited base tracking with power countdown
- Tax tracking for Advanced Fiefs with auto-increment
- Character portraits with auto-resize
- Export/Import data backups (JSON)
- Alert system (< 48h warning, < 24h critical)
- Notifications & System Tray integration
- Dashboard with real-time statistics

### Technical
- Flutter 3.x with Riverpod state management
- SQLite database with FFI for desktop
- Database v4 with migrations

---

## 🙏 Acknowledgments

- Herbert Estate for the Dune universe
- Funcom for Dune Awakening
- Flutter & Riverpod communities
- Created with Google Antigravity IDE + Claude Sonnet 4.5

---

**Built with ❤️ for the Dune Awakening community**

*May your power stay charged and your taxes stay paid.* 🏜️
