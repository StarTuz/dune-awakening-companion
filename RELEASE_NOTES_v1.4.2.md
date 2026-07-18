# Release Notes v1.4.2

**Date:** 2026-07-17
**Status:** Stable Release

Android Field Timer alarms rebuilt on the native alarm-clock architecture — they now ring with the screen off, in Doze, and even if the app has been killed.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Field Timer alarms now use Android's real alarm architecture** — AlarmManager wakes a native foreground service that plays the audio itself on the alarm stream. No dependence on the app being alive.
- **The T=0 page rings continuously** (looping audio + vibration) until you stop it — like a real alarm clock — with a full-screen wake and a Stop button on the notification.
- **Battery-optimization guidance** — the Field Timer screen now warns when OEM battery management could kill background timers and offers a one-tap exemption request.

## Changes

### Field Timers (Android)
- Migrated timer delivery to the `alarm` package (native AlarmManager + foreground service + wake lock). Pre-alarm cues fire as one-shot native alarms with their stage sounds; the T=0 page loops until acknowledged, replacing the previous escalation repeats.
- Full-screen intent lights the screen when the page fires; the notification carries a **Stop alarm** button.
- New battery-optimization exemption banner — OEM battery managers (Samsung, Xiaomi, OnePlus and others) can force-stop apps, which cancels their alarms; exempting the app prevents this. See dontkillmyapp.com for vendor-specific quirks.
- Manifest cleanup: only `USE_EXACT_ALARM` is declared now (auto-granted for alarm-clock use cases); declaring it alongside `SCHEDULE_EXACT_ALARM` is a documented source of inconsistent behavior.
- If native scheduling fails for any reason, in-app audio remains fully active — a silent failure of the alarm path can no longer mean silence.

### Notes
- Desktop platforms are unchanged (in-app audio + OS notifications).
- Custom sound overrides (`field_timer_sounds/` WAVs) still apply to desktop playback and the in-app test button; native Android alarms use the bundled cue sounds.

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.4.2-linux-x64.tar.gz` |
| Linux AppImage | `dune-awakening-companion-v1.4.2-linux-x64.AppImage` |
| Windows x64 | `dune-awakening-companion-v1.4.2-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.4.2-macos.zip` |
| Android | `dune-awakening-companion-v1.4.2-android.apk` |

---

**Built for the Dune Awakening community**
