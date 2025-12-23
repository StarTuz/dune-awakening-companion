# Dune Awakening Companion App

A cross-platform companion application for managing characters, bases, and power countdowns in Dune Awakening.

![Platform](https://img.shields.io/badge/platform-Android%20%7C%20Linux%20%7C%20Windows%20%7C%20Mac-blue)
![Flutter](https://img.shields.io/badge/flutter-3.x-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## ✨ Features

### 🎮 Multi-Character Management
- Track unlimited characters across all Dune Awakening servers
- **Official Servers:** 227 worlds across 5 regions (North America, Europe, Asia, Oceania, South America)
- **Private Servers:** Support for 5 major hosting providers (GPORTAL, BisectHosting, xREALM, 4NetPlayers, Nitrado)
- Full character context: Name, Region, World, Sietch

### 🏰 Unlimited Base Tracking
- Manage unlimited bases per character
- Individual power countdown tracking (Days, Hours, Minutes)
- Color-coded status indicators:
  - 🔴 **Red**: < 6 hours (Critical)
  - 🟡 **Yellow**: < 24 hours (Warning)  
  - 🟢 **Green**: > 24 hours (Safe)
- Easy refuel updates via edit dialog

### 🔔 Smart Alert System
- Automatic alerts for bases expiring in < 48 hours
- Visual alert badge showing count
- Color-coded alert icon (Red < 24h, Yellow < 48h)
- Detailed alerts screen with:
  - Base severity labels (CRITICAL/WARNING)
  - Full character context
  - Time remaining and expiration date
  - One-tap navigation to manage bases

### 📊 Dashboard Overview
- Character count
- Total bases
- Bases expiring soon
- Active alerts summary

### 🎨 Adaptive Design
- **Desktop:** Side navigation rail
- **Mobile:** Bottom navigation bar
- Dune-themed color palette
- Responsive layouts

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart 3.x or higher
- For Linux desktop: `libsqlite3-dev`

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd "Dune Awakening Companion App."
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (models and providers)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # Desktop (Linux)
   flutter run -d linux
   
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
   - **Edit Base:** Tap the edit (✏️) icon to update countdown after refueling
   - **Delete Base:** Tap the delete (🗑️) icon

### Monitoring Alerts

1. Navigate to the **Alerts** screen
2. View all bases expiring in the next 48 hours
3. Alerts are sorted by urgency (most critical first)
4. Tap any alert card to jump to the Characters screen
5. Pull down or tap refresh icon to update

---

## 🏗️ Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── database/          # SQLite + migrations
│   └── utils/             # Constants, helpers
├── features/              # Feature modules
│   ├── characters/        # Character management
│   ├── bases/            # Base tracking
│   ├── alerts/           # Alert system
│   ├── dashboard/        # Overview screen
│   └── settings/         # App settings
└── shared/               # Shared components
    ├── navigation/       # Adaptive navigation
    └── theme/           # Colors, styles
```

---

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod 2.x
- **Database:** SQLite (sqflite + sqflite_common_ffi)
- **Architecture:** Feature-first, Repository pattern
- **Code Generation:** build_runner, json_serializable, riverpod_generator

---

## 📚 Documentation

- **[HANDOFF.md](./HANDOFF.md)** - Comprehensive technical documentation, architecture details, and future roadmap
- **In-code documentation** - All models, providers, and complex methods are documented

---

## 🔮 Roadmap

### Planned Features

- [ ] **Tax Tracking** - Track tax due dates and estimated amounts per base
- [ ] **Local Notifications** - Push notifications when bases enter danger zones
- [ ] **Multi-Account Support** - Manage multiple game accounts
- [ ] **Data Export/Import** - Backup and restore functionality
- [ ] **Enhanced Dashboard** - Charts and analytics
- [ ] **Theme Customization** - Multiple color schemes
- [ ] **Alert Threshold Settings** - Customize warning times

### Future Explorations

- [ ] Cloud sync across devices
- [ ] In-game overlay (if API becomes available)
- [ ] Spice production calculator
- [ ] Resource tracking
- [ ] Guild/Sietch management tools

---

## 🤝 Contributing

Contributions are welcome! Please read the contributing guidelines in [HANDOFF.md](./HANDOFF.md) before submitting PRs.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run `flutter analyze` to check for issues
5. Test thoroughly on your target platform(s)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

---

## 🐛 Known Issues

- None currently! 🎉

Please report any issues you encounter on the Issues page.

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Dune Awakening community for game mechanics research
- Flutter team for the amazing framework
- Riverpod for powerful state management
- All contributors and testers

---

## 📞 Support

For questions, suggestions, or issues:
- Open an issue on GitHub
- Check [HANDOFF.md](./HANDOFF.md) for technical documentation
- Review common issues section in handoff document

---

**Built with ❤️ for the Dune Awakening community**

*May your bases never fall, and your spice always flow.* 🏜️
