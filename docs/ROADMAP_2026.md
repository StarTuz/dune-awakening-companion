# Engineering + Product Roadmap (2026)

Last updated: 2026-03-19

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

## Mid-Term (1-3 months)
Engineering:
- Implement unit tests for repositories/services/providers.
- Add widget tests for core screens.
- Add coverage reporting and initial thresholds.
- Add SBOM generation and artifact checksums.
- Add a basic pen-test checklist and schedule periodic reviews.

Product:
- Specialization tracking (5 tracks, XP, traits).
- Landsraad mission tracker (missions, house progress, rewards).
- Augmentation planner (augments, durability tradeoffs).

## Long-Term (3-6 months)
Engineering:
- Integration tests for critical flows (export/import, alerts, bases).
- Add advanced static analysis (metrics, dead code).
- Add release signing/notarization for platforms.
- Establish performance regression checks for key screens.

Product:
- Overland map updates with new locations/testing stations.
- **New-player / Hagga Basin research:** interactive regional map, POI toggles, sub-area IA — see `docs/RESEARCH_HAGGA_BASIN_NEW_PLAYER_MAP.md` (assessment phase; not yet scoped for implementation).
- Returning player flow (return packages, re-onboarding).
- Advanced analytics dashboard (local-only summaries).
- **Player RPG journal and notes:** per-character chronicle/journal with biography, tags, search, location/mood, quest links and screenshots — see `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phases 1–3 implemented; markdown rendering deferred).

## Risks and Dependencies
- CI changes should land before expanding tests to avoid slow feedback.
- New features should not ship without baseline regression coverage.
- Release signing requires credentials and platform-specific setup.

