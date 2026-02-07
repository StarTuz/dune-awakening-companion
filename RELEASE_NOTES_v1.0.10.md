# Release Notes v1.0.10

**Date:** 2026-02-07
**Status:** Stable Release

> AppImage packaging, Qodo Merge integration, and code quality hardening.

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- **Linux AppImage** — self-contained one-file executable, auto-built on every release
- **Qodo Merge (AI code review)** — every PR is automatically reviewed for quality, security, and best practices
- **Pre-commit formatting hook** — eliminates formatting drift before it reaches CI

## New Features

- **AppImage packaging:** Linux users can now download a single `.AppImage` file — `chmod +x` and run, no extraction needed. FUSE guidance included in README.
- **CONTRIBUTING.md:** Dedicated contributor guide covering setup, workflow, Qodo review process, and code standards.
- **PR template:** Structured checklist enforcing Qodo review, localization, and test requirements on every pull request.
- **Git pre-commit hook:** Auto-formats staged Dart files on commit. Install with `bash scripts/git/install-hooks.sh`.

## Improvements

- **Async safety:** Added `context.mounted` guards before all `BuildContext` usage after `await` (Navigator.pop, AppLocalizations.of).
- **Const cleanup:** Removed redundant nested `const` keywords inside already-const constructors across all theme definitions.
- **Missing import fix:** Resolved `ImportMode` undefined error in settings screen.
- **CI robustness:** Hardened CI helper scripts, improved AppImage file discovery with proper error handling.
- **Documentation:** Updated README with AppImage download instructions and FUSE requirements. Updated HANDOFF.md with Qodo review workflow.

## Breaking Changes

- None.

---

## Technical Changes

### Key Files Changed
- `.github/workflows/build-release.yml` — AppImage build with appimagetool
- `.github/PULL_REQUEST_TEMPLATE.md` — new PR template with Qodo checklist
- `CONTRIBUTING.md` — new contributor guide
- `scripts/git/pre-commit` — formatting hook
- `scripts/git/install-hooks.sh` — hook installer (worktree-aware)
- `lib/main.dart` — async context guard, localized tray notifications
- `lib/features/characters/screens/character_management_screen.dart` — async context guards, localization
- `lib/shared/theme/app_theme.dart` — unnecessary const cleanup

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.0.10-linux-x64.tar.gz` |
| Linux x64 (AppImage) | `dune-awakening-companion-v1.0.10-linux-x64.AppImage` |
| Windows x64 | `dune-awakening-companion-v1.0.10-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.0.10-macos.zip` |
| Android | `dune-awakening-companion-v1.0.10-android.apk` |

### Verify Downloads

Compare SHA-256 checksums against `checksums.txt` attached to the release:

```bash
sha256sum -c checksums.txt
```

---

## Upgrade Instructions

1. Download the new version for your platform.
2. Replace the existing installation (or simply run the new AppImage on Linux).
3. Launch the app — database migrations run automatically.

---

**Built for the Dune Awakening community**
