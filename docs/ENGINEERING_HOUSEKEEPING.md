# Engineering Housekeeping Assessment

Last updated: 2026-02-06

This document assesses the current engineering posture for the Dune Awakening
Companion App and recommends upgrades to reach top-tier software standards.

## Scope
- CI/CD and local automation
- Testing strategy and regression coverage
- Security posture and pen-test readiness
- Code quality gates and static analysis
- Release management and supply-chain controls

## Current State (Evidence)
CI/CD:
- Release-only GitHub Actions workflow triggered by tags in
  `.github/workflows/build-release.yml`.
- Builds Linux/Windows/macOS/Android and publishes GitHub releases.
- No PR checks, no test steps, no security scanning.

Testing:
- No `test/` directory or tests in repo.
- `flutter_test` is present in `pubspec.yaml` but unused.
- Placeholder macOS test file exists but does not assert anything.

Security:
- Local-first app, no network permission in Android manifest.
- Prior security audit passed (`SECURITY_AUDIT.md`, 2024-12-23).
- No automated dependency or code security scanning.

Quality:
- Linting uses `flutter_lints` with a small rule set
  (`analysis_options.yaml`).
- No CI gating on analyzer warnings or formatting.

Release:
- Manual release checklist in `HANDOFF.md`.
- Release notes required by workflow (`RELEASE_NOTES_vX.X.X.md`).
- No signing/notarization guidance or automated checks.

## Gaps and Risks
CI/CD:
- No fast feedback loop for PRs.
- No local CI scripts to ensure parity with CI.
- No reproducibility controls (cache, deterministic builds).

Testing:
- No regression suite; high risk of unintentional breakage.
- No coverage tracking or test gating.
- No integration tests for critical user flows.

Security:
- Security posture depends on manual audits.
- No vulnerability scanning for dependencies.
- No SBOM or artifact integrity verification.

Quality:
- Lint rules not comprehensive.
- Analyzer not configured to fail builds on warnings.
- No metrics (complexity, unused code, dead code).

Release:
- No automated pre-release checks.
- No platform signing or notarization guidance.
- No reproducible build verification.

## Recommendations (Prioritized)
### 1) CI/CD and Local Automation
Goals:
- Establish PR gating and local CI parity.

Recommendations:
- Add a PR workflow that runs `flutter analyze`, `dart test`,
  and a platform-neutral build (Linux or Android).
- Add a local CI entrypoint script that mirrors CI steps, e.g.
  `./scripts/ci/local.sh`.
- Introduce dependency caching and explicit tool versions.
- Add build artifact checksums for releases.

### 2) Testing Strategy and Regression Coverage
Goals:
- Build a layered test suite with minimal but meaningful coverage.

Recommendations:
- Create `test/unit/`, `test/widget/`, `test/integration/` directories.
- Start with unit tests for repositories and services.
- Add widget tests for critical screens:
  Characters, Bases, Alerts, Settings.
- Define a minimal regression flow (smoke tests):
  add character, add base, edit base, export/import, alert evaluation.
- Add coverage reporting and set initial thresholds (e.g. 30% to start).

### 3) Security Posture and Pen-Test Readiness
Goals:
- Move from manual audit to continuous assurance.

Recommendations:
- Add dependency auditing (e.g. `dart pub audit` and OSV scanning).
- Add static security checks (Dart analyzer + dart_code_metrics).
- Generate a Software Bill of Materials (SBOM).
- Create a pen-test checklist focused on:
  import/export handling, path traversal, oversized files, DB corruption,
  and permission misuse.

### 4) Code Quality Gates
Goals:
- Enforce consistent style and avoid common regressions.

Recommendations:
- Expand `analysis_options.yaml` with stricter rules.
- Add formatting step (`dart format`) in CI.
- Configure analyzer to treat warnings as errors in CI.
- Add optional static metrics (complexity, unused code).

### 5) Release Management
Goals:
- Make releases reliable and verifiable.

Recommendations:
- Add a release preflight checklist (tests, analyze, build).
- Add signing guidance:
  - Android: release keystore and signing config.
  - Windows: code-signing (optional).
  - macOS: notarization and signing (optional).
- Add checksum files for artifacts.
- Standardize release notes format and versioning rules.

## Proposed Deliverables (Next Steps)
- PR CI workflow and local CI script (documented).
- Initial test scaffolding and smoke tests.
- Security scan baseline (dependency audit + SBOM).
- Updated lint rules and analyzer gating.
- Release preflight checklist and signing guidance.

## Related Documents
- `.github/workflows/build-release.yml`
- `analysis_options.yaml`
- `SECURITY_AUDIT.md`
- `HANDOFF.md`

