# Release Notes v1.4.1

**Date:** 2026-06-30
**Status:** Stable Release

Patch release fixing Field Timer reliability on Android — the timeline now survives Doze/standby end-to-end, with no more silent failures.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Android Field Timer alarms now actually fire.** The OS owns the entire timeline (pre-alarm cues, T=0 page, and escalations) as exact `AlarmManager` wakeups, so nothing depends on the Dart isolate staying alive while the phone sleeps.
- **No more silent failure.** If the device hasn't granted the exact-alarm permission, the app now tells you and offers a one-tap fix instead of quietly dropping every notification.

## Fixes

- **Field Timer audio on standby:** In-app cues route through the Android alarm stream (bypasses silent/DND, keeps the device awake while playing) instead of the default media stream.
- **Pre-alarm cues dying on sleep:** `arm()` now pre-schedules every cue, the T=0 page, and 20 escalation repeats as exact `AlarmManager.setAlarmClock()` wakeups at arm time, rather than scheduling escalations from Dart code at T=0 — code that never runs if the phone is already asleep. Cue audio is baked into per-stage notification channels as Android raw resources so the OS plays the sound itself.
- **Silent failure on missing permission:** Root cause of "no sound at all" reports — `AndroidScheduleMode.alarmClock` throws when the "Alarms & reminders" permission isn't granted (denied by default on Android 12/13). The app now verifies the permission before relying on it, falls back to a best-effort inexact schedule when denied, and shows a banner with a direct link to grant it. The Field Timer screen re-checks on entry and on app resume.
- **Countdown drift after suspension:** The on-screen countdown was tick-counted, so a Doze freeze let the UI fall behind the OS-scheduled alarms. It's now anchored to a wall-clock timestamp and re-derives elapsed time from `DateTime.now()` on every tick, snapping back to the true remaining time (including straight into the firing state) after any suspension.

## Known Issues

- Field Timer preset durations are community-sourced and may vary by server settings or future patches.
- Custom user override WAVs still apply to desktop and the in-app test button only; scheduled Android cue sounds use the bundled WAVs baked into the notification channels.

---

## Upgrade Notes

- Database schema unchanged (still v18). No migration required.
- Export ZIP format unchanged — existing backups import cleanly.

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.4.1-linux-x64.tar.gz` |
| Linux AppImage | `dune-awakening-companion-v1.4.1-linux-x86_64.AppImage` |
| Windows x64 | `dune-awakening-companion-v1.4.1-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.4.1-macos.zip` |
| Android | `dune-awakening-companion-v1.4.1-android.apk` |

---

**Built for the Dune Awakening community**
