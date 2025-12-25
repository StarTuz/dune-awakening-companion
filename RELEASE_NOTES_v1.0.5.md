# Release Notes v1.0.5

**Date:** December 25, 2025
**Status:** Stable Release

This release focuses on **Full Localization Stabilization** and polishing the notification system.

## 🌍 Localization Fixes (Critical)
- **Zero Missing Keys:** Resolved all `flutter gen-l10n` warnings across all 7 supported languages (English, German, French, Spanish, Italian, Ukrainian, Welsh).
- **Import/Export Strings:** Added missing translations for the new data backup system into DE, FR, IT, and UK.
- **Welsh & Italian Updates:** Fixed missing keys related to character deletion messages and base power status (`deleteCharacterMessage`, `powerRemaining`, etc.).
- **Consistency:** Ensure `taxOverdueLabel` is used consistently across all languages to prevent build errors.

## 🛠️ Bug Fixes
- **Notification History Crash:** Fixed a crash where the "Clear History" confirmation dialog attempted to use an undefined localization key (`l10n.clear`). It now correctly uses `l10n.delete`.
- **System Tray:** Acknowledged harmless deprecation warnings for `libayatana-appindicator` (no action needed, safe to ignore).

## 🚀 Enhancements
- **Roadmap Update:** Marked Notification Polish and Theme Customization as fully complete in documentation.
- **Documentation:** Updated HANDOFF and README to reflect v1.0.5 status.

## 📦 Install
- **Linux:** Download `dune-companion-linux-v1.0.5.tar.gz`
- **Windows:** Download `dune-companion-windows-v1.0.5.zip`
- **Android:** Download `app-release.apk`
- **macOS:** Download `dune-companion-macos-v1.0.5.dmg`
