# Release Notes v1.0.9

**Date:** 2026-02-07
**Status:** Stable Release

> This is an unofficial, fan-made companion app. NOT affiliated with,
> endorsed by, or supported by Funcom.

---

## Highlights

- Tax system fully removed to match Dune Awakening Chapter 3 (Funcom eliminated in-game taxes)
- Complete CI/CD pipeline with automated testing, coverage gates, and security tooling
- AI-powered code review via Qodo Merge integrated into PR workflow

## Improvements

- **CI/CD Pipeline:** GitHub Actions workflow for PRs with static analysis, formatting checks, test coverage enforcement (15% gate), dependency auditing, and SBOM generation.
- **Test Suite:** 71 tests across 19 files (unit, widget, integration) with 19.83% coverage.
- **Release Tooling:** Automated multi-platform builds with SHA-256 checksums, release checklist, signing guide, and release notes template.
- **Security:** Dependency audit script, SBOM generation, security checklist with review cadence.
- **Code Quality:** Expanded lint rules, format-on-save in editor settings, code metrics script, Qodo Merge AI review with project-specific best practices.
- **Documentation:** Engineering tasklist, 2026 roadmap, Chapter 3 research notes, signing guide, security checklist.

## Breaking Changes

- **Tax tracking removed:** All tax-related features (Advanced Fief checkbox, tax calculator, tax per cycle, owed amounts, tax alerts, tax notifications) have been removed. This reflects Funcom's removal of base taxes in the Chapter 3 update. Database migration 003 columns are retained but ignored -- existing data is harmless and old exports still import cleanly.

## Known Issues

- Linux: System tray tooltip not supported on some desktop environments (gracefully handled).

---

## Technical Changes

### Tax Removal (35 files, -1,120 net lines)
- `lib/features/bases/models/base.dart` -- Removed TaxStatus enum, 6 tax fields, 11 computed getters, constants
- `lib/features/bases/services/base_repository.dart` -- Stopped reading/writing tax columns
- `lib/features/bases/providers/base_provider.dart` -- Simplified createBase() signature
- `lib/core/services/alert_checker_service.dart` -- Removed AlertType.tax and tax alert logic
- `lib/core/services/notification_coordinator.dart` -- Removed tax notification branch
- `lib/core/services/notification_service.dart` -- Removed showTaxAlert method
- `lib/features/characters/screens/character_management_screen.dart` -- Removed ~600 lines of tax UI
- `lib/features/alerts/screens/alerts_screen.dart` -- Removed tax countdown section
- `lib/features/dashboard/screens/dashboard_screen.dart` -- Simplified to power-only stats
- All 7 ARB localization files -- Removed ~10 tax keys each
- Tests and documentation updated throughout

### Engineering Infrastructure (new)
- `.github/workflows/ci.yml` -- PR verification pipeline
- `scripts/ci/` -- 8 CI scripts (local, coverage, deps, sbom, metrics, perf baseline)
- `test/` -- 19 test files (9 unit, 6 widget, 3 integration, 1 smoke)
- `docs/` -- 7 new engineering docs
- `.pr_agent.toml` + `best_practices.md` -- Qodo Merge AI review config

---

## Downloads

Scroll down to **Assets** to download.

| Platform | File |
|----------|------|
| Linux x64 | `dune-awakening-companion-v1.0.9-linux-x64.tar.gz` |
| Windows x64 | `dune-awakening-companion-v1.0.9-windows-x64.zip` |
| macOS | `dune-awakening-companion-v1.0.9-macos.zip` |
| Android | `dune-awakening-companion-v1.0.9-android.apk` |

### Verify Downloads

Compare SHA-256 checksums against `checksums.txt` attached to the release:

```bash
sha256sum -c checksums.txt
```

---

## Upgrade Instructions

1. Download the new version for your platform.
2. Replace the existing installation.
3. Launch the app -- database migrations run automatically.
4. Tax data from previous versions is harmless and will be ignored.

---

**Built for the Dune Awakening community**
