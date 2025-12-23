# Notifications & System Tray Implementation Plan

**Feature:** Background notifications and system tray integration for v1.0  
**Estimated Time:** 10-12 hours  
**Priority:** HIGH - Essential for v1.0 release

---

## Overview

This feature enables the app to run in the background (desktop) or periodically check (mobile) for expiring bases and notify users when action is needed.

**User Value:**
- "Set it and forget it" - users don't need to manually check
- System tray persistence (desktop) - app stays accessible
- Timely alerts prevent base loss
- Professional, complete app experience

---

## Implementation Phases

### Phase 1: Notification Service ✅ (Current)
**Files to Create:**
- `lib/core/services/notification_service.dart`
- `lib/core/providers/notification_provider.dart`

**Responsibilities:**
- Initialize flutter_local_notifications
- Create notification channels
- Schedule notifications
- Handle notification taps

**Platform Support:**
- Desktop: Local notifications
- Mobile: Local notifications with WorkManager

---

### Phase 2: Alert Checker Service
**Files to Create:**
- `lib/core/services/alert_checker_service.dart`
- `lib/core/providers/alert_checker_provider.dart`

**Responsibilities:**
- Query database for bases
- Calculate time remaining
- Determine which bases need alerts
- Return list of notification-worthy bases

**Alert Triggers:**
- Power < 24h (Critical)
- Power < 48h (Warning) - if enabled
- Tax overdue (Critical)
- Tax due < 24h (Warning) - if enabled

---

### Phase 3: Background Worker (Mobile)
**Files to Create:**
- `lib/core/services/background_worker_service.dart`

**Responsibilities:**
- Register WorkManager periodic task
- Execute alert checks every 30-60 minutes
- Trigger notifications if needed
- Battery-friendly scheduling

**Configuration:**
- Default: Check every 30 minutes
- User setting: 15/30/60 minute intervals
- Constraint: Only when device idle

---

### Phase 4: System Tray Manager (Desktop)
**Files to Create:**
- `lib/core/services/system_tray_service.dart`
- `lib/core/providers/system_tray_provider.dart`

**Responsibilities:**
- Initialize system tray icon
- Create right-click context menu
- Show alert badge count
- Handle menu item clicks

**Menu Items:**
- "Show Window" - Restore app
- "Check Alerts" - Trigger immediate check
- "Notifications: On/Off" - Quick toggle
- "Quit" - Exit app

**Badge:**
- Show count of critical alerts (< 24h)
- Update when alerts change

---

### Phase 5: Settings Integration
**Files to Update:**
- `lib/features/settings/screens/settings_screen.dart`

**New Settings:**
- **Enable Notifications** (toggle)
- **Check Interval** (15/30/60 minutes)
- **Warning Notifications** (toggle) - includes < 48h alerts
- **Critical Only** (default) - only < 24h alerts
- **Start Minimized to Tray** (desktop only)

**Settings Storage:**
- Use shared_preferences
- Default: Notifications ON, 30 min interval, Critical only

---

### Phase 6: App Lifecycle Changes
**Files to Update:**
- `lib/main.dart`

**Desktop Behavior:**
- Window close → Minimize to tray (don't quit)
- Tray icon always visible when app running
- "Quit" from tray → Actually quit

**Mobile Behavior:**
- Register background worker on startup
- Request notification permissions
- Schedule periodic checks

---

## Technical Specifications

### Notification Format

**Power Alert:**
```
Title: "⚡ Power Running Low"
Body: "Main Base (Harko Village) - 5 hours remaining"
Action: Opens app to Bases screen
```

**Tax Alert:**
```
Title: "💰 Tax Payment Due"
Body: "Desert Outpost - Due in 12 hours"
Action: Opens app to Bases screen
```

### System Tray Icon

**States:**
- Normal: Standard app icon
- Alerts: Icon with badge showing count
- Disabled: Grayed out icon (if notifications off)

### Background Check Logic

```dart
1. Wake up (WorkManager trigger)
2. Query all bases from database
3. Calculate time remaining for each
4. Filter bases needing alerts:
   - Power < threshold
   - Tax < threshold or overdue
5. Group by severity (critical vs warning)
6. Show notifications (max 3 at once)
7. Sleep until next interval
```

### Battery Optimization

**Mobile:**
- Use WorkManager constraints (idle, not low battery)
- Respect user's battery saver mode
- Graceful degradation if permissions denied

**Desktop:**
- Minimal CPU usage (event-driven)
- Only recalculate when needed
- Efficient database queries

---

## Testing Checklist

### Desktop
- [ ] System tray icon appears
- [ ] Right-click menu works
- [ ] Badge shows correct count
- [ ] Notifications appear at correct times
- [ ] Clicking notification opens app
- [ ] Window minimize → tray
- [ ] Quit from tray exits app
- [ ] Works on Linux
- [ ] Works on Windows
- [ ] Works on macOS

### Mobile
- [ ] Notification permission requested
- [ ] Background worker registered
- [ ] Notifications appear when app closed
- [ ] Clicking notification opens app
- [ ] Settings persist across restarts
- [ ] Works on Android
- [ ] Works on iOS

### Settings
- [ ] Toggle notifications on/off
- [ ] Change check interval
- [ ] Toggle warning notifications
- [ ] Settings saved correctly
- [ ] UI updates immediately

---

## Dependencies

**Already in pubspec.yaml:**
- ✅ `flutter_local_notifications` - Notifications
- ✅ `workmanager` - Background tasks (mobile)
- ✅ `system_tray` - System tray (desktop)
- ✅ `permission_handler` - Permission requests
- ✅ `shared_preferences` - Settings storage

**New:**
- ✅ `tray_manager` - Better tray management

---

## Rollout Strategy

**v1.0 Initial Release:**
- Notifications enabled by default
- 30-minute check interval
- Critical alerts only (< 24h)
- Desktop: System tray enabled
- Mobile: WorkManager background checks

**v1.1 Enhancements:**
- Quiet hours (e.g., 10 PM - 8 AM)
- Per-base notification settings
- Sound/vibration customization
- Notification history

---

**Status:** Phase 1 starting now  
**Next:** Create NotificationService
