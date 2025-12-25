# 🔔 Adding Custom Notification Sounds

This guide explains how to add custom notification sounds to the Dune Awakening Companion App.

---

## Overview

Custom notification sounds require platform-specific setup since each platform handles audio assets differently.

**Current Implementation:**
- Sound toggle (on/off) ✅
- Vibration toggle (on/off) ✅
- Uses system default sounds

**Future Enhancement:**
- Custom Dune-themed sounds (sandworm rumble, spice harvester, etc.)

---

## Platform-Specific Instructions

### Android

**1. Add Sound Files**

Place audio files in:
```
android/app/src/main/res/raw/
```

Supported formats: `.mp3`, `.ogg`, `.wav`

Naming convention: lowercase with underscores
```
android/app/src/main/res/raw/
├── alert_critical.mp3
├── alert_warning.mp3
└── alert_tax.mp3
```

**2. Update Android Notification Channels**

In `lib/core/services/notification_service.dart`, modify `_createAndroidChannels()`:

```dart
const criticalChannel = AndroidNotificationChannel(
  'critical_alerts',
  'Critical Alerts',
  description: 'Urgent alerts for bases < 24 hours',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('alert_critical'), // No extension!
  enableVibration: true,
);
```

**3. Reference in Notification Details**

```dart
final androidDetails = AndroidNotificationDetails(
  channelId,
  'Channel Name',
  channelDescription: 'Description',
  sound: RawResourceAndroidNotificationSound('alert_critical'),
  playSound: soundEnabled,
);
```

**Important Notes:**
- Channel settings are cached! Users must reinstall app or clear data to hear new sounds
- Sound file names must be lowercase
- No file extension in the code reference

---

### iOS / macOS

**1. Add Sound Files to Xcode**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click `Runner` folder → "Add Files to Runner..."
3. Add your sound files (`.caf`, `.aiff`, `.wav`)
4. Ensure "Copy items if needed" is checked
5. Ensure "Add to targets: Runner" is checked

**2. Update Notification Details**

```dart
final iosDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: soundEnabled,
  sound: 'alert_critical.caf', // Include extension for iOS
);
```

**Notes:**
- iOS sound files must be < 30 seconds
- Preferred format: `.caf` (Core Audio Format)
- Convert with: `afconvert input.mp3 output.caf -d ima4 -f caff`

---

### Linux

Linux notifications use the system theme's default sounds. Custom sounds require:
- Using `libnotify` directly (bypassing flutter_local_notifications)
- Or playing sounds separately via an audio package

**Current approach:** Uses system default (no custom sound support)

---

### Windows

Windows notifications support custom sounds but require:
- `.wav` files added to the app bundle
- Modifying the Windows notification plugin

**Current approach:** Uses system default

---

## Recommended Implementation Plan

### Phase 1: Create Sound Assets
1. Source or create Dune-themed sounds (< 5 seconds, royalty-free)
2. Convert to appropriate formats:
   - Android: `.ogg` or `.mp3`
   - iOS: `.caf`

### Phase 2: Add to Project
1. Create `android/app/src/main/res/raw/` directory
2. Add Android sounds
3. Add iOS sounds via Xcode

### Phase 3: Update Code
1. Modify `_createAndroidChannels()` to reference custom sounds
2. Update `_showNotification()` to use custom sounds
3. Add UI picker for sound selection (optional)

### Phase 4: Test
1. Uninstall app (Android channels cache)
2. Reinstall and test notifications
3. Test on iOS simulator/device

---

## Sound Ideas (Dune-themed)

| Alert Type | Sound Idea |
|------------|------------|
| Critical (< 24h) | Deep sandworm rumble, urgent horn |
| Warning (< 48h) | Spice harvester hum, distant call |
| Tax Due | Coin/credit sound, Arrakis wind |
| Test | Ornithopter startup |

---

## Code Reference

**File:** `lib/core/services/notification_service.dart`

Key methods:
- `_createAndroidChannels()` - Define channels with sounds
- `_showNotification()` - Apply sound settings per notification

**File:** `lib/core/services/notification_settings.dart`

Key properties:
- `soundEnabled` - Master sound toggle
- (Future) `selectedSound` - Sound choice enum

---

## Resources

- [flutter_local_notifications docs](https://pub.dev/packages/flutter_local_notifications)
- [Android notification sounds](https://developer.android.com/develop/ui/views/notifications/channels#importance)
- [iOS sound requirements](https://developer.apple.com/documentation/usernotifications/unnotificationsound)
- [Free sound resources](https://freesound.org/) (check licenses)

---

*Last Updated: December 24, 2025*
