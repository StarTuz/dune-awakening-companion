# <img src="assets/app_icon.png" width="48" height="48" alt="App Icon" style="vertical-align: bottom;"> Dune Awakening Companion App

A cross-platform companion application for managing characters, bases, and power countdowns in **Dune Awakening**.

[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS-blue)](https://github.com/StarTuz/dune-awakening-companion)
[![Flutter](https://img.shields.io/badge/flutter-3.38-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.3.0--beta-orange)](https://github.com/StarTuz/dune-awakening-companion/releases)

> ⚠️ **Disclaimer:** This is an unofficial, fan-made companion app. NOT affiliated with, endorsed by, or supported by Funcom.

---

## ✨ Features

### 🎮 Multi-Character Management
- Track **unlimited characters** across all Dune Awakening servers
- **Official Servers:** 227 worlds across 5 regions (North America, Europe, Asia, Oceania, South America)
- **Private Servers:** Support for 5 major hosting providers (GPORTAL, BisectHosting, xREALM, 4NetPlayers, Nitrado)
- **Self Hosted Servers:** Track player-run worlds/battlegroups with freeform world/server names
- Full character context: Name, Region, World, Sietch
- **📸 Character Portraits:** Add custom images from in-game screenshots!

### 🏰 Unlimited Base Tracking
- Manage **unlimited bases** per character
- Individual power countdown tracking (Days/Hours/Minutes)
- Per-base notification overrides:
  - Disable alerts for quiet/abandoned bases
  - Override warning/critical thresholds per base
- Color-coded status indicators:
  - 🔴 **Red:** < 6 hours (Critical)
  - 🟡 **Yellow:** < 24 hours (Warning)  
  - 🟢 **Green:** > 24 hours (Safe)
- Easy refuel updates via edit dialog

### 🔔 Notifications & System Tray
- **Desktop:** System tray integration with right-click menu
  - Show Window, Check Alerts, Toggle Notifications, Quit
  - Window close minimizes to tray (doesn't quit)
  - **Alert count badge** in tooltip and menu
- **Mobile:** Background WorkManager checks
- Configurable check intervals (15/30/60 minutes)
- Power alerts (⚡ Power Critical!)
- **🌙 Quiet Hours:** Customizable Do Not Disturb (default 10 PM - 8 AM)
- **🔊 Sound/Vibration:** Toggle notification sounds and haptics
- **📜 History:** View past notifications, mark as read, clear
- **🎵 Optional Sound Pack:** Dune-themed notification sounds (see Releases)

### 📤 Data Management
- **Export:** ZIP backup with JSON data and portraits
- **Import:** Restore from ZIP backups with Merge or Replace modes
- Custom save/load locations via file picker
- Platform-agnostic (works on all platforms)

### 📖 Quest Journal & Character Progression
- **Quest Journal:** Track multi-step quests, contracts, notes, and repeatable objectives
- **Quest Steps:** Mark progress step-by-step from a dedicated detail sheet
- **Class Quests:** Track basic and advanced trainer unlock paths per character
- **Specializations:** Track all 5 Chapter 3 specialization trees up to 500 total levels
- **Faction Progress:** Record ranks, contracts completed, and reputation progress
- **Augmentations:** Track acquired augments, source bosses, slots, and equipped state

### 📐 Blueprints & Schematics
- **Hagga Basin South slice:** Seeded checklist based on IGN's [Hagga Basin South unique schematics guide](https://www.ign.com/wikis/dune-awakening/All_Hagga_Basin_South_Unique_Schematics_and_Locations)
- **Per-character progress:** Mark each blueprint locked/unlocked independently per character
- **Source details:** Record category, source type, source/location, required materials, and notes
- **Future-ready links:** Store optional quest and map-pin references for later journal/map integration

### 🔔 Smart Alert System
- Automatic alerts for bases expiring soon
- Visual alert badge showing count
- Color-coded alert icon (critical vs warning)
- Detailed alerts screen with:
  - Base severity labels (CRITICAL/WARNING)
  - Full character context
  - Time remaining for Power
  - One-tap navigation to manage bases

### 📊 Dashboard Overview
- Real-time statistics from database
- Character and base counts
- Expiring Soon and Active Alerts counts
- Region chart for character distribution
- Alert distribution chart for base urgency
- Pull-to-refresh support

### 🌍 Multi-Language Support
- **7 Languages Supported:**
  - 🇬🇧 English
  - 🇪🇸 Spanish
  - 🇫🇷 French
  - 🇩🇪 German
  - 🇺🇦 Ukrainian
  - 🇮🇹 Italian
  - 🏴󠁧󠁢󠁷󠁬󠁳󠁿 Welsh
- **Instant Switch:** Change languages instantly from Settings
- **Persistence:** Remembers your preference across restarts
- **Comprehensive:** Localized titles, alerts, messages, and dates

### 🎨 Themes & Appearance
- **5 Faction Themes:**
  - 🏜️ **Desert** (Default) - Warm sand & spice gold
  - 🟢 **House Atreides** - Green & black (The Noble House)
  - 🔴 **House Harkonnen** - Red & black (The Brutal Rulers)
  - 🔵 **Fremen** - Tan & blue (Desert Warriors)
  - 🟣 **Smuggler** - Purple & bronze (Shadow Traders)
- **Light/Dark Mode:** Toggle between Desert Day and Desert Night
- **Adaptive Navigation:**
  - Desktop: Side navigation rail
  - Mobile: Bottom navigation bar

### ♿ Accessibility
- **Text Size:** Slider from Small → Medium → Large → Extra Large
- **Text Weight:** Choose Light / Regular / Bold
- **High Contrast Mode:** Enhanced color contrast for better readability
- **Reduce Motion:** Disable animations throughout the app
- All settings persist between app restarts

---

## 📥 Download & Install

**[👉 Get the Latest Release Here](https://github.com/StarTuz/dune-awakening-companion/releases/latest)**

| Platform | Instructions |
|----------|--------------|
| 🪟 **Windows** | Download the `.zip` file. Extract it and run `dune_awakening_companion.exe`. If it fails to open, run the included installer for Visual C++. |
| 🐧 **Linux** | Download the `.tar.gz` (extract and run `./dune_awakening_companion`) or the `.AppImage` (chmod +x and run). **See Linux requirements below.** |
| 🤖 **Android** | Download the `.apk` file and install it on your device. |
| 🍎 **macOS** | Download the `.zip`, extract, and look for the `.app` file. |

### 🐧 Linux Requirements

The system tray feature requires `libayatana-appindicator`. Install it before running:

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

**AppImage (FUSE):**

Some distros require FUSE to run AppImages. If the AppImage does not launch,
install FUSE and try again:

**Arch Linux:**
```bash
sudo pacman -S fuse2
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libfuse2
```

**Fedora:**
```bash
sudo dnf install fuse
```

---

## 🛠️ Building from Source (Developers)

### Prerequisites
- Flutter SDK 3.x or higher
- Dart 3.x or higher
- For Linux desktop: `libsqlite3-dev`
- For Windows desktop: [Microsoft Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe)

### Setup

1. **Clone the repository** (Requires Git)
   ```bash
   git clone https://github.com/StarTuz/dune-awakening-companion.git
   cd dune-awakening-companion
   ```

2. **Switch to Beta branch**
   ```bash
   git checkout Beta
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   # Desktop (Linux)
   flutter run -d linux

   # Desktop (Windows)
   flutter run -d windows

   # Desktop (macOS)
   flutter run -d macos

   # Android
   flutter run -d android

   # Hot reload: press 'r'
   # Hot restart: press 'R'
   ```

---

## 📱 Usage

### Adding Your First Character

1. Navigate to the **Characters** screen
2. Tap the **+** button
3. Fill in character details:
   - Character name
   - (Optional) Tap the circle to add a portrait
   - Select your region
   - Choose server type (Official or Private)
   - Select or enter your world/server name
   - Enter your Sietch name
4. Tap **Save**

### Managing Bases

1. On the **Characters** screen, click the **"Bases"** button on your character card
2. In the base management dialog:
   - **Add Base:** Tap the floating **+** button
     - Enter base name
     - Set power countdown (Days/Hours/Minutes from in-game)
     - (Optional) Enable Advanced Fief for tax tracking
   - **Edit Base:** Tap the edit (✏️) icon to update countdown after refueling
   - **Delete Base:** Tap the delete (🗑️) icon

### Monitoring Alerts

1. Navigate to the **Alerts** screen
2. View all bases expiring in the next 48 hours
3. Alerts are sorted by urgency (most critical first)
4. Each alert shows both Power and Tax countdowns
5. Tap any alert card to jump to the Characters screen

### Backup & Restore

1. Navigate to **Settings** screen
2. **Export Data:** Creates a timestamped ZIP backup
3. **Import Data:** 
   - **Merge:** Add backup data to existing data
   - **Replace:** Clear all data, then import backup

### Character Progression

1. On the **Characters** screen, use the **Progress** button on a character card
2. In the progression dialog:
   - **Specializations:** adjust Combat, Crafting, Gathering, Exploration, and Sabotage levels
   - **Factions:** record faction rank, contracts, and reputation
   - **Augments:** track acquired augmentations and mark equipped items

### Quest Journal

1. Open the **Journal** tab from the main navigation
2. Add quests for any character and assign status, type, mission type, and notes
3. Open a quest to manage steps and mark progress as you play

---

## 🏗️ Project Structure

```
lib/
├── core/                       # Core functionality
│   ├── database/              # SQLite + migrations (v11)
│   ├── services/              # Notifications, system tray, images
│   ├── providers/             # Riverpod providers
│   └── utils/                 # Constants, helpers
├── features/                   # Feature modules
│   ├── characters/            # Character management + portraits
│   ├── bases/                 # Base tracking + per-base alert overrides
│   ├── alerts/                # Alert system
│   ├── dashboard/             # Overview screen
│   ├── blueprints/            # Blueprint and schematic tracker
│   ├── quest_journal/         # Quest and step tracking
│   ├── specializations/       # Chapter 3 specialization progress
│   ├── factions/              # Faction rank tracking
│   ├── augmentations/         # Augmentation tracker
│   └── settings/              # Export/import, notifications
├── shared/                     # Shared components
│   ├── navigation/            # Adaptive navigation
│   ├── theme/                 # Dune-themed colors
│   └── widgets/               # Reusable UI components
└── main.dart                   # App entry point
```

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | Riverpod 2.x |
| **Database** | SQLite (sqflite + sqflite_common_ffi) |
| **Notifications** | flutter_local_notifications |
| **System Tray** | tray_manager, window_manager |
| **Architecture** | Feature-first, Repository pattern |
| **Code Generation** | build_runner, json_serializable |

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[HANDOFF.md](./HANDOFF.md)** | Comprehensive technical documentation |
| **[FAQ.md](./FAQ.md)** | Frequently asked questions |
| **[NEXT_STEPS.md](./NEXT_STEPS.md)** | Development roadmap |
| **[PLAN.md](./PLAN.md)** | Original architecture planning |
| **[docs/CHAPTER3_RESEARCH.md](./docs/CHAPTER3_RESEARCH.md)** | Chapter 3 and early 2026 patch research |
| **[docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md](./docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md)** | **Vision track:** Hagga / new-player interactive map — research & assessment |
| **[docs/SIGNING_GUIDE.md](./docs/SIGNING_GUIDE.md)** | Release signing for all platforms |
| **[docs/RELEASE_CHECKLIST.md](./docs/RELEASE_CHECKLIST.md)** | Pre-release checklist |
| **[docs/RELEASE_NOTES_TEMPLATE.md](./docs/RELEASE_NOTES_TEMPLATE.md)** | Standardized release notes template |
| **[docs/SECURITY_CHECKLIST.md](./docs/SECURITY_CHECKLIST.md)** | Ongoing security review checklist |
| **[docs/ROADMAP_2026.md](./docs/ROADMAP_2026.md)** | 2026 engineering + product roadmap |
| **[docs/ENGINEERING_TASKLIST.md](./docs/ENGINEERING_TASKLIST.md)** | Engineering tasks (100% complete) |

---

## Vision & product research

Long-term companion vision includes **guided regional onboarding** (especially **Hagga Basin**) so new players don’t miss critical early beats—separate from the in-app **Quest Journal** (manual tracking) and from the **Adventure Journal / chronicles** brainstorm in `NEXT_STEPS.md`.

| Doc | Purpose |
|-----|---------|
| **[docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md](./docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md)** | Full **research / analysis / assessment** index for an interactive Hagga-style map (layers, sub-regions, risks, phases). Includes **internet research methodology** and **tiered source** notes. |
| **[NEXT_STEPS.md](./NEXT_STEPS.md)** §7 *RPG Elements & Storytelling* | **Chronicles / adventure journal** brainstorm (`JournalEntry`, timeline, biography) — narrative layer; cross-linked from the Hagga doc. |

---

## Chapter 3 Research (Feb 2026)
- Chapter 3 release date: Feb 3, 2026 (Funcom Developer Update).
- Taxes removed: base taxes were eliminated starting Chapter 3 (tax system removed from app).
- Return packages: claimable after 28+ days of inactivity.
- Endgame revamp: Landsraad redesign, Specializations, Augmentations.
- New content: repeatable testing stations, new locations, new weapons.

Full research and sources: `docs/CHAPTER3_RESEARCH.md`.

---

## 🔮 Roadmap

### ✅ Completed (v1.3.0-beta)

- [x] Multi-character management
- [x] Unlimited base tracking
- [x] Power countdown system (D/H/M)
- [x] ~~Tax tracking for Advanced Fiefs~~ (removed — Chapter 3 eliminated in-game taxes)
- [x] Character portraits
- [x] Export/Import data backups
- [x] Alert system (<48h warning, <24h critical)
- [x] Notifications & System Tray
- [x] Adaptive navigation
- [x] Database v11 with migrations
- [x] Multi-language support (7 languages)
- [x] **5 Faction Themes** (Desert, Atreides, Harkonnen, Fremen, Smuggler)
- [x] **Light/Dark Mode Toggle**
- [x] **Accessibility Features** (Text size, weight, contrast, motion)
- [x] **Quiet Hours & Notification Controls**
- [x] **Notification History**
- [x] **Quest Journal**
- [x] **Specialization Tracker**
- [x] **Faction Progress Tracker**
- [x] **Augmentation Tracker**
- [x] **Dashboard Charts & Analytics**
- [x] **Per-base Notification Overrides**
- [x] **Blueprints/Schematics Tracker** (Hagga Basin South first slice)

### 📋 Future Features

- [ ] Character Sorting (by server, urgency, name, last updated)
- [ ] Cloud Sync (optional, opt-in)

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) and [HANDOFF.md](./HANDOFF.md) before submitting PRs.

Every PR is automatically reviewed by **Qodo Merge** (AI code review). See `CONTRIBUTING.md` for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run `bash scripts/ci/local.sh` to verify locally
5. Test thoroughly on your target platform(s)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request and address Qodo review feedback

---

## 🐛 Known Issues

- Linux: System tray tooltip not supported (gracefully handled)
- Some deprecation warnings from external packages

Please report any issues you encounter on the [Issues page](https://github.com/StarTuz/dune-awakening-companion/issues).

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Legal Disclaimer

This is an **unofficial, fan-made** companion application.

- **NOT** affiliated with Funcom
- **NOT** endorsed or supported by Funcom
- Funcom had **no input** in development
- Dune Awakening is a trademark of **Funcom**
- Dune and related elements are trademarks of **Herbert Properties LLC**

Use at your own risk.

---

## 🙏 Acknowledgments

- 🙏 **Herbert Estate** for creating the incredible Dune universe
- 🎮 **Funcom** for developing Dune Awakening
- 🌟 **Dune Awakening community** for game mechanics research
- 💙 **Flutter team** for the amazing framework
- ⚡ **Riverpod** for powerful state management
- 🤖 Created within **Google Antigravity IDE** with Claude Sonnet 4.5

---

## 📞 Support

For questions, suggestions, or issues:
- 📋 [Open an issue](https://github.com/StarTuz/dune-awakening-companion/issues)
- 📖 Check [FAQ.md](./FAQ.md) for common questions
- 📚 Review [HANDOFF.md](./HANDOFF.md) for technical documentation

---

<div align="center">

**Built with ❤️ for the Dune Awakening community**

*May your power stay charged.* 🏜️

</div>
