# Contributing to Dune Awakening Companion

Thank you for your interest in contributing! This document explains the
workflow, standards, and tools we use to keep the project at a high quality bar.

---

## Getting Started

1. Fork the repository and clone your fork.
2. Install Flutter 3.38+ and Dart 3.8+.
3. Run `flutter pub get` and `dart run build_runner build --delete-conflicting-outputs`.
4. Run `bash scripts/ci/local.sh` to confirm your environment passes all checks.

---

## Branch Workflow

- Create a feature branch from `main` (`git checkout -b feature/my-feature`).
- Keep commits atomic and use [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `chore:`, `style:`, `docs:`, `test:`, `refactor:`).
- Rebase on `main` before opening a PR to avoid merge conflicts.

---

## Before Opening a PR

Run the full local CI suite:

```bash
bash scripts/ci/local.sh
```

This mirrors the remote CI pipeline and checks:

- GitHub Actions workflow validation (if `actionlint` is installed)
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test --coverage` with coverage threshold enforcement
- `flutter build linux --debug`

Fix any failures before pushing.

---

## Pull Request Process

### 1. Open the PR

Use the PR template (`.github/PULL_REQUEST_TEMPLATE.md`). Fill in the
summary, testing steps, and checklist.

### 2. Qodo Merge (AI Code Review) — Required

Every PR is automatically reviewed by [Qodo Merge](https://www.qodo.ai/)
when opened. It runs three commands configured in `.pr_agent.toml`:

| Command | What it does |
|---------|-------------|
| `/describe` | Auto-generates a structured PR description and labels |
| `/review` | Scores the PR (1-10), flags security/test gaps, estimates review effort |
| `/improve` | Suggests concrete code improvements with diffs |

**Your responsibilities:**

- **Read** the Qodo review and suggestion comments.
- **Apply** valid suggestions (especially Medium+ importance).
- **Document** any suggestions you intentionally defer with a brief rationale
  in the PR conversation (e.g., "Deferred: out of scope for this PR, tracked
  in issue #N").
- **Link** the Qodo review output in the PR checklist.

> Qodo is configured to focus on real problems (not style nits) and to
> check Flutter/Dart-specific patterns like Riverpod usage, localization
> completeness, repository boundaries, and error handling.

### 3. Human Review

After Qodo feedback is addressed, request a human review. The reviewer will
check the Qodo output alongside the code.

### 4. Merge

Squash-merge into `main` once CI is green and reviews are approved.

---

## Code Standards

### Architecture

- **Riverpod** for state management — no raw singletons in UI code.
- **Repository pattern** — all database access goes through repository classes.
- **Feature modules** under `lib/features/` with models, providers, screens, services, widgets.

### Localization

- All user-facing strings must use `AppLocalizations` (never hardcoded English).
- Add new keys to `lib/l10n/app_en.arb` with `@key` metadata.
- Add translations to all 6 other ARB files (ES, FR, DE, UK, IT, CY).
- Run `flutter gen-l10n` after editing ARB files.

### Error Handling

- Async operations must use `try/catch` with user-visible feedback (SnackBar).
- Background services must catch and log errors to avoid silent failures.

### Formatting

- `dart format` is enforced by CI. Run it before committing or enable
  format-on-save in your editor.
- Line length: 80 characters (Dart default).

### Testing

- New features should include tests (unit, widget, or integration as appropriate).
- Coverage threshold is enforced at 15% and expected to increase over time.
- Run tests with `flutter test --coverage`.

### Const Constructors

- Use `const` constructors wherever possible in Flutter widgets and theme data.

---

## Project-Specific Review Guidance

These are the same rules Qodo uses (from `.pr_agent.toml`):

- New model fields must be handled in `copyWith`, `toJson/fromJson`, and
  repository `toMap/fromMap`.
- No direct database access outside repository classes.
- New UI must support both desktop (side rail) and mobile (bottom nav) layouts.
- New features need corresponding test coverage.

---

## Useful Commands

```bash
# Full local CI (mirrors remote pipeline)
bash scripts/ci/local.sh

# Generate code (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Generate localization (after ARB changes)
flutter gen-l10n

# Performance baseline
bash scripts/ci/perf_baseline.sh --save   # save baseline
bash scripts/ci/perf_baseline.sh          # compare against baseline
```

---

## Questions?

- Check [HANDOFF.md](./HANDOFF.md) for full architecture docs.
- Check [QUICK_START.md](./QUICK_START.md) for developer setup.
- Open an [issue](https://github.com/StarTuz/dune-awakening-companion/issues)
  for anything unclear.
