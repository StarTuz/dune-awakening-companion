# Field Timers — Research & Assessment

Status: **Implemented** (v1.4.0, with Android reliability fixes in v1.4.1).
Originally a proposal for short-horizon, user-initiated harvest windows
(starting with solo sandcrawler aggro reset timing); this doc is kept as the
design record for the shipped Field Timers feature.

This document assesses a **Field Timers** feature: dedicated, high-urgency
countdown timers for in-session gameplay moments that need **PagerDuty-style
incident handling** (arm → fire → escalate → acknowledge) rather than the app's
existing **monitoring-style base power alerts** (periodic DB scan → batch notify).

Primary use case: **solo sandcrawler harvesting**, where sandworm aggro may
breach without reliable wormsign, forcing a rushed carrier pickup to reset aggro
before losing a high-value vehicle investment.

Related local research artifacts (not committed by default):

- `dune-sandcrawler-timer-research.json`
- `dune-sandcrawler-wormsign-research.json`
- `field-timer-audio-cue-research.json`
- `field-timer-audio-tech-research.json`

---

## Executive summary

| Question | Answer |
|----------|--------|
| Does the problem make sense? | **Yes.** Solo sand crawling is a minutes-scale, high-stakes window with unreliable in-game warnings. |
| Should this use the default notification pipeline? | **No.** Base alerts are pull-based (15–60 min), batched, quiet-hours-aware, and DB-derived. Harvest timers are push-based, second-accurate, user-armed, and need escalation until acknowledged. |
| Right abstraction? | **PagerDuty incident lifecycle** (trigger, ack, escalate, resolve) — not enterprise on-call features. |
| Is a single alarm at T=0 enough? | **No.** The player is in a fullscreen game; the design must be **audio-first and eyes-free**: a staged **pre-alarm cue track** (escalating beeps at intervals) followed by the final page. Matches boxing/interval-timer and alarm human-factors research. |
| Are defaults authoritative? | **No.** Research seeds defaults only (~3:30 community baseline → 3:00 conservative default); **every timing parameter is user-customizable** (duration, cue count, cue spacing). |
| Cross-device behavior? | **Same audible cue track on every platform.** Desktop and mobile must deliver identical pre-alarm + page audio when a session is armed — players are in-game regardless of device. Platform differences (tray vs vibration) are additive, not substitutes for hearing cues. |
| Phase 1 cue sounds? | **Escalating beeps as bundled `.wav` files** — short, high-contrast tones that cut through game audio. Themed/Dune SFX deferred (risk of blending into the mix). Users can **replace default WAVs** via a documented folder; see *Cue sound assets* below. |
| Recommended module? | New `lib/features/field_timers/` parallel to `alerts/`, not an extension of `Base` or `AlertCheckerService`. |
| Data confidence? | **Community-sourced.** No official Funcom timer; durations vary by loadout (e.g. Dampened Treads). User-calibrated presets with disclaimers. |

---

## Background (game side)

### Solo sandcrawler loop

The Sandcrawler is a ground vehicle for harvesting large volumes of **Spice
Sand** (not Flour Sand). It requires a **Carrier** to reposition and a
**Centrifuge** module for storage. Harvesting creates **vibrations** that attract
sandworms.

Typical solo loop (community-sourced):

1. Land carrier, deploy sandcrawler on spice sand, activate vacuum.
2. Harvest until worm threat builds.
3. **Reset aggro:** enter carrier, pick up sandcrawler, lift off (and optionally
   relocate).
4. Land again and repeat.

References:

- [Sandcrawler — awakening.wiki](https://awakening.wiki/Sandcrawler) — modules,
  **Dampened Treads** (lower vibration → potentially more harvest time).
- [Reddit: Is it possible to solo sandcrawling?](https://www.reddit.com/r/duneawakening/comments/1ngq04t/is_it_possible_to_solo_sandcrawling/) —
  manual aggro reset by picking up crawler; one player reports using a
  **stopwatch** and worm arrival after **~3m30s** with unique sandcrawler
  threads.
- [Reddit: Let's talk solo sandcrawling](https://www.reddit.com/r/duneawakening/comments/1od7bdl/lets_talk_solo_sandcrawling/) —
  when orange wormsign / “jaws” audio appears, experienced players reset aggro
  in the carrier; breach in the crater is “rolling dice.”
- [Reddit: Sandcrawler instant worm aggro / workflow](https://www.reddit.com/r/duneawakening/comments/1m5leee/sandcrawler_instant_worm_aggro/) —
  carrier → grab crawler → deploy → vacuum cycle.

### Why in-game feedback is insufficient for solo crawls

- **Ornithopter / compactor harvesting** exposes a vibration meter; players fly
  up and wait **15–30 seconds** for the meter to clear
  ([Fandom sandworm guide](https://duneawakening.fandom.com/wiki/Dune_Awakening_Sandworm_Mastery_Guide)).
- **Sandcrawler** reports describe **missing or unreliable wormsign** (orange UI,
  jaws audio) — players compensate with external timers
  ([Reddit: wormsign bug on sandcrawler](https://www.reddit.com/r/duneawakening/comments/1m479ow/how_the_hell_do_you_use_the_sandcrawler_without/)).
- Pickup sequence is slow: exit crawler, reach carrier, take off, grab crawler,
  gain altitude — even a late warning can be fatal
  ([Reddit: solo sandcrawler difficulty](https://www.reddit.com/r/duneawakening/comments/1ldele3/any_solo_players_have_success_with_sandcrawler/)).
- Worm breach behavior is lethal and fast once surfaced
  ([GamesRadar: escaping sandworms](https://www.gamesradar.com/games/survival/dune-awakening-sandworms/)).

### Timing is not a single constant

| Factor | Effect on safe window |
|--------|------------------------|
| **Dampened Treads** | Lower vibration → longer before aggro (wiki-sourced) |
| **Unique sandcrawler threads** | Community report ~3m30s baseline for one loadout |
| **Field size / overlap pattern** | Longer continuous vibration → sooner breach |
| **Other players compacting nearby** | Can draw worm activity |
| **Bugs / missing wormsign** | Forces conservative (early) external timers |

**Product implication:** presets must be **user-adjustable**, not hard-coded as
game truth. Default conservatively (page early).

---

## App side — current notification model

### What exists today

| Pattern | Location | Behavior |
|---------|----------|----------|
| **Base power alerts** | `NotificationCoordinator`, `AlertCheckerService` | Periodic scan (15/60 min desktop; WorkManager mobile); quiet hours skip; max 5 notifications per check; critical/warning channels |
| **Quest reminders** | `QuestReminderService`, `quest_reminder_at` on `Quest` | One-shot OS schedule (Android/iOS only); desktop fires when app foreground/resumed via `QuestReminderLifecycle` |
| **Blueprint respawn timer** | `blueprint_tracker_screen.dart` `_RespawnTimerChip` | In-UI `StreamBuilder` countdown only — **no OS notification**; fixed 45 min schematic estimate |

### Why base alerts are the wrong fit

```text
Base power alert:     [DB state] → [periodic poll] → [maybe notify] → [done]
Sand harvest timer:   [user arms] → [count down] → [PAGE at T=0] → [escalate until ack]
```

Concrete mismatches:

1. **Resolution:** 15–60 minute poll interval vs. 2–4 minute harvest windows.
2. **Quiet hours:** `NotificationCoordinator` skips all checks during DND;
   active harvesting may intentionally happen at any hour.
3. **Spam cap:** `maxNotifications = 5` per check is wrong for “page until ack.”
4. **Semantics:** Power alerts are **informational monitoring**; harvest timers
   are **action-required incidents**.
5. **Desktop:** Quest reminders do not schedule OS notifications on Linux/Windows
   today — sand crawling needs stronger desktop behavior (tray badge, repeat
   alerts while app runs, optional mini overlay).

**Conclusion:** Implement Field Timers as a **separate notification channel and
state machine**. Reuse `NotificationService` plugin instance and Riverpod patterns;
do **not** route through `NotificationCoordinator.checkAndNotify`.

---

## PagerDuty-lite mapping

Borrow **incident lifecycle** concepts only:

| PagerDuty | Field Timer equivalent |
|-----------|------------------------|
| Incident | One armed harvest window (`FieldTimerSession`) |
| Trigger | Countdown reaches zero (preceded by the pre-alarm cue track) |
| Urgency | High / critical channel; distinct sound |
| Acknowledge | User taps “Crawler picked up” → restart or resolve |
| Escalate | Re-notify every N seconds until ack (configurable) |
| Resolve | “End run” / safe landing — stop escalation |
| Suppression | **Not** global quiet hours by default; optional per-timer bypass toggle |

**Explicitly out of scope:** on-call schedules, rotations, integrations, SLA
dashboards, multi-user paging, runbook CMS.

---

## Audio-first, eyes-free design (key constraint)

The player is **inside a fullscreen game** while the timer runs. Visual
notifications (toasts, banners, tray badges) are secondary at best. The primary
output channel is **sound** — the user must be able to track timer progress
without looking at the companion app at all.

### Prior art

- **Boxing / round timers** ship a warning signal before the round ends — e.g.
  a "3-clap warning 10 seconds before the end" in addition to start/end bells
  ([HeavyBag Pro boxing timer](https://heavybag.pro/boxingtimer/)).
- **Interval training apps** (HIIT/Tabata) speak interval names, provide
  warnings for upcoming intervals, and keep running audio in the background
  while other apps are in use
  ([Seconds Interval Timer](https://apps.apple.com/us/app/seconds-interval-timer/id475816966)).
- **Alarm human-factors research** encodes urgency in the sound itself: a
  single note for low urgency, three notes for medium, a ten-note pattern for
  high — temporal variation improves learnability and detectability
  ([Re-Sounding Alarms — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7711797/)).
  Cross-industry guidance: urgency rises with short simple tones, fast regular
  rhythms that speed up over time, higher frequencies, and more obtrusive sounds
  ([Patient Safety Journal — alarm design](https://patientsafetyj.com/article/73905-informing-healthcare-alarm-design-and-use-a-human-factors-cross-industry-perspective)).

### Pre-alarm cue track (core requirement, not polish)

A single alarm at T=0 is insufficient: by the time it fires the player may
already be out of margin. Instead, the armed window emits a **configurable
sequence of pre-alarm cues** so the player can pace the return to the carrier:

```text
Example: 3:00 window, 3 cues at 30s spacing

T-90s   ♪        (1 beep   — "checkpoint")
T-60s   ♪♪       (2 beeps  — "wrap up this pass")
T-30s   ♪♪♪      (3 beeps  — "close distance to carrier NOW")
T=0     ♪♪♪♪♪…   (page     — continuous/urgent + OS notification + escalation)
```

Design rules derived from the research:

1. **Each cue stage must be distinguishable by ear alone** — escalate beep
   count, rhythm, and/or pitch per stage so the player knows *which* warning
   fired without alt-tabbing.
2. **Cue count and spacing are user-configurable** (e.g. 2–6 cues, 15/30/45/60s
   spacing) — players pace differently based on field layout and distance to
   carrier.
3. **Optional voice cues** (Phase 2+): spoken "one minute" / "thirty seconds —
   head to carrier," mirroring interval-timer apps. Pre-recorded clips fit the
   existing optional sound-pack distribution model; TTS is a heavier
   alternative.

### Two output channels (architectural consequence)

| Channel | Used for | Mechanism |
|---------|----------|-----------|
| **Cue audio** | Pre-alarm beeps during the armed window | **Direct audio playback in-app** (e.g. `audioplayers`, which supports Linux/Windows/macOS/Android/iOS) — *not* OS notifications |
| **Page** | T=0 fire + escalation repeats | OS notification on `field_timers` channel **plus** continuous/urgent cue audio |

Rationale for not using OS notifications for cues:

- 3–4 notifications per harvest cycle (×many cycles per session) would flood
  the notification center and history.
- Linux notification sounds depend on the desktop theme/daemon and can be
  quiet, themed away, or suppressed — unacceptable for a safety-critical cue.
- Direct playback gives control over volume, repetition, and stage-distinct
  tones, independent of OS notification settings.

The OS notification at T=0 remains valuable: it persists on screen if the
player tabs out, appears on mobile lock screens, and survives brief app focus
loss.

### Audibility over game audio

- Cues must occupy a frequency/rhythm profile that cuts through game ambience
  (research above: higher frequencies, fast regular rhythms).
- Provide a **dedicated cue volume slider** + **test button** in settings —
  independent of OS notification volume.
- **Cross-device parity:** whether the player arms the timer on Linux, Windows,
  macOS, Android, or iOS, the **same cue schedule, same WAV assets, and same
  volume slider** must produce the same audible result during an active session.
  Platform-specific extras (vibration on mobile, tray label on desktop) do not
  replace cue audio.
- Optional tip (not a requirement): desktop players *may* also run the app on a
  phone beside the keyboard for vibration + a separate speaker — but mobile and
  desktop builds must each be fully usable on their own.

### Cross-device audio parity (requirement)

Field Timers are used **while playing**. Device choice is about convenience, not
capability:

| Expectation | Detail |
|-------------|--------|
| **Same cue logic** | Identical schedule generation, stage escalation, and T=0 page behavior on all targets |
| **Same sound files** | One set of default `.wav` assets; same override filenames/paths relative to app storage |
| **Same volume control** | Cue volume slider applies to direct playback everywhere — not tied to OS notification volume |
| **Same test UX** | Settings “Test” plays each stage in order on every platform |
| **App must stay running** | Cues use in-app audio playback; the companion must remain open (minimized/tray OK on desktop). Document this clearly — killing the app stops cues on all platforms equally |

Implementation guardrails:

- Single `FieldTimerAudioService` API used by all platforms — no Linux-only or
  mobile-only cue code paths except where the underlying player requires it.
- CI/manual smoke: arm a 30s test session on **at least one desktop + one
  mobile** target; confirm all cue stages are heard.
- Do **not** rely on OS notification sounds for cues (Linux theme sounds vary;
  would break parity).

### Phase 1 cue sound decision — escalating beeps (`.wav`)

**Decision:** Phase 1 ships **plain escalating beeps**, not themed Dune SFX.

| Choice | Rationale |
|--------|-----------|
| **Beeps over themed sounds** | Short tonal bursts are easier to distinguish from in-game ambience (wind, worm rumbles, UI). Themed sounds risk being ignored or mistaken for game audio. |
| **`.wav` format** | Uncompressed/low-latency; widely supported by `audioplayers` on Linux/Windows/macOS/Android/iOS; easy for users to swap. |
| **User-replaceable** | Power users can drop in louder/custom clips without a rebuild — same philosophy as the optional notification sound pack (`docs/CUSTOM_SOUNDS.md`). |

**Bundled defaults** (ship in repo under `assets/field_timers/`):

| File | Stage | Character |
|------|-------|-----------|
| `cue_stage_1.wav` | Pre-alarm 1 | Single mid-high beep (~200–400 ms) |
| `cue_stage_2.wav` | Pre-alarm 2 | Double beep, slightly higher pitch |
| `cue_stage_3.wav` | Pre-alarm 3 | Triple beep, faster rhythm |
| `cue_stage_4.wav` | Pre-alarm 4+ (if count > 3) | Quadruple or rising tone (optional; reuse pattern for stages 4–6) |
| `cue_page.wav` | T=0 page + escalation | Continuous or rapid urgent tone until ack |

Keep clips **short** (≤ 1 s per stage except page loop). Normalize peak levels
so stages feel louder/more urgent without clipping.

**User overrides** (document in `docs/CUSTOM_SOUNDS.md` or a dedicated
`docs/FIELD_TIMER_SOUNDS.md` section):

```text
<app documents>/field_timer_sounds/
├── cue_stage_1.wav   # replaces bundled stage 1 if present
├── cue_stage_2.wav
├── cue_stage_3.wav
├── cue_stage_4.wav
└── cue_page.wav
```

Resolution order per stage: **user override → bundled asset → silent fallback
with debug log**. Settings UI shows the active path (“Using custom sound” vs
“Default”) and links to the doc. No file picker required for MVP — folder drop is
enough and matches how power users already manage notification sounds.

**Deferred (Phase 2+):** optional “Field Timer sound pack” with themed clips;
voice cues; in-app file picker. Themed pack must remain **opt-in** so defaults
stay beeps-first.

---

## Product recommendation

### Feature name

**Field Timers** (umbrella) with first preset **Sand Harvest** / **Sandcrawler
Window**. Leaves room for future presets (Deep Desert “off sand,” schematic
respawn push notification, etc.) without renaming.

### Placement

- **Phase 1:** Dedicated screen reachable from Dashboard quick action and/or
  Characters screen (player is mid-session, needs fast access).
- **Not** buried in Settings or fused into Base tracking.
- **Optional later:** Compact nav entry if preset library grows.

### Core UX (MVP)

1. **Arm** — large “Start harvest window”; preset chips (e.g. 2:30, 3:00, 3:30,
   4:00) + custom duration picker. **All values editable** — presets seed, never
   constrain.
2. **Live countdown** — full-width, high-contrast timer visible while app is
   open (stronger than blueprint `_RespawnTimerChip`), with cue-stage markers
   on the progress bar.
3. **Pre-alarm cue track** — escalating audio cues at configurable intervals
   (default: 3 cues at 30s spacing → T−90/T−60/T−30), played via in-app audio,
   distinguishable by ear per stage. See *Audio-first design* above.
4. **Fire at T=0** — OS notification on dedicated channel `field_timers` +
   urgent continuous cue audio.
5. **Escalate** — repeat notification + audio + vibration until acknowledged.
6. **Ack actions:**
   - **“Reset aggro”** — restart timer from now (new incident).
   - **“End run”** — resolve and stop escalation.
7. **Disclaimer** — community-sourced timing; calibrate to your loadout; not
   affiliated with Funcom.

### Settings (separate from base notification settings)

All defaults are research-seeded starting points; **every value below is
user-customizable**.

| Setting | Default | Notes |
|---------|---------|-------|
| Default duration | 3:00 | Conservative vs. reported ~3:30; editable per run |
| Pre-alarm cue count | 3 | Range 0–6; 0 disables cue track |
| Pre-alarm spacing | 30s | 15/30/45/60s or custom; counted back from T=0 |
| Cue style | Escalating beeps (`.wav`) | Plain tones Phase 1; themed pack Phase 2+ opt-in |
| Custom cue files | Optional folder override | See *Cue sound assets*; doc linked from Settings |
| Cue volume | 80% | Independent slider + per-stage test button (separate from OS notification volume) |
| Escalation interval | 15s | Repeat page interval after T=0 |
| Max escalations | Unlimited while armed | Or cap at e.g. 20 to avoid battery drain |
| Bypass quiet hours | **On** for field timers | Toggle for users who want DND everywhere |
| Vibration | On (mobile) | Additive to cue audio — does not replace it |

---

## Proposed architecture

### Module layout

```text
lib/features/field_timers/
├── models/
│   ├── field_timer_preset.dart       # id, label, duration, cue schedule
│   ├── field_timer_cue.dart          # offset-from-zero, stage (1..n), sound ref
│   └── field_timer_session.dart      # state machine payload + fired-cue tracking
├── services/
│   ├── field_timer_service.dart      # arm, tick, cue dispatch, ack, resolve
│   ├── field_timer_audio_service.dart       # cue playback (audioplayers), volume, test
│   └── field_timer_notification_service.dart  # T=0 page channel, escalation
├── providers/
│   └── field_timer_provider.dart
├── screens/
│   └── field_timer_screen.dart
└── widgets/
    ├── active_timer_banner.dart      # global banner when session live
    └── sand_harvest_preset_chips.dart
```

**New dependency:** an audio playback package for the cue track — recommend
`audioplayers` (cross-platform incl. Linux/Windows desktop; see
[feature parity table](https://github.com/bluefireteam/audioplayers/blob/main/feature_parity_table.md)).

**Cue sound assets:** bundle escalating beep `.wav` files under
`assets/field_timers/` (see *Phase 1 cue sound decision*). Register in
`pubspec.yaml`. `FieldTimerAudioService` resolves user overrides from
`<app documents>/field_timer_sounds/` first, then bundled assets — same logic on
all platforms.

### State machine

```text
        ┌──────┐
        │ Idle │
        └──┬───┘
           │ Start(duration, cueSchedule)
           ▼
        ┌──────┐   cue fires at each T−offset (audio only,
        │ Armed│   stage 1..n, each fires exactly once)
        └──┬───┘
           │ T = 0
           ▼
      ┌─────────┐
      │ Firing  │◄──┐
      └────┬────┘   │ escalate every N sec
           │        │ (notification + audio)
           ├────────┘
           │
           ├── Ack + Restart ──► Armed (fresh cue schedule)
           └── Ack + End ──────► Idle
```

Cue dispatch is part of the **armed** state's 1s tick: when remaining time
crosses a cue offset, play that stage's sound once and mark it fired (no OS
notification). Restart resets all fired-cue flags.

### Persistence

| Phase | Storage |
|-------|---------|
| **MVP** | In-memory session + `SharedPreferences` for default duration / last preset |
| **Later** | Optional `field_timer_sessions` table for history/stats; export/import |

No coupling to `bases` or `characters` tables in MVP. Optional `characterId` link
in Phase 2 for “this run on Character X.”

### Notification integration

Add to `NotificationService` (or thin wrapper):

- Android channel `field_timers` — `Importance.max`, distinct name/description.
- Methods: `scheduleFieldTimerFire`, `showFieldTimerEscalation`,
  `cancelFieldTimerNotifications(sessionId)`.
- **Do not** reuse `critical_alerts` channel IDs or `baseId.hashCode` IDs.

### Desktop-specific

While app is running (minimized to tray is OK — **app must not be quit**):

- Dedicated `Timer.periodic` (1s) in `FieldTimerService` — do not depend on
  `NotificationCoordinator` interval.
- **Same cue audio path as mobile** via `FieldTimerAudioService` + bundled/overridden `.wav` files.
- System tray: show remaining time in menu label when session active.
- Optional Phase 2: small always-on-top countdown window.

When app is backgrounded/killed:

- Cues stop (same as mobile if app is swiped away). Document clearly.
- T=0 page: Phase 2 investigate `zonedSchedule` on Linux/Windows if plugin supports it.

### Mobile-specific

- **Same cue audio path as desktop** via `FieldTimerAudioService` + bundled/overridden `.wav` files.
- Prefer `zonedSchedule` for the T=0 page while app may be backgrounded.
- Request exact alarm permission on Android 12+ where required.
- **Do not update an ongoing notification every second** for the countdown —
  Android throttles/penalizes this and users can dismiss ongoing notifications
  on Android 13+ ([Stack Overflow](https://stackoverflow.com/questions/75562003/android-13-user-can-dismiss-notification-even-after-setting-setongoingtrue)).
  Use a chronometer-style notification (`usesChronometer`) if a persistent
  countdown notification is wanted.
- If backgrounded cue playback proves necessary, evaluate a foreground service
  (`mediaPlayback` type avoids special-use justification per community reports —
  [r/androiddev](https://www.reddit.com/r/androiddev/comments/1lg7yup/foreground_service_type_for_a_countdown_timer/));
  defer until demand is proven.
- Consider full-screen intent for T=0 (high attention) — evaluate UX intrusiveness.
- Keep screen awake while a session is armed (e.g. `wakelock_plus`) so the
  countdown stays glanceable on a desk-mounted phone.

---

## Phased delivery

### Phase 1 — Sand Harvest MVP

**Goal:** Validate that players use an external timer during crawls.

- Single preset family: sand harvest durations; all values customizable.
- Start / cancel / ack-restart / ack-end.
- **Pre-alarm cue track** — escalating **`.wav` beeps** via in-app audio
  (configurable count + spacing; user-replaceable sound files) — core, not polish.
- Bundled default beeps under `assets/field_timers/`; user override guide in
  `docs/FIELD_TIMER_SOUNDS.md`.
- Live countdown UI with cue-stage markers + T=0 page with escalation.
- Cue volume slider + **per-stage test button** (verify audibility before a run).
- Separate settings block (or section under Settings → Field Timers).
- Cross-platform smoke: cues audible on desktop **and** mobile with same files.
- Unit tests: state machine transitions, cue schedule generation (each cue
  fires exactly once; restart resets), audio path resolution (override vs bundled),
  escalation ID uniqueness.
- Widget test: arm → countdown visible → fire state UI.
- i18n: all user strings in 7 ARB locales.

**Out of scope:** DB migration, character linkage, history, voice cues, themed sound pack.

### Phase 2 — Polish & platform parity

- Global active-timer banner when navigating other tabs.
- Tray / taskbar integration on desktop.
- **Calibration helper:** “Worm arrived” button while armed/firing logs the
  actual elapsed time and suggests an adjusted default (e.g. observed minus
  pickup-sequence buffer). Turns the community ~3:30 anecdote into a
  per-loadout measured value.
- **Loop / round mode:** the crawl loop is interval training — auto-cycle
  *harvest window* (e.g. 3:00) → *reset/redeploy window* (e.g. 0:30) like a
  boxing round timer, with ack only needed to stop or extend.
- Voice cues and **optional themed Field Timer sound pack** (opt-in; defaults
  remain beeps).
- Bypass-quiet-hours toggle (default on).
- Custom duration picker with persistence.

### Phase 3 — Preset library

Additional timer types (each with own defaults and copy):

| Preset | Trigger moment | Typical duration |
|--------|----------------|------------------|
| Sand harvest (default) | Crawler deployed | ~2:30–4:00 user-tuned |
| Aggro reset cooldown | After pickup, before redeploy | ~15–30s (ornithopter meter parity) |
| Schematic respawn | On blueprint unlock | 45 min (align with blueprint tracker) |
| Deep Desert “off sand” | Custom player note | User-defined |

Blueprint respawn could **optionally** push-notify when the in-app chip already
shows “ready” — bridging UI timer to OS alert.

### Phase 4 — Optional enhancements

- Per-character last-used preset + calibration history.
- Global hotkey on desktop (e.g. via `hotkey_manager`) to restart/ack without
  alt-tabbing out of the game.
- Session log / “runs this week” analytics (local only).
- Haptic pattern customization.
- Wearable / second-screen glance (future).

---

## Testing strategy

| Layer | Cases |
|-------|-------|
| **Unit** | State machine: idle→armed→firing→ack; cancel from armed; escalation counter; cue schedule generation (correct offsets for count × spacing; each cue fires exactly once; cues beyond duration are dropped; restart resets fired flags) |
| **Widget** | Preset selection; countdown formatting; cue-stage markers render; firing UI shows ack buttons |
| **Integration** | Arm timer → mock audio + notification services → cue stages dispatched in order → ack clears scheduled notifications and stops audio |
| **Manual** | Android backgrounded; desktop minimized to tray; cue audibility over game audio; verify escalation stops on ack |

---

## Risks and mitigations

| Risk | Mitigation |
|------|------------|
| **Wrong default duration** → false confidence | Conservative default (3:00 not 3:30); prominent “calibrate to your build” copy; Phase 2 calibration helper |
| **Cues inaudible over game audio** | Dedicated volume slider + test button; high-frequency/fast-rhythm cue design; recommend phone-as-second-device in copy |
| **Cue stages confused with each other** | Distinct count/pitch/rhythm per stage (alarm-design research); preview each stage in settings |
| **Wrong audio output device (desktop)** | Cues follow system default sink; document; test button surfaces the problem before a run |
| **Funcom changes aggro timing** | User presets; no claim of official values |
| **Quiet hours confusion** | Separate toggle; explain difference from base alerts in UI |
| **Notification fatigue** | Cues are audio-only (no notification center entries); escalation only while session unresolved; clear End run |
| **Desktop background gaps** | Document; tray + in-app banner; Phase 2 scheduling research |
| **Legal / disclaimer** | Same unofficial fan-app framing as rest of app |

---

## i18n keys (draft)

Prefix: `fieldTimer*` — examples for `app_en.arb`:

- `fieldTimerTitle` — “Field Timers”
- `fieldTimerSandHarvest` — “Sand harvest window”
- `fieldTimerStart` — “Start timer”
- `fieldTimerResetAggro` — “Crawler picked up — restart”
- `fieldTimerEndRun` — “End run”
- `fieldTimerFiringTitle` — “Reset aggro now”
- `fieldTimerFiringBody` — “Sand harvest window elapsed. Pick up your sandcrawler.”
- `fieldTimerDisclaimer` — “Timing is community-sourced and varies by loadout. Not official game data.”
- `fieldTimerBypassQuietHours` — “Allow during quiet hours”
- `fieldTimerPreAlarms` — “Pre-alarms”
- `fieldTimerPreAlarmCount` — “Number of pre-alarms”
- `fieldTimerPreAlarmSpacing` — “Spacing between pre-alarms”
- `fieldTimerCueVolume` — “Cue volume”
- `fieldTimerTestCue` — “Test sound”
- `fieldTimerTestAllCues` — “Test all pre-alarms”
- `fieldTimerCueStageHint` — “Each pre-alarm sounds more urgent than the last.”
- `fieldTimerCustomSoundActive` — “Using custom sound”
- `fieldTimerDefaultSound` — “Default sound”
- `fieldTimerSoundsDocLink` — “How to use custom cue sounds”
- `fieldTimerKeepAppOpenHint` — “Keep the app running (minimize OK) to hear pre-alarms.”

Translate to all 7 locales before merge; run `flutter gen-l10n`.

---

## Documentation cross-links

When implemented, update:

- `README.md` — Features + roadmap
- `HANDOFF.md` — module index + notification section
- `docs/ROADMAP_2026.md` — product line item
- `docs/FIELD_TIMER_SOUNDS.md` — user guide for custom cue `.wav` overrides
- `docs/CUSTOM_SOUNDS.md` — notification sound pack (separate from Field Timer cues)
- `EXTENSIBILITY_GUIDE.md` — only if new patterns (e.g. escalation service) warrant it

---

## References

### Game / community

- [Sandcrawler — awakening.wiki](https://awakening.wiki/Sandcrawler)
- [Reddit: Is it possible to solo sandcrawling?](https://www.reddit.com/r/duneawakening/comments/1ngq04t/is_it_possible_to_solo_sandcrawling/)
- [Reddit: Let's talk solo sandcrawling](https://www.reddit.com/r/duneawakening/comments/1od7bdl/lets_talk_solo_sandcrawling/)
- [Reddit: Sandcrawler wormsign bug](https://www.reddit.com/r/duneawakening/comments/1m479ow/how_the_hell_do_you_use_the_sandcrawler_without/)
- [Reddit: Solo sandcrawler difficulty](https://www.reddit.com/r/duneawakening/comments/1ldele3/any_solo_players_have_success_with_sandcrawler/)
- [Dune Awakening Sandworm Mastery Guide — Fandom](https://duneawakening.fandom.com/wiki/Dune_Awakening_Sandworm_Mastery_Guide)
- [GamesRadar: escaping sandworms](https://www.gamesradar.com/games/survival/dune-awakening-sandworms/)

### Audio cue / alarm design

- [HeavyBag Pro boxing timer](https://heavybag.pro/boxingtimer/) — 3-clap warning 10s before round end
- [Seconds Interval Timer](https://apps.apple.com/us/app/seconds-interval-timer/id475816966) — spoken upcoming-interval warnings, background audio
- [Re-Sounding Alarms — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7711797/) — urgency via note count (1/3/10)
- [Patient Safety Journal — alarm design](https://patientsafetyj.com/article/73905-informing-healthcare-alarm-design-and-use-a-human-factors-cross-industry-perspective) — urgency via rhythm/frequency/obtrusiveness

### Implementation tech

- [audioplayers feature parity table](https://github.com/bluefireteam/audioplayers/blob/main/feature_parity_table.md) — desktop + mobile playback
- [Stack Overflow: Android 13 dismissable ongoing notifications](https://stackoverflow.com/questions/75562003/android-13-user-can-dismiss-notification-even-after-setting-setongoingtrue)
- [r/androiddev: foreground service type for countdown timers](https://www.reddit.com/r/androiddev/comments/1lg7yup/foreground_service_type_for_a_countdown_timer/)

### App internals

- `lib/core/services/notification_coordinator.dart` — periodic base alerts
- `lib/core/services/notification_service.dart` — plugin + channels
- `lib/features/quest_journal/services/quest_reminder_service.dart` — one-shot reminders
- `lib/features/blueprints/screens/blueprint_tracker_screen.dart` — in-UI respawn countdown pattern

---

*Last updated: 2026-06-10 (cross-device parity + Phase 1 WAV beep decision)*
