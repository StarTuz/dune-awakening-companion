# Field Timer Cue Sounds

This guide explains the **pre-alarm beeps** used by **Field Timers** (e.g. solo
sandcrawler harvest windows) and how to replace them with your own `.wav` files.

Field Timer cues are **separate from base power notification sounds**. They play
through the app’s audio engine while a timer is armed — not through your OS
notification theme. See `docs/RESEARCH_FIELD_TIMERS.md` for full feature design.

---

## What you hear during a run

When a sand harvest timer is armed, the app plays **escalating pre-alarm beeps**
before the final page at T=0:

```text
T-90s   ♪        stage 1 — checkpoint
T-60s   ♪♪       stage 2 — wrap up this pass
T-30s   ♪♪♪      stage 3 — close distance to carrier
T=0     PAGE     urgent tone + notification until you acknowledge
```

Default spacing and count are configurable in **Settings → Field Timers**. The
**sound files** for each stage are what this guide covers.

**Important:** Keep the companion app **running** while you play (minimize to
tray on desktop is fine). Quitting the app stops cue playback on all platforms.

---

## Default sounds (bundled)

The app ships short **plain beeps** — not themed Dune SFX — so cues stay
distinct from in-game ambience.

| File | When it plays |
|------|----------------|
| `cue_stage_1.wav` | First pre-alarm |
| `cue_stage_2.wav` | Second pre-alarm |
| `cue_stage_3.wav` | Third pre-alarm |
| `cue_stage_4.wav` | Fourth pre-alarm (if you use 4+ pre-alarms) |
| `cue_page.wav` | T=0 page and escalation repeats until ack |

Bundled copies live in the app at `assets/field_timers/`. You do not need to
copy them anywhere unless you want custom replacements.

---

## Custom sounds (replace defaults)

Drop your own `.wav` files into the app’s **`field_timer_sounds`** folder. Any
file you provide **with the same name** overrides the bundled default for that
stage.

### Folder layout

```text
<app documents>/field_timer_sounds/
├── cue_stage_1.wav
├── cue_stage_2.wav
├── cue_stage_3.wav
├── cue_stage_4.wav
└── cue_page.wav
```

You can override **one stage only** (e.g. just `cue_page.wav`) — missing files
fall back to the bundled default.

### Platform paths

| Platform | App documents directory |
|----------|-------------------------|
| **Linux** | `~/.local/share/dune_awakening_companion/` |
| **Windows** | `%APPDATA%\dune_awakening_companion\` |
| **macOS** | `~/Library/Application Support/dune_awakening_companion/` |
| **Android** | App internal storage (see below) |
| **iOS** | App documents (no manual Finder access on device) |

**Full override path examples:**

- Linux: `~/.local/share/dune_awakening_companion/field_timer_sounds/cue_stage_1.wav`
- Windows: `%APPDATA%\dune_awakening_companion\field_timer_sounds\cue_stage_1.wav`
- macOS: `~/Library/Application Support/dune_awakening_companion/field_timer_sounds/cue_stage_1.wav`

**Android:** Use a file manager with access to app storage, or adb:

```text
/storage/emulated/0/Android/data/com.example.dune_awakening_companion/files/field_timer_sounds/
```

(Exact package path may match your build; **Settings → Field Timers** in the app
will show the resolved folder once the feature ships.)

### Steps

1. Create the `field_timer_sounds` folder under your app documents directory
   (paths above).
2. Add `.wav` files using the **exact filenames** from the table above.
3. Open the app → **Settings → Field Timers** → use **Test all pre-alarms** to
   preview each stage.
4. If a stage still uses the default, check spelling and that the file is `.wav`
   (lowercase extension recommended).

To **revert** a stage, delete its custom file (or rename it). The app uses the
bundled default again on the next play.

---

## File requirements

Designed for **audibility over game audio** — short, clear tones beat long
atmospheric clips.

| Requirement | Recommendation |
|-------------|----------------|
| **Format** | `.wav` (PCM) — required for overrides in Phase 1 |
| **Duration** | Pre-alarms: **≤ 1 second**; page sound: **≤ 3 seconds** (loops on escalation) |
| **Sample rate** | 44.1 kHz |
| **Bit depth** | 16-bit |
| **Channels** | Mono (smaller, plenty loud) |
| **Volume** | Normalized; avoid clipping |
| **Character** | Mid–high pitch beeps; faster rhythm on higher stages |

### Why beeps, not themed sounds?

Themed rumbles and desert ambience are easy to **mistake for in-game audio**.
Plain escalating beeps are boring on purpose — you should hear them over
Dune Awakening’s mix. Optional themed packs may be offered later as **opt-in**
downloads; defaults stay beep-first.

---

## Tips for louder / clearer cues

1. **Use the in-app cue volume slider** (Settings → Field Timers) — independent
   of OS notification volume.
2. **Test before a run** — “Test all pre-alarms” plays every stage in order.
3. **Pick a piercing but short tone** — sine or square beeps around 1–2 kHz
   often cut through better than low rumbles.
4. **Escalate across files** — stage 1: one beep; stage 2: two quicker beeps;
   stage 3: three beeps or rising pitch; page: rapid or continuous urgent tone.
5. **Desktop:** Confirm audio goes to the speaker/headset you wear while gaming
   (system default output). The test button surfaces wrong-device problems early.
6. **Phone beside the keyboard:** Running the app on mobile next to your PC is
   optional — desktop and mobile builds both play cues on their own device when
   the app stays open.

---

## Creating or converting sounds

### Audacity (free)

1. Generate → **Tone** (sine, 880 Hz, 0.25 s) for a single beep.
2. Duplicate and space clips for double/triple beeps on stages 2–3.
3. **Effect → Loudness Normalization** before export.
4. **File → Export → Export as WAV** (Microsoft PCM 16-bit).

### FFmpeg

```bash
# Single 300 ms beep at 1000 Hz
ffmpeg -f lavfi -i "sine=frequency=1000:duration=0.3" -ar 44100 -ac 1 cue_stage_1.wav

# Normalize an existing file
ffmpeg -i my_beep.wav -af loudnorm -ar 44100 -ac 1 cue_stage_1.wav
```

### Free libraries

If you download beeps from the web, check the license. Good search terms:
`UI beep`, `timer beep`, `alert tone short`, `sci-fi beep`.

Sources (verify license per file):

- [Freesound.org](https://freesound.org)
- [Pixabay Sound Effects](https://pixabay.com/sound-effects/)

---

## In the app (after Field Timers ships)

| Control | Purpose |
|---------|---------|
| **Cue volume** | Loudness of all pre-alarm + page playback |
| **Test all pre-alarms** | Plays stages 1→N then page sample |
| **Per-stage indicator** | “Default” vs “Custom” for each file |
| **Open sounds folder** | Copies path or opens folder where supported |

Pre-alarm **count** and **spacing** are timer settings, not sound files — adjust
those in Field Timers settings or on the timer screen.

---

## Troubleshooting

| Problem | Things to try |
|---------|----------------|
| No sound at all | App quit or killed? Keep it running. Check cue volume ≠ 0. Run test button. |
| Only some stages custom | Expected — only overridden filenames replace defaults. |
| Custom file ignored | Exact filename? `.wav` extension? File in `field_timer_sounds`, not `sounds/`. |
| Too quiet over game | Raise cue volume; use brighter/shorter WAV; normalize in Audacity. |
| Wrong speaker (desktop) | Change system default output device; retest. |
| Android: can’t find folder | Use in-app path display; adb push to files directory. |

---

## Related docs

| Document | Contents |
|----------|----------|
| `docs/RESEARCH_FIELD_TIMERS.md` | Feature design, cross-device parity, phases |
| `docs/CUSTOM_SOUNDS.md` | Optional **notification** sound pack (base alerts) — different system |
| `wiki/Notifications.md` | Legacy custom notification paths on some platforms |

---

*Last updated: 2026-06-10*
