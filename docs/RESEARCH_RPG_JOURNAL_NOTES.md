# Player RPG Journal and Notes — Design Doc

Last updated: 2026-05-30

This document proposes a **per-character RPG journal and notes** feature: a place
for players to chronicle their character's story, keep freeform notes, and tag
entries. It consolidates the long-standing idea sketched in `NEXT_STEPS.md`
(item #6, "RPG Elements & Storytelling") into a current, implementable design
reconciled with the live schema (DB v12).

Status: **Phases 1–3 implemented.**
- Phase 1: migration 013, `lib/features/journal/`, Journal tab in
  `CharacterProgressDialog`, ZIP export/import, 7-locale strings, tests.
- Phase 2: migration 014 — `characters.biography` (editable from the Journal
  tab) plus optional `location`/`mood` per entry; entry search and tag
  filter chips.
- Phase 3: migration 015 — optional `quest_id` link and `image_path`
  screenshot per entry, plus a parchment/aged-paper theme on the journal
  surface.

**Deferred:** true Markdown rendering/editor for entry bodies. The Flutter
team discontinued `flutter_markdown` in 2025; a maintained drop-in successor
now exists (`flutter_markdown_plus`, see the expansion analysis below), so
this is a ready-to-pick Phase 4 item rather than a blocked one. Cursive
Google Fonts are likewise deferred to avoid a network font dependency; the
parchment theme uses italics + warm tones instead. Journal screenshots are
stored as local file-path links and are not yet bundled into the ZIP backup.

---

## Why this, why now

- **Blueprints are stable**, so the next product slice can be a lighter,
  self-contained feature without external game-data dependencies.
- The feature is **fully local** — no guide scraping, no catalog maintenance,
  no in-game validation burden (unlike blueprints/skills). The data is
  player-authored, so it can't go stale against patches.
- It plays to a documented community strength: players are gholas with rich
  roleplay potential, and the in-game journal is limited.

---

## What already exists today (avoid duplication)

| Capability | Where | Scope |
|------------|-------|-------|
| Per-**quest** notes | `quest_journal/models/quest.dart` | Task-scoped, attached to a tracked quest |
| Per-**step** notes | `quest_journal/models/quest_step.dart` | Task-scoped, attached to a quest step |
| Character biography / freeform journal | **does not exist** | `Character` has no `biography`/notes field |

**Conclusion:** the quest journal covers *task* notes. There is **no
character-level chronicle**. This feature fills that gap and should not
re-implement quest-step notes.

---

## Recommended scope (phased)

Start small and ship value early; defer anything that adds maintenance or
platform risk.

### Phase 1 — Journal MVP (recommended first slice)
- Per-character chronological **journal entries**: title, body (plain text),
  timestamp (auto, editable).
- Create / edit / delete entries.
- Free-text **tags** (comma-separated), filterable.
- Reverse-chronological **timeline list** with empty state.
- Included in ZIP **export/import**.
- Localized strings; at least one unit/widget/integration test.

### Phase 2 — Character biography + light polish
- `biography` field on `Character` (short "about this ghola" blurb), surfaced
  in the character detail / progress UI.
- Optional **location** and **mood** fields per entry.
- Tag chips with quick-filter UI; entry search.

### Phase 3 — Immersion (optional, defer until Phases 1–2 land)
- Quest Journal **parchment/cursive theme** applied to journal screens (already
  sketched in `NEXT_STEPS.md`: Dancing Script / Caveat, parchment palette).
- Markdown rendering + editor toolbar for entry bodies.
- Link an entry to a tracked quest and/or a screenshot path.

### Explicitly deferred (out of scope for now)
- RPG stat sheets (spice tolerance, combat prowess, etc.) — fun but pure
  cosmetic surface area; revisit only on demand.
- Voice notes, PDF export, community sharing / "story showcase" — these imply
  storage, encoding, or network concerns that conflict with the app's
  local-only posture.

---

## Proposed data model

New table via **migration 013** (next available; current DB version is 12).
Bump `version:` in `AppDatabase` per the migration rules in `CLAUDE.md`.

```dart
// Migration 013: RPG journal entries
//
// journal_entries
//   id            TEXT PRIMARY KEY
//   character_id  TEXT NOT NULL  (FK -> characters.id, ON DELETE CASCADE)
//   title         TEXT NOT NULL
//   body          TEXT NOT NULL DEFAULT ''
//   tags          TEXT NOT NULL DEFAULT ''   // comma-separated for v1
//   entry_date    TEXT NOT NULL              // ISO-8601, player-editable
//   created_at    TEXT NOT NULL
//   updated_at    TEXT NOT NULL
//
// Index: idx_journal_entries_character_id ON journal_entries(character_id)
```

Phase 2 adds, in a later migration:
- `characters.biography TEXT` (nullable).
- `journal_entries.location TEXT`, `journal_entries.mood TEXT` (nullable).

### Model object (`JournalEntry`)
Follow the established model conventions:
- `@JsonSerializable()` with generated `*.g.dart`.
- Thread every field through `copyWith`, `toJson`/`fromJson`, **and**
  repository `toMap`/`fromMap` (Qodo Merge enforces this).

---

## Architecture / placement

New self-contained feature module: `lib/features/journal/`.

```
lib/features/journal/
  models/        journal_entry.dart (+ .g.dart)
  services/      journal_repository.dart    // repository pattern — no raw db.query elsewhere
  providers/     journal_providers.dart     // Riverpod, AsyncValue<List<JournalEntry>>
  screens/       journal_screen.dart        // timeline list
  widgets/       journal_entry_card.dart, journal_entry_editor.dart
```

**UI entry point:** add a **Journal** tab to the existing
`CharacterProgressDialog` (alongside specializations / class quests / skills /
factions / augmentations). This avoids adding a new top-level nav destination
and keeps the journal anchored to a specific character. If usage warrants it,
promote to a top-level nav surface later.

**Adaptive UI:** the journal screen must work in both desktop (side rail) and
mobile (bottom nav) layouts — but since it lives inside the character progress
flow initially, it inherits that placement.

---

## Required patterns checklist (per `best_practices.md` / `.pr_agent.toml`)

- [ ] New model fields threaded through `copyWith`, `toJson/fromJson`, and repo `toMap/fromMap`.
- [ ] All user-facing strings via `AppLocalizations` — add keys to `app_en.arb`
      with `@key` metadata, translate into es/fr/de/uk/it/cy, run `flutter gen-l10n`.
- [ ] No direct DB access outside `JournalRepository`.
- [ ] At least one unit/widget/integration test (model round-trip + repository CRUD + a widget smoke test).
- [ ] Async provider ops use `try/catch` → `AsyncValue.error`.
- [ ] `const` constructors where possible.
- [ ] `JournalEntry` data included in `ExportService` / `ImportService` ZIP payload.
- [ ] `AppDatabase.clearAllData()` clears `journal_entries` (and confirm the
      Settings "clear data" path covers it — there is a known inconsistency between
      `ImportService.clearAllData()` and `AppDatabase.clearAllData()`).

---

## Open questions

1. **Scope per character vs global?** Recommendation: per-character (FK +
   cascade delete), matching the rest of the progression model. A "global
   campaign journal" not tied to a character is possible but adds modeling
   ambiguity; defer.
2. **Tag storage:** comma-separated string (simple, v1) vs a normalized
   `journal_tags` table (queryable). Recommendation: start with the string
   column; normalize only if tag-based features grow.
3. **Markdown now or later?** Recommendation: plain text in Phase 1; markdown is
   Phase 3 to avoid pulling rendering/editor dependencies before the core flow
   is proven.
4. **Screenshots:** link to a file path (like character portraits) rather than
   embedding image bytes, to keep the DB and backups small. Phase 3.

---

## Relationship to other planned work

- **Quest Journal theme** (`NEXT_STEPS.md`): the parchment/cursive theme was
  originally scoped for quest screens. This journal is the natural home for that
  immersive theme — consider sharing one theme implementation across both.
- **Interactive Hagga Basin map** (`docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md`):
  separate effort. A future enhancement could let a journal entry reference a map
  pin, but that is not a dependency.
- **`NEXT_STEPS.md` item #6** is the historical source for this idea; treat *this*
  document as the authoritative design going forward, since the NEXT_STEPS copy
  references an outdated migration number and a pre-Chapter-3 character model.

---

## Feature-rich expansion analysis (research)

This section answers "how feature-rich could the journal become?" It catalogs
candidate features with rough value/effort, the dependencies each implies, and a
recommended sequencing. Nothing here is committed — it is a menu for future
phases. The app's guardrails still apply: **local-first, repository-only DB
access, full localization, adaptive UI, and a test per feature.**

### Rich-text / Markdown body (highest-value next step)

Players want formatted chronicles (headings, bold, lists, links). Two routes:

| Option | What it is | Storage | Fit |
|--------|-----------|---------|-----|
| **`flutter_markdown_plus`** | Maintained drop-in successor to the discontinued `flutter_markdown`; Google-endorsed community handover, ~140k weekly downloads, perfect pub score ([Foresight Mobile](https://foresightmobile.com/blog/flutter-markdown-plus-google-handover), [pub.dev](https://pub.dev/packages/flutter_markdown_plus)) | Plain Markdown text (no schema change) | **Recommended.** Keeps `body` as text, renders Markdown in the card + a preview in the editor; a small toolbar can insert syntax. Low risk, reversible. |
| **`flutter_quill`** | Established WYSIWYG editor, Delta JSON format, ~177k downloads ([Flutter Gems](https://fluttergems.dev/richtext-markdown-editor/), [Walturn](https://www.walturn.com/insights/a-comparison-between-various-rich-text-editors-for-flutter)) | Delta JSON in a new column | Heavier; full WYSIWYG. Consider only if true rich editing (not just Markdown) becomes a core ask. `super_editor`/`appflowy_editor` are the Notion-style alternatives. |

**Recommendation:** ship Markdown rendering with `flutter_markdown_plus` first
(body stays text, fully backward compatible); revisit Quill only if users want a
toolbar-driven WYSIWYG.

### Visual & immersion

| Feature | Value | Effort | Notes / deps |
|---------|-------|--------|--------------|
| Bundle screenshots into ZIP backup | High | S–M | Copy picked images into an app `journal_images/` dir (mirror the portrait flow via `ImageService`) and add them to the export archive. Closes the current "paths only" gap. |
| Multiple images / gallery per entry | Med | M | New `journal_entry_images` table (1‑N); carousel in card. |
| Cursive/parchment polish | Med | S | Add `google_fonts` (Dancing Script/Caveat) **or** bundle a font asset to avoid network fetch; optional aged-paper background texture asset. |
| Distraction-free reading view | Med | S | Full-screen entry route with parchment theme + large type. |

### Structure & organization

| Feature | Value | Effort | Notes / deps |
|---------|-------|--------|--------------|
| Entry templates (session log, lore note, character arc) | High | S | Pre-fill title/body/tags; pure UI, no schema change. |
| Structured mood/weather pickers (icons) | Med | S | Replace free-text mood with a chip/enum; keep free text as fallback. |
| Pinned / favourite entries | Med | S | `is_pinned` column; sort pinned first. |
| Multi-tag filter (AND/OR) + tag autocomplete | Med | M | Builds on existing tag chips; consider normalized `journal_tags` table if tag features grow. |
| Date-range filter | Low–Med | S | Pairs with the existing search. |

### Cross-linking (leverages existing modules)

| Feature | Value | Effort | Notes |
|---------|-------|--------|-------|
| Entry ↔ base link | Med | S | Reuse the quest-link pattern with `BaseRepository`. |
| Entry ↔ blueprint link | Med | S | Same pattern; ties the chronicle to crafting milestones. |
| Entry ↔ map pin | Med | L | Depends on `docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md` shipping first. |
| Quest auto-journaling | Med | M | Offer to create a journal entry when a quest is completed (hook into `QuestEditor`). |

### Insight & engagement

| Feature | Value | Effort | Notes / deps |
|---------|-------|--------|--------------|
| Journal statistics (entries/week, top tags, activity heatmap) | Med | M | `fl_chart` is already a dependency. |
| "Journal reminder" notifications | Med | S–M | Reuse `NotificationCoordinator`/quest-reminder plumbing. |
| Export single entry / whole journal to Markdown or PDF | Med | M | Markdown export is trivial; PDF needs `printing`/`pdf`. |
| RPG character sheet (spice tolerance, etc.) | Low | M | Cosmetic; only if community asks. Lives next to biography. |

### Explicitly out of scope (conflicts with local-first posture)

- Cloud sync, community sharing / "story showcase", and online profiles —
  imply accounts, storage and network surface the app deliberately avoids.
- Voice notes — large dependency/permission surface for niche value.
- End-to-end encryption of entries — revisit only if cloud sync is ever added.

### Suggested sequencing

1. **Phase 4 — Rich text:** `flutter_markdown_plus` rendering + lightweight
   toolbar; bundle screenshots into the ZIP backup; entry templates.
2. **Phase 5 — Organization:** pinned entries, structured mood, multi-tag
   filtering, base/blueprint cross-links.
3. **Phase 6 — Immersion & insight:** reading view, cursive fonts/texture,
   journal stats, optional reminders and Markdown/PDF export.

Each phase is independently shippable and adds at most one new dependency,
keeping review and regression risk low.
