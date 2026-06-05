# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Cross-platform Flutter companion app for *Dune Awakening* (Linux/Windows/macOS/Android/iOS). Tracks characters, bases, power-decay countdowns, quests, blueprints, and Chapter 3 progression (specializations, factions, augmentations, class quests, skills).

- Flutter 3.38+, Dart 3.8+, SDK constraint `>=3.0.0 <4.0.0`.
- Current version: see `pubspec.yaml` (`1.3.0-beta+26` as of last edit).
- **Working directory note:** The repo path ends with a literal period: `/home/startux/Code/Dune Awakening Companion App.`. Quote it.

## Commands

```bash
# Full local CI (mirrors remote pipeline — run before pushing)
bash scripts/ci/local.sh

# Deps + codegen (run after editing any model with json_serializable / riverpod_generator)
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Lint + format (CI enforces both)
dart format --set-exit-if-changed .
flutter analyze

# Tests
flutter test                                    # all
flutter test --coverage                         # with coverage (15% threshold enforced by scripts/ci/check_coverage.sh)
flutter test test/unit/class_quest_catalog_test.dart   # single file
flutter test --plain-name "substring of test name"     # filter

# Localization regen (after editing lib/l10n/*.arb)
flutter gen-l10n

# Run
flutter run -d linux        # or windows/macos/android device id

# Install pre-commit hook (auto-formats staged Dart files)
bash scripts/git/install-hooks.sh
```

## Architecture

Feature-based modular layout under `lib/`:

- `lib/core/` — cross-cutting: `database/` (sqflite + numbered migrations), `repositories/`, `services/` (notifications, alert checker, system tray), `providers/` (Riverpod), `models/`, `utils/`.
- `lib/features/<feature>/` — self-contained module, typically with `models/`, `services/` (repositories), `providers/`, `screens/`, `widgets/`. Current features: `alerts`, `augmentations`, `base_calculator`, `bases`, `blueprints`, `characters`, `class_quests`, `dashboard`, `factions`, `journal`, `quest_journal`, `servers`, `settings`, `skills`, `specializations`.
- `lib/shared/` — `navigation/` (adaptive side-rail on desktop, bottom nav on mobile), `theme/`, `widgets/`.
- `lib/platform/system_tray/` — desktop-only tray integration.
- `lib/l10n/` — ARB files for 7 locales (en, es, fr, de, uk, it, cy). `l10n.yaml` configures gen.

**State management:** Riverpod (`flutter_riverpod` + `riverpod_annotation`). No raw singletons in UI.

**Persistence:** SQLite via `sqflite` (mobile) / `sqflite_common_ffi` (desktop, auto-initialized in `AppDatabase._initDatabase`). Schema evolves through `migration_NNN_*.dart` files in `lib/core/database/migrations/` — each is imported and registered in `lib/core/database/app_database.dart`. **Bump the `version:` in `openDatabase` whenever you add a migration.** Current version: 16.

**Repository pattern is mandatory.** All DB access goes through repository classes (e.g. `BaseRepository`, `CharacterRepository`, `QuestRepository`). Providers/screens/services must never call `db.query` directly — Qodo Merge flags this in PR review.

**Background work / notifications:** `NotificationCoordinator` + `AlertCheckerService` + `NotificationManager` wired in `main.dart`. Mobile uses `workmanager`; desktop uses `system_tray` + `tray_manager` + `window_manager` (window close minimizes to tray, doesn't quit). Quest reminders bootstrap via `QuestReminderService.resyncAllScheduled` on startup.

**Adaptive UI:** Any new screen must work in both desktop (side rail) and mobile (bottom nav) layouts via `lib/shared/navigation/main_navigation.dart`.

## Required patterns (enforced by Qodo Merge — see `best_practices.md` and `.pr_agent.toml`)

1. New model fields must be threaded through `copyWith`, `toJson/fromJson`, **and** repository `toMap/fromMap`.
2. All user-facing strings via `AppLocalizations.of(context)!.<key>` — never hardcode English. Add the key to `lib/l10n/app_en.arb` with `@key` metadata, then translate in all 6 other ARB files, then run `flutter gen-l10n`.
3. No direct DB access outside repository classes.
4. New features need at least one unit/widget/integration test.
5. Async ops in providers/services use `try/catch` with `AsyncValue.error` for state.
6. Prefer `const` constructors.

## PR workflow

- Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `style:`).
- Branch from `main`, rebase before PR, squash-merge.
- PRs are auto-reviewed by Qodo Merge (`/describe`, `/review`, `/improve`) using rules in `.pr_agent.toml`. Address Medium+ suggestions or document why deferred.
- Release notes live in `RELEASE_NOTES_v*.md` at repo root.

## Useful docs in-repo

- `CONTRIBUTING.md` — full workflow, Qodo review process.
- `EXTENSIBILITY_GUIDE.md` — step-by-step for adding a new feature module.
- `best_practices.md` — the six patterns above with before/after examples.
- `HANDOFF.md`, `NEXT_STEPS.md`, `docs/` — architecture context and roadmap.
- `COLOR_SCHEME.md` — Dune-inspired palette used by `lib/shared/theme/`.
