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
team discontinued `flutter_markdown` in 2025, so this is intentionally left
out until a maintained renderer (e.g. `markdown_widget`) is chosen. Cursive
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
