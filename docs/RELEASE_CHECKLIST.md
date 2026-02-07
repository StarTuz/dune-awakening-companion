# Release Checklist

Last updated: 2026-02-06

Use this checklist before tagging a release.

## Preflight

- [ ] Run local CI: `bash scripts/ci/local.sh`
- [ ] Confirm coverage meets threshold (currently 15%).
- [ ] Run performance check: `bash scripts/ci/perf_baseline.sh`
- [ ] Generate SBOM: `bash scripts/ci/sbom.sh`
- [ ] Generate dependency report: `bash scripts/ci/deps_audit.sh`

## Versioning

- [ ] Bump `pubspec.yaml` version.
- [ ] Update any in-app version display if applicable.
- [ ] Create `RELEASE_NOTES_vX.X.X.md`.

## Build and Sign

### Android
- [ ] Configure release keystore (see `docs/SIGNING_GUIDE.md`).
- [ ] Verify `minSdk`/`targetSdk` alignment.
- [ ] Test APK install on a real device.

### macOS
- [ ] Sign and notarize app (see `docs/SIGNING_GUIDE.md`).
- [ ] Verify with `codesign --verify --deep --strict`.
- [ ] Test Gatekeeper: `spctl --assess --verbose`.

### Windows
- [ ] Code-sign `.exe` if distributing to end users (see `docs/SIGNING_GUIDE.md`).
- [ ] Test on a clean Windows install (VM recommended).

### Linux
- [ ] Test `.tar.gz` extraction and launch.
- [ ] Verify system tray works with `libayatana-appindicator`.

## Tag and Release

- [ ] `git tag vX.X.X`
- [ ] `git push origin main --tags`
- [ ] Confirm GitHub Actions release succeeds.
- [ ] Verify all 4 platform artifacts are attached.
- [ ] Smoke-test at least one downloaded artifact.
