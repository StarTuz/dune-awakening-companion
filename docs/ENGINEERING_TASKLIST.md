# Engineering Task List

Last updated: 2026-02-06

This is a concrete task list derived from the housekeeping assessment.
Status: **100% Complete**

## CI/CD and Local Automation
- [x] Add PR workflow: analyze + test + build.
- [x] Add local CI script matching PR workflow.
- [x] Add dependency caching and pinned Flutter version.
- [x] Add artifact checksums on release.

## Testing Strategy
- [x] Create `test/unit`, `test/widget`, `test/integration`.
- [x] Add unit tests for models, utilities, and services (9 unit test files).
- [x] Add widget tests for Dashboard, Characters, Alerts, Settings screens (6 widget test files).
- [x] Add integration tests for character/base flow and import/export (3 integration test files).
- [x] Define smoke tests for release gating.
- [x] Add coverage reporting and thresholds (15% gate, currently 18.93%).
- **Total: 72 tests passing across 19 test files.**

## Security and Pen-Test Readiness
- [x] Add dependency audit step (`scripts/ci/deps_audit.sh`).
- [x] Add SBOM generation (`scripts/ci/sbom.sh`).
- [x] Add static analysis security checks (flutter analyze in CI).
- [x] Document a pen-test/security checklist and cadence (`docs/SECURITY_CHECKLIST.md`).

## Code Quality Gates
- [x] Expand `analysis_options.yaml` rules.
- [x] Add formatter in CI (`dart format --set-exit-if-changed`).
- [x] Fail CI on analyzer warnings.
- [x] Add code metrics tooling (`scripts/ci/metrics.sh` — lightweight, zero-dependency).

## Release Management
- [x] Document a release preflight checklist (`docs/RELEASE_CHECKLIST.md`).
- [x] Add signing guidance for all platforms (`docs/SIGNING_GUIDE.md`).
- [x] Standardize release notes template (`docs/RELEASE_NOTES_TEMPLATE.md`).
- [x] Add performance regression baseline (`scripts/ci/perf_baseline.sh`).

## Summary of Deliverables

| Category | Files |
|----------|-------|
| CI workflows | `.github/workflows/ci.yml`, `.github/workflows/build-release.yml` |
| Local CI | `scripts/ci/local.sh` |
| Coverage | `scripts/ci/check_coverage.sh`, `scripts/ci/coverage_summary.sh` |
| Security | `scripts/ci/deps_audit.sh`, `scripts/ci/sbom.sh`, `docs/SECURITY_CHECKLIST.md` |
| Metrics | `scripts/ci/metrics.sh` |
| Performance | `scripts/ci/perf_baseline.sh` |
| Release docs | `docs/RELEASE_CHECKLIST.md`, `docs/SIGNING_GUIDE.md`, `docs/RELEASE_NOTES_TEMPLATE.md` |
| Tests (unit) | `test/unit/` — 9 files |
| Tests (widget) | `test/widget/` — 6 files |
| Tests (integration) | `test/integration/` — 3 files |
