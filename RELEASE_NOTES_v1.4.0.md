# Release Notes v1.4.0

**Date:** 2026-06-11
**Status:** Stable Release

Full stable release of the v1.4.0 feature set — the biggest update since launch.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Dashboard overhaul** — responsive tile grid, Quick Actions, live Recent Activity feed, and stat tile context menus
- **Field Timers** — full-screen sand harvest countdown with staged audio cues and OS notifications
- **App Branding** — Jerboa emblem in the navigation rail, customizable from Settings
- **Rail footer (desktop)** — live field-timer countdown + next base expiry, collapse toggle, persisted across restarts

---

## New Features

### Dashboard
- Responsive tile grid for Characters, Bases, Expiring Soon, and Active Alerts stats
- **Recent Activity feed** — auto-logged events (characters created/deleted, bases added/removed, Chronicle entries) with typed icons and tap-to-navigate rows
- **Quick Actions card** — one-tap shortcuts to Start a field timer, Manage bases, and Write a Chronicle entry
- **Tile context menus** — right-click or long-press any stat tile for quick actions (e.g. the Bases tile opens the Add Base dialog directly)
- Deep-link from the closed-worlds stat into a filtered character list

### Field Timers
- Preset durations for sand harvest windows (2:30, 3:00, 3:30, 4:00) plus a custom duration input
- Configurable pre-alarm audio cues: up to 6 staged beeps counted back from T=0, with adjustable spacing (15–60 s) and volume
- Full-screen countdown with colour-coded urgency (amber → orange → critical red)
- At T=0: fires an OS notification and an urgent audio page; escalates every N seconds until you tap **Reset aggro** (re-arms) or **End session**
- Settings: per-cue count, spacing, volume, escalation interval, bypass-quiet-hours toggle, and a "Test all pre-alarms" button
- User-overridable audio: drop custom WAV files into `<app documents>/field_timer_sounds/`

### Navigation
- **Desktop rail footer** — bottom-anchored panel showing the live field-timer countdown and next base power expiry (<48 h), a collapse toggle (extended 200 px ↔ icon-only 80 px, persisted), and the app version
- **Mobile bottom nav** consolidated to 5 destinations + a More sheet (no more crowded 7-tab bar)
- **Journal Hub** — Quest Journal and Chronicle share one top-level Journal tab with a tabbed layout

### App Branding
- **Jerboa emblem** (original art, spice-gold, transparent PNG) anchors the top of the desktop navigation rail — tappable to navigate to Dashboard, animates with the collapse toggle
- **Customizable** — Settings > Appearance: pick any image as a custom emblem (PNG-encoded, alpha preserved); restore default with one tap
- Custom emblem is bundled in ZIP backups and restored on import

### Blueprints & Base Calculator
- Full multi-region schematic catalogs: Hagga Rift, Vermillius Gap, Jabal Eifrit, The O'odham, Mysa Tarill, Shield Wall (East + West), Sheol — 12 total regions with T4/T5 patch swap applied
- Per-pool "View by Site" mode; optional auto-start respawn timer on unlock
- Base Calculator Phases 1–5: build planner, saved plans, shareable `dac-v1` export codes, optimization helpers, and built-in templates
- Survival fabricators, refineries, storage, and hauling catalog entries

### Characters & Progression
- Closed-world migration badge per character: dismiss, view migration guide, filter to affected characters
- Character Chronicle (RPG journal): biography, markdown entries, tags, search, location/mood, bundled screenshot backups
- Skill Planner, Class Quest tracker with full trainer route chains, Faction Progress, Augmentation tracker

---

## Fixes

- **KDE Plasma 6 / Linux notifications:** Added `message-new-instant` freedesktop sound hint
- **Android 13+ notifications:** `POST_NOTIFICATIONS`, `VIBRATE`, and `RECEIVE_BOOT_COMPLETED` permissions wired
- **Notification icon:** `assets/app_icon.png` used for Linux notifications
- **Windows notifications:** `WindowsNotificationDetails` wired throughout
- **Test notification button:** Always fires a real OS notification for end-to-end verification
- **Base provider:** Stopped `BaseNotifier` from invalidating its own provider mid-stream
- **Journal editor:** Fixed dialogs widening with long text; themed to match app

---

## Upgrade Notes

- Database schema v18 (was v16 in v1.3.0). Migration is automatic on first launch.
- Export ZIP format unchanged — existing backups import cleanly.

---

## Known Issues

- Field Timer audio requires the app to be in the foreground; OS notifications still fire when backgrounded.
- Field Timer preset durations are community-sourced and may vary by server settings or future patches.
- `BaseManagementScreen` strings not yet localised (English only in this release).

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.4.0-linux-x64.tar.gz` |
| Linux AppImage | `dune-awakening-companion-v1.4.0-linux-x86_64.AppImage` |
| Windows x64 | `dune-awakening-companion-v1.4.0-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.4.0-macos.zip` |
| Android | `dune-awakening-companion-v1.4.0-android.apk` |

---

**Built for the Dune Awakening community**
