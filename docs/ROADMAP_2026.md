# Engineering + Product Roadmap (2026)

Last updated: 2026-06-05

This roadmap aligns engineering maturity with product goals, with
priority sequencing: CI/CD, testing, security, quality, release
management, then product expansion.

## Quick Wins (1-2 weeks) — COMPLETE
Engineering:
- ~~Add PR CI workflow with analyze + test + build.~~ Done.
- ~~Add local CI script to mirror PR checks.~~ Done.
- ~~Add dependency auditing baseline.~~ Done.
- ~~Expand lint rules and analyzer gating.~~ Done.

Product:
- ~~Update tax-related copy to reflect tax removal in Chapter 3.~~ Done — tax system fully removed from code, UI, localization, and docs.
- ~~Add Chapter 3 research link in docs for team alignment.~~ Done (`docs/CHAPTER3_RESEARCH.md`).

## Mid-Term (1-3 months) — MOSTLY COMPLETE
Engineering:
- ~~Implement unit tests for repositories/services/providers.~~ Done (~296 tests).
- ~~Add widget tests for core screens.~~ Done.
- ~~Add coverage reporting and initial thresholds.~~ Done (15% gate).
- ~~Add SBOM generation and artifact checksums.~~ Done.
- ~~Add a basic pen-test checklist and schedule periodic reviews.~~ Done (`docs/SECURITY_CHECKLIST.md`).

Product:
- ~~Specialization tracking (5 tracks).~~ Done.
- ~~Quest journal and class quest / skill planning.~~ Done.
- ~~Augmentation tracker.~~ Done.
- ~~Character Chronicle (RPG journal).~~ Done — see `docs/RESEARCH_RPG_JOURNAL_NOTES.md`.
- ~~Base Calculator (Phases 1–5).~~ Done — see `docs/RESEARCH_BASE_CALCULATOR.md`.

## Long-Term (3-6 months)
Engineering:
- ~~Integration tests for critical flows (export/import, alerts, bases).~~ Done.
- ~~Add advanced static analysis (metrics, dead code).~~ Done (informational metrics script).
- Release signing/notarization for platforms (guidance done; credentials per maintainer).
- ~~Establish performance regression checks for key screens.~~ Done (`scripts/ci/perf_baseline.sh`).

Product:
- Overland map updates with new locations/testing stations.
- **New-player / Hagga Basin research:** interactive regional map — see `docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md` (assessment phase).
- Returning player flow (return packages, re-onboarding).
- Advanced analytics dashboard (local-only summaries).
- **Base Calculator maintenance:** in-game catalog validation; spice/wind running-cost rates when audited.
- Blueprint ↔ quest ↔ map-pin linking UI (placeholder fields exist today).

## Risks and Dependencies
- Guide-sourced calculator and blueprint data should be spot-checked each patch cycle.
- New features should not ship without baseline regression coverage.
- Release signing requires credentials and platform-specific setup.
