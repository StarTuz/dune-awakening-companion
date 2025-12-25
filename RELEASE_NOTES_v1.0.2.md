# 🚀 Release Notes v1.0.2

**Date:** December 24, 2025
**Status:** Stable Release
**Focus:** Internationalization (i18n) & Build Fixes

---

## 🌍 Global Expansion Update

We are excited to announce full multi-language support for the Dune Awakening Companion App! This major update makes the app accessible to a global audience.

### ✨ New Features

#### 🌐 Multi-Language Support
You can now instantly switch the app language from the **Settings** screen.
- **7 Languages Supported:**
  - 🇬🇧 English
  - 🇪🇸 Spanish
  - 🇫🇷 French
  - 🇩🇪 German
  - 🇺🇦 Ukrainian
  - 🇮🇹 Italian
  - 🏴󠁧󠁢󠁷󠁬󠁳󠁿 Welsh
- **Full Localization:**
  - Dashboard titles and labels
  - Navigation menus
  - Alert messages and status
  - Date and Number formatting
  - System messages

#### 💾 Settings Persistence
- Your language preference is automatically saved and applied on next launch.

### 🛠️ Bug Fixes & Improvements

- **Linux Build Fix:** Resolved `cxx_std_14` configuration error in CMakeLists.txt that was causing build failures.
- **Dependency Update:** Upgraded `intl` package to `^0.20.2` to resolve conflicts with `flutter_localizations`.
- **Build Cleanliness:** Suppressed `libayatana-appindicator` deprecation warnings in build output.

### 📦 Updating

1. Pull the latest `Beta` branch.
2. Run `flutter pub get`.
3. Run `flutter clean` (Recommended after dependency updates).
4. Build and run as usual.
