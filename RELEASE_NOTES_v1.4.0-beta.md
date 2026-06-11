# Release Notes v1.4.0-beta

**Date:** 2026-06-10
**Status:** Beta

This beta release adds Field Timers for sand harvest aggro management, a unified Journal hub, and notification reliability fixes on Linux and Android.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Field Timers:** A dedicated top-level screen for tracking sand harvest windows, with configurable pre-alarm audio cues, T=0 OS notifications, and escalating page alerts until acknowledged.
- **Journal Hub:** Quest Journal and Chronicle now share a single top-level tab with a tabbed layout, simplifying navigation.
- **Notification fixes:** Sound now plays on KDE Plasma 6 Linux; Android 13+ POST_NOTIFICATIONS permission wired; notification icon and Windows details added throughout.

## New Features

### Field Timers
- Preset durations for sand harvest windows (2:30, 3:00, 3:30, 4:00) plus a custom duration input.
- Configurable pre-alarm cue track: up to 6 staged audio cues (beeps that escalate in pitch/urgency) counted back from T=0, with adjustable spacing (15–60s) and volume.
- Full-screen countdown with color-coded urgency (amber → orange → critical red as time depletes) and a visual cue progress bar showing which stages have fired.
- At T=0: fires an OS notification and plays an urgent audio page; escalates every N seconds until you tap **Reset aggro** (re-arms) or **End session**.
- Settings section: per-cue count, spacing, volume, escalation interval, and bypass-quiet-hours toggle; "Test all pre-alarms" button for audio verification.
- User-overridable audio: drop custom WAV files into `<app documents>/field_timer_sounds/` to replace any bundled cue.

### Journal Hub
- New top-level **Journal** nav entry (between Characters and Field Timers) hosts Quest Journal and Chronicle in a tab bar — no more separate nav slots for each.

## Fixes

- **KDE Plasma 6 / Linux notifications:** Added `message-new-instant` freedesktop sound hint so OS notification sounds respect user settings.
- **Android 13+ notifications:** Added `POST_NOTIFICATIONS`, `VIBRATE`, and `RECEIVE_BOOT_COMPLETED` permissions to the manifest.
- **Notification icon:** Bundled `assets/app_icon.png` now used as the Linux notification icon.
- **Windows notification details:** `WindowsNotificationDetails` wired to all notification paths.
- **Test notification button:** Now always fires a real OS notification for end-to-end verification, regardless of active alert count.

## Known Issues

- Field Timer audio uses in-app playback and requires the app to be in the foreground (or at minimum not suspended). OS notification and escalation still fire if the app is backgrounded but audio may be suppressed by the OS.
- Field Timer preset durations are based on community-reported sand harvest windows and may vary by server settings or future patches.
- New beta features need more cross-platform and in-game validation before a stable release.

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.4.0-beta-linux-x64.tar.gz` |
| Windows x64 | `dune-awakening-companion-v1.4.0-beta-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.4.0-beta-macos.zip` |
| Android | `dune-awakening-companion-v1.4.0-beta-android.apk` |

---

**Built for the Dune Awakening community**
