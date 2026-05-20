# Release Notes v1.2.0

**Date:** 2026-05-19
**Status:** Release Candidate

This release updates the companion for the current Chapter 3-era feature set: quest tracking, progression systems, dashboard charts, DB v8, and cleaned-up tax-free copy.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Chapter 3 progression:** Track specializations, faction progress, and augmentations alongside each character.
- **Quest Journal:** Manage quests, steps, notes, statuses, and reminders from the companion app.
- **DB v8 feature baseline:** Current app metadata, export metadata, docs, and release notes now align around v1.2.0 / database v8.

## New Features

- **Quest Journal:** Character-linked quests with step-by-step progress and reminder support.
- **Progression Tracking:** Specialization, faction progress, and augmentation models, repositories, and UI flows.
- **Dashboard Charts:** Analytics views for character/base state and alert distribution.
- **Per-base Alert Overrides:** Fine-tune warning and critical alert behavior per base.

## Improvements

- **Documentation:** README, FAQ, handoff, roadmap, and future-research docs now distinguish shipped features from longer-term Hagga/new-player map research.
- **Chapter 3 Alignment:** User-facing docs no longer recommend tax workflows removed from the app and from the game.
- **Release Metadata:** Package version now matches the app-facing v1.2.0 release line.

## Known Issues

- Linux system tray tooltip support depends on desktop environment and AppIndicator behavior; alert counts remain available in the tray menu.
- Hagga Basin / new-player interactive map work is research only and is not included in this release.

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.2.0-linux-x64.tar.gz` |
| Windows x64 | `dune-awakening-companion-v1.2.0-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.2.0-macos.zip` |
| Android | `dune-awakening-companion-v1.2.0-android.apk` |

### Verify Downloads

Compare SHA-256 checksums against `checksums.txt` attached to the release:

```bash
sha256sum -c checksums.txt
```

---

## Upgrade Instructions

1. Download the new version for your platform.
2. Replace the existing installation.
3. Launch the app; database migrations run automatically.
4. Tax data from previous versions is harmless and ignored by the current app.

---

**Built for the Dune Awakening community**
