# Engineering + Product Roadmap (2026)

Last updated: 2026-02-07

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
- Returning player flow (return packages, re-onboarding).
- Advanced analytics dashboard (local-only summaries).

## Risks and Dependencies
- CI changes should land before expanding tests to avoid slow feedback.
- New features should not ship without baseline regression coverage.
- Release signing requires credentials and platform-specific setup.

