# Security Checklist

Last updated: 2026-02-06

This is an ongoing security checklist for the Dune Awakening Companion App.
Unlike the one-time `SECURITY_AUDIT.md`, this document defines repeatable
checks and a review cadence.

---

## Review Cadence

| Review | Frequency | Owner |
|--------|-----------|-------|
| Dependency audit (`scripts/ci/deps_audit.sh`) | Every PR (automated) | CI |
| SBOM generation (`scripts/ci/sbom.sh`) | Every PR (automated) | CI |
| Manual checklist below | Before each stable release | Developer |
| Full security review | Quarterly or after major changes | Developer |

---

## 1. File Handling (Import/Export)

- [ ] **Path traversal**: ZIP import strips directory components using
      `path.basename()` before writing files. Verify no raw archive paths
      are used as file system destinations.
- [ ] **Oversized files**: Import does not impose a file size limit. For
      future network features, add maximum file size checks. Currently
      acceptable because imports are user-initiated from local storage.
- [ ] **Malformed ZIP**: `ZipDecoder` failures are caught and return an
      `ImportResult` with `success: false`. Verify no unhandled exceptions
      can crash the app.
- [ ] **Malformed JSON**: `json.decode` failures are caught. Verify the
      `_validateImportData` method rejects payloads missing required fields
      (`version`, `characters`, `bases`).
- [ ] **Portrait extraction**: Portraits are written only to the app's
      documents directory under `portraits/`. Verify no symlink following
      or directory escape is possible.

## 2. Database Safety

- [ ] **Parameterized queries**: All repository classes use `whereArgs`
      for query parameters. No raw SQL string concatenation. Spot-check
      any new repositories or raw `db.execute()` calls.
- [ ] **Migration safety**: Migrations use `IF NOT EXISTS` and
      `IF EXISTS` guards. Verify new migrations do not drop data without
      a backup step.
- [ ] **DB corruption recovery**: `AppDatabase.close()` properly closes
      the database handle. Verify no concurrent write paths exist that
      could corrupt the WAL.
- [ ] **Sensitive data**: No passwords, tokens, or API keys are stored
      in the database. The app is local-first with no authentication.

## 3. Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

- [ ] **No INTERNET permission**: The app must NOT request
      `android.permission.INTERNET` unless a network feature is
      explicitly added.
- [ ] **Minimal permissions**: Only `RECEIVE_BOOT_COMPLETED` and
      notification-related permissions should be present.
- [ ] **Target SDK**: Verify `targetSdk` is current (API 35+).

### macOS (`macos/Runner/Release.entitlements`)

- [ ] **App Sandbox enabled**: `com.apple.security.app-sandbox` is `true`.
- [ ] **Minimal entitlements**: Only add `network.client` or
      `files.user-selected.read-write` if features require them.

### Linux / Windows

- [ ] No special permissions required. Verify the app does not attempt
      to access system directories outside its data folder.

## 4. Integrity and Recovery

- [ ] **Backup verification**: Export creates valid ZIP/JSON that can be
      re-imported on a clean install. Test this before each release.
- [ ] **DB migration rollback**: If a migration fails mid-way, the app
      should not leave the database in a corrupt state. SQLite
      transactions protect individual migrations.
- [ ] **Artifact checksums**: Release workflow generates `checksums.txt`
      with SHA-256 hashes for all platform artifacts. Users can verify
      downloads match.

## 5. CI Security Checks

- [ ] **Dependency audit**: `scripts/ci/deps_audit.sh` runs
      `dart pub outdated --json` on every PR. Review the output for
      packages with known vulnerabilities.
- [ ] **SBOM**: `scripts/ci/sbom.sh` generates a dependency tree in
      `build/sbom.json`. Review quarterly for unexpected transitive
      dependencies.
- [ ] **Static analysis**: `flutter analyze` runs on every PR with
      strict lint rules. No warnings allowed in CI.
- [ ] **No secrets in repo**: Verify `.gitignore` excludes `.env`,
      `key.properties`, keystores, `.p12`, `.pfx` files. Audit with
      `git log --all --diff-filter=A -- '*.env' '*.jks' '*.p12'`.

## 6. Supply Chain

- [ ] **Pinned Flutter version**: CI uses a specific Flutter version
      (`3.38.5`), not `stable` channel latest.
- [ ] **Lock file committed**: `pubspec.lock` is committed to version
      control for reproducible builds.
- [ ] **No pre/post install scripts**: Dart packages do not support
      arbitrary install scripts, but verify `build_runner` generators
      only produce expected `.g.dart` output.

---

## Incident Response

If a vulnerability is discovered:

1. **Assess severity**: Does it affect local data only, or could it be
   exploited remotely? (Currently the app has no network surface.)
2. **Fix and release**: Patch the vulnerability, bump the version, and
   release immediately.
3. **Disclose**: If the vulnerability could affect users who downloaded
   previous versions, add a note to the GitHub release and README.
4. **Update this checklist**: Add the vulnerability class to the
   appropriate section above to prevent recurrence.
