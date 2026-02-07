# Release Signing Guide

Last updated: 2026-02-06

Complete guide for code-signing Dune Awakening Companion builds on every
supported platform.

---

## Android

### 1. Generate a Keystore (once)

```bash
keytool -genkey -v \
  -keystore ~/keys/dune-companion-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias dune-companion
```

Store the keystore **outside** the repo. Never commit it.

### 2. Create `android/key.properties`

```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=dune-companion
storeFile=/absolute/path/to/dune-companion-release.jks
```

Add `android/key.properties` to `.gitignore` (already present in this repo).

### 3. Reference in `android/app/build.gradle.kts`

Add before the `android {}` block:

```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

Inside `android {}`:

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### 4. CI Signing (GitHub Actions)

Store secrets in GitHub:

| Secret | Value |
|--------|-------|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 dune-companion-release.jks` |
| `ANDROID_KEY_ALIAS` | `dune-companion` |
| `ANDROID_KEY_PASSWORD` | keystore password |
| `ANDROID_STORE_PASSWORD` | store password |

Add these steps **before** the build step in `build-release.yml`:

```yaml
- name: Decode Android keystore
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 -d > android/app/dune-companion-release.jks

- name: Create key.properties
  run: |
    cat > android/key.properties <<EOF
    storePassword=${{ secrets.ANDROID_STORE_PASSWORD }}
    keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}
    keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}
    storeFile=dune-companion-release.jks
    EOF
```

### 5. Google Play (optional)

If publishing to Google Play, use an **upload key** and let Google re-sign
with App Signing. See
[Play App Signing](https://developer.android.com/studio/publish/app-signing#app-signing-google-play).

---

## macOS

### 1. Prerequisites

- Apple Developer account (Individual or Organization)
- Xcode with signing certificates installed
- `notarytool` (ships with Xcode 13+)

### 2. Configure Xcode Signing

In `macos/Runner.xcodeproj`:

1. Open in Xcode
2. Select **Runner** target → **Signing & Capabilities**
3. Set **Team** to your Apple Developer team
4. Set **Bundle Identifier** to `com.startuz.duneawakeningcompanion`
5. Enable **Hardened Runtime** (required for notarization)

### 3. Update Entitlements

Edit `macos/Runner/Release.entitlements` to include the minimum sandbox
entitlements your app needs:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.security.app-sandbox</key>
  <true/>
  <key>com.apple.security.network.client</key>
  <true/>
  <key>com.apple.security.files.user-selected.read-write</key>
  <true/>
</dict>
</plist>
```

### 4. Build, Sign, and Notarize

```bash
# Build
flutter build macos --release

# Create a signed DMG / ZIP
cd build/macos/Build/Products/Release

# Sign
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: YOUR NAME (TEAM_ID)" \
  --options runtime \
  "dune_awakening_companion.app"

# Zip for notarization
ditto -c -k --keepParent "dune_awakening_companion.app" dune-companion.zip

# Notarize
xcrun notarytool submit dune-companion.zip \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait

# Staple the notarization ticket
xcrun stapler staple "dune_awakening_companion.app"
```

### 5. CI Signing (GitHub Actions)

Store the following secrets:

| Secret | Value |
|--------|-------|
| `MACOS_CERTIFICATE_BASE64` | Base64-encoded `.p12` certificate |
| `MACOS_CERTIFICATE_PASSWORD` | `.p12` import password |
| `MACOS_KEYCHAIN_PASSWORD` | Temporary CI keychain password |
| `APPLE_ID` | Apple ID email |
| `APPLE_TEAM_ID` | Team ID |
| `APPLE_APP_PASSWORD` | App-specific password |

Add these steps to `build-release.yml` under the `build-macos` job:

```yaml
- name: Import macOS signing certificate
  env:
    CERTIFICATE_BASE64: ${{ secrets.MACOS_CERTIFICATE_BASE64 }}
    CERTIFICATE_PASSWORD: ${{ secrets.MACOS_CERTIFICATE_PASSWORD }}
    KEYCHAIN_PASSWORD: ${{ secrets.MACOS_KEYCHAIN_PASSWORD }}
  run: |
    CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
    KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db

    echo -n "$CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
    security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security import $CERTIFICATE_PATH -P "$CERTIFICATE_PASSWORD" \
      -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
    security list-keychain -d user -s $KEYCHAIN_PATH

- name: Sign and notarize macOS build
  env:
    APPLE_ID: ${{ secrets.APPLE_ID }}
    APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
    APPLE_APP_PASSWORD: ${{ secrets.APPLE_APP_PASSWORD }}
  run: |
    cd build/macos/Build/Products/Release
    codesign --deep --force --verify --verbose \
      --sign "Developer ID Application: YOUR NAME ($APPLE_TEAM_ID)" \
      --options runtime \
      "dune_awakening_companion.app"

    ditto -c -k --keepParent "dune_awakening_companion.app" dune-companion.zip
    xcrun notarytool submit dune-companion.zip \
      --apple-id "$APPLE_ID" \
      --team-id "$APPLE_TEAM_ID" \
      --password "$APPLE_APP_PASSWORD" \
      --wait
    xcrun stapler staple "dune_awakening_companion.app"
```

---

## Windows

### 1. Options

| Method | Cost | Complexity |
|--------|------|------------|
| **Self-signed** (dev/testing) | Free | Low |
| **EV Code Signing Certificate** | ~$300–$500/yr | Medium |
| **Azure Trusted Signing** | ~$10/mo | Medium |

For open-source / GitHub-only distribution, self-signed is acceptable.
For wide distribution, an EV certificate is recommended.

### 2. Self-Signed Certificate (Development)

```powershell
# Create self-signed certificate
$cert = New-SelfSignedCertificate `
  -Subject "CN=Dune Companion Dev" `
  -Type CodeSigningCert `
  -CertStoreLocation "Cert:\CurrentUser\My"

# Sign the executable
Set-AuthenticodeSignature `
  -FilePath "build\windows\x64\runner\Release\dune_awakening_companion.exe" `
  -Certificate $cert
```

### 3. EV Code Signing Certificate (Production)

1. Purchase from a CA (DigiCert, Sectigo, GlobalSign, etc.)
2. The certificate is typically delivered on a hardware token (USB)
3. Sign using `signtool`:

```powershell
& "C:\Program Files (x86)\Windows Kits\10\bin\x64\signtool.exe" sign `
  /tr http://timestamp.digicert.com `
  /td sha256 /fd sha256 `
  /a `
  "build\windows\x64\runner\Release\dune_awakening_companion.exe"
```

### 4. CI Signing (GitHub Actions)

For Azure Trusted Signing:

```yaml
- name: Sign Windows executable
  uses: azure/trusted-signing-action@v0.5.0
  with:
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-client-secret: ${{ secrets.AZURE_CLIENT_SECRET }}
    endpoint: https://eus.codesigning.azure.net/
    trusted-signing-account-name: ${{ secrets.AZURE_SIGNING_ACCOUNT }}
    certificate-profile-name: ${{ secrets.AZURE_CERT_PROFILE }}
    files-folder: build/windows/x64/runner/Release
    files-folder-filter: exe
    file-digest: SHA256
    timestamp-rfc3161: http://timestamp.acs.microsoft.com
    timestamp-digest: SHA256
```

For traditional code signing with PFX:

| Secret | Value |
|--------|-------|
| `WINDOWS_PFX_BASE64` | Base64-encoded `.pfx` file |
| `WINDOWS_PFX_PASSWORD` | PFX import password |

```yaml
- name: Sign Windows executable
  shell: pwsh
  run: |
    $pfxBytes = [Convert]::FromBase64String("${{ secrets.WINDOWS_PFX_BASE64 }}")
    [IO.File]::WriteAllBytes("$env:RUNNER_TEMP\cert.pfx", $pfxBytes)

    & signtool.exe sign `
      /f "$env:RUNNER_TEMP\cert.pfx" `
      /p "${{ secrets.WINDOWS_PFX_PASSWORD }}" `
      /tr http://timestamp.digicert.com `
      /td sha256 /fd sha256 `
      "build\windows\x64\runner\Release\dune_awakening_companion.exe"
```

---

## Linux

Linux does not have a mandatory code-signing requirement. However, for
distribution via Snap Store or Flathub, packages are sandboxed and
signature-verified by the store infrastructure.

### AppImage (Optional Signing)

```bash
# Build
flutter build linux --release

# Package as AppImage (via appimagetool in CI)
# The AppImage spec supports optional GPG signing:
gpg --detach-sign --armor dune-awakening-companion.AppImage
```

### Snap Store

Snaps are signed automatically when published to the Snap Store. See
[Snapcraft docs](https://snapcraft.io/docs).

### Flathub

Flatpak builds are verified through the Flathub review process. See
[Flathub submission guide](https://docs.flathub.org/).

---

## Verification Checklist

Before each release, confirm:

- [ ] **Android:** `jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk`
- [ ] **macOS:** `codesign --verify --deep --strict dune_awakening_companion.app`
- [ ] **macOS:** `spctl --assess --verbose dune_awakening_companion.app` (Gatekeeper)
- [ ] **Windows:** Right-click `.exe` → Properties → Digital Signatures tab
- [ ] **All:** Test install from scratch on a clean system (VM recommended)

---

## Security Notes

- **Never commit** keystores, `.p12`, `.pfx`, or passwords to the repository.
- Use **GitHub Secrets** or a dedicated secret manager for CI.
- Rotate signing certificates before expiry (set calendar reminders).
- For Android, keep a secure backup of the upload keystore — losing it means
  you cannot update the app on Google Play.
- For macOS, enable two-factor authentication on your Apple Developer account.
