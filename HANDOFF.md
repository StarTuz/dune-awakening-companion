# Dune Awakening Companion App - Handoff Document

**Date:** December 21, 2024  
**Status:** Core features complete, ready for testing and expansion

---

## 📱 Application Overview

The Dune Awakening Companion App is a cross-platform Flutter application designed to help players manage their characters, bases, and power countdown timers across multiple Dune Awakening servers.

### Key Features Implemented

✅ **Multi-Character Management**
- Track unlimited characters across regions and servers
- Support for Official servers (227 worlds across 5 regions)
- Support for Private servers (5 major hosting providers)
- Full character context: Region, World, Sietch

✅ **Unlimited Base Tracking per Character**
- Each character can have unlimited bases
- Individual power countdown per base (Days/Hours/Minutes format)
- Color-coded status indicators:
  - 🔴 Red: < 6 hours (Critical)
  - 🟡 Yellow: < 24 hours (Warning)
  - 🟢 Green: > 24 hours (Safe)

✅ **Smart Alert System**
- Automatic alerts for bases expiring in < 48 hours
- Visual alert icon with:
  - Badge showing alert count
  - Color indicating most urgent base (Red < 24h, Yellow < 48h)
- Detailed alerts screen showing:
  - Base name and severity
  - Character context (name, region, world, sietch)
  - Time remaining and expiration date
  - One-tap navigation to manage bases

✅ **Adaptive Navigation**
- Desktop: NavigationRail (side panel)
- Mobile: BottomNavigationBar
- Consistent across platforms

✅ **Database with Migrations**
- SQLite with proper migration system
- **Version 4 schema** with character/base support, tax tracking, and portrait support
- Desktop (FFI) and mobile compatibility

✅ **Data Management (Export/Import)** ⭐ NEW!
- Export all data to JSON backup files
- Import from backups with Merge or Replace options
- Custom save/load locations via file picker
- Validation and preview before import
- Backup format: `dune_companion_backup_YYYYMMDD_HHMMSS.json`
- Platform-agnostic (works on all platforms)

✅ **Character Portraits** ⭐ NEW!
- Add custom portraits to characters
- Auto-resize to 512×512 (accepts any size)
- CircleAvatar display in character list
- Portrait picker in Add/Edit dialogs
- Automatic cleanup on character delete
- JPEG optimization (quality 85)
- Works with in-game screenshots!

🚧 **Notifications & System Tray** ⚠️ IN PROGRESS (90% Complete)
- ✅ Cross-platform notification service (Desktop + Mobile)
- ✅ Background alert checking (timer-based desktop, WorkManager mobile)
- ✅ System tray icon (Linux/Windows/macOS)
- ✅ Right-click tray menu (Show Window, Check Alerts, Toggle Notifications, Quit)
- ✅ Window close → Minimize to tray (doesn't quit)
- ✅ Settings UI integration (enable/disable, intervals, warning levels)
- ✅ Test notification button
- ⚠️ **Known Issue:** Toggle from tray menu needs state sync fix
- 📝 Power and Tax alert notifications fully implemented
- 📝 Alert count badge in tray menu

✅ **Settings Screen**
- App version and build information
- **Notification Settings** - Enable/disable, intervals, warning levels ⭐ NEW!
- **Export Data** - Backup to custom location
- **Import Data** - Restore from backup (Merge/Replace)
- Data management (Clear All Data)
- Legal disclaimers and copyright notices
- Acknowledgments to Herbert Estate, Funcom, and community
- MIT License viewer

✅ **Dashboard**
- Real-time statistics from database
- Expiring Soon count (< 48h for power or tax)
- Active Alerts count (< 24h power or critical tax)
- Character and base counts
- Pull-to-refresh support

---

## 🏗️ Architecture

### Directory Structure

```
lib/
├── core/
│   ├── database/
│   │   ├── app_database.dart          # Database initialization
│   │   └── migrations/
│   │       ├── migration_001_initial.dart
│   │       └── migration_002_add_server_fields.dart
│   └── utils/
│       └── constants.dart              # Regions, worlds, providers
├── features/
│   ├── characters/
│   │   ├── models/character.dart       # Character data model
│   │   ├── providers/character_provider.dart
│   │   ├── services/character_repository.dart
│   │   └── screens/character_management_screen.dart
│   ├── bases/
│   │   ├── models/base.dart            # Base data model
│   │   ├── providers/base_provider.dart
│   │   ├── services/base_repository.dart
│   │   └── (screens removed - managed per character)
│   ├── alerts/
│   │   └── screens/alerts_screen.dart  # Shows expiring bases
│   ├── dashboard/
│   │   └── screens/dashboard_screen.dart
│   └── settings/
│       └── screens/settings_screen.dart
└── shared/
    ├── navigation/main_navigation.dart  # Adaptive nav
    └── theme/app_colors.dart           # Dune-themed colors
```

### Data Models

**Character Model:**
```dart
{
  id: String (UUID)
  name: String
  region: String (North America, Europe, Asia, Oceania, South America)
  serverType: String (Official, Private)
  provider: String? (for private servers)
  world: String (227 official worlds OR custom private name)
  sietch: String
  portraitPath: String? (path to character portrait image)
  createdAt: DateTime
  updatedAt: DateTime
}
```

**Base Model:**
```dart
{
  id: String (UUID)
  characterId: String (FK to Character)
  name: String
  powerExpirationTime: DateTime
  createdAt: DateTime
  updatedAt: DateTime
  
  // Tax Tracking (Advanced Fiefs)
  isAdvancedFief: bool
  taxPerCycle: int? (Solari)
  nextTaxDueDate: DateTime?
  currentOwed: int? (current cycle)
  overdueOwed: int? (grace period)
  defaultedOwed: int? (shields down)
  
  // Computed:
  hoursRemaining: double (from powerExpirationTime)
  totalTaxOwed: int (sum of all owed amounts)
  daysUntilTax: double (from nextTaxDueDate)
  taxStatus: TaxStatus (NONE, PAID, DUE, OVERDUE, DEFAULTED)
  isTaxCritical: bool (defaulted or overdue)
}
```

### State Management

- **Riverpod** for state management
- **AsyncValue** pattern for loading/error states
- **StateNotifier** for complex state mutations
- **FutureProvider** for one-time data loads (avoiding circular dependencies)

---

## 🎯 User Workflows

### Adding a Character
1. Tap **+** button on Characters screen
2. Enter character name
3. Select Region (dropdown)
4. Select Server Type (Official/Private)
   - **Official:** Pick World from dropdown (auto-filtered by region)
   - **Private:** Select Provider + manually enter World/Server Name
5. Enter Sietch name
6. Save

### Managing Bases
1. Navigate to **Characters** screen
2. Click **"Bases"** button on desired character card
3. Dialog opens showing all bases for that character
4. **Add Base:** Tap floating **+** button
   - Enter base name
   - Enter power countdown (Days/Hours/Minutes)
5. **Edit Base:** Tap edit icon to update countdown after refueling
6. **Delete Base:** Tap delete icon

### Monitoring Alerts
1. Navigate to **Alerts** screen
2. See all bases expiring in < 48 hours, sorted by urgency
3. Each alert shows:
   - Severity badge (CRITICAL/WARNING)
   - Base name
   - Character context
   - Time remaining
4. Tap any alert card → navigates to Characters screen
5. Pull-to-refresh or tap refresh icon to update

---

## 🎨 Design Decisions

### Why Move Power Tracking to Bases?
- **Original Issue:** Power was tracked per character, limiting to 1 countdown
- **Solution:** Each base tracks its own power expiration
- **Benefits:**
  - Unlimited bases per character
  - Accurate representation of game mechanics
  - Cleaner character list UI

### Why Remove Formal Alert System?
- **Original Issue:** Complex alert management (acknowledge/dismiss) was overkill
- **Solution:** Show all expiring bases directly (< 48 hours)
- **Benefits:**
  - Simpler UX
  - No manual alert management
  - Auto-updates as bases approach expiration

### Server Type Distinction
- **Official Servers:** Use curated list of 227 worlds across 5 regions
- **Private Servers:** Provider selection + manual world entry
- **Rationale:** Private server names are custom and unpredictable

### Color Coding Strategy
- **< 6 hours:** Red (Critical) - Immediate action needed
- **< 24 hours:** Yellow (Warning) - Plan refuel soon
- **< 48 hours:** Yellow (shown in alerts, advance warning)
- **> 48 hours:** Green (Safe)

---

## 🔧 Technical Implementation Notes

### Database Migrations
- **Version 1:** Initial schema with server_id (deprecated)
- **Version 2:** New schema with region/serverType/provider/world fields
- **Version 3:** Tax tracking fields for Advanced Fiefs
- **Version 4:** Character portrait support (portraitPath field) ⭐ NEW!
- **Migration Strategy:** ALTER TABLE for compatible changes, table recreation for incompatible schema changes
- **Important:** Migrations run automatically on app startup

###Data Management (Export/Import) ⭐ **NEW - IMPLEMENTED**

**Complete backup and restore system:**

✅ **Export Service:**
- Exports all characters and bases to JSON
- Format: `{ version, exportDate, databaseVersion, characters[], bases[] }`
- Pretty-printed JSON for readability
- Custom save location via file picker
- Timestamped filenames: `dune_companion_backup_YYYYMMDD_HHMMSS.json`
- Platform-agnostic (Android, iOS, Linux, Windows, macOS)

✅ **Import Service:**
- Import from JSON backup files
- **Two modes:**
  - **Merge**: Add backup data to existing data
  - **Replace**: Clear all data, then import backup
- JSON validation (structure, version, data types)
- Preview before import (shows character/base counts)
- Transaction-based import (all-or-nothing)
- Detailed error reporting
- Auto-refresh UI after import

✅ **User Experience:**
- Export: File save dialog with suggested filename
- Import: File picker → Preview → Choose mode → Confirmation
- Replace mode has extra confirmation (warns about data deletion)
- Progress indicators during export/import
- Success messages with file paths
- Comprehensive error handling

✅ **Implementation:**
```dart
// Services
lib/features/settings/services/export_service.dart
lib/features/settings/services/import_service.dart

// Providers
lib/features/settings/providers/import_export_provider.dart
```

### Character Portraits ✅ **COMPLETE!**

**Full CRUD implementation with automatic image optimization:**

✅ **Database:**
- Migration 004: Added `portraitPath` column to characters table
- Character model updated with optional `portraitPath` field
- CharacterRepository updated to save/load portrait paths
- JSON serialization regenerated

✅ **Image Service:**
- Upload and process images
- Auto-resize to 512×512 (square, optimized)
- Convert to JPEG (quality 85)
- Save to app documents/portraits folder
- Validate images (size < 2MB, format check)
- Delete portraits when character deleted

✅ **UI Implementation:**
- **Add Character Dialog**: Portrait picker with preview
- **Edit Character Dialog**: Update/change/remove portrait
- **Character List**: CircleAvatar display with portrait or fallback icon
- **Delete Character**: Auto-cleanup of portrait files

✅ **Packages:**
- `file_picker` - Select images from storage
- `image` - Process and resize images

✅ **Features:**
- Create: Add portrait when creating character
- Read: Display portrait in character list
- Update: Change/remove portrait when editing
- Delete: Auto-delete portrait file on character delete
- Any image size works - auto-optimized to 512×512

**User Experience:**
- In-game screenshots work perfectly
- Any dimensions accepted (auto-resized)
- Circular display in list (radius: 28px)
- Larger preview in dialogs (radius: 50px)
- Visual polish for v1.0!

### Avoiding Riverpod Circular Dependencies
- **Problem:** Using `ref.watch()` inside dialogs that modify the same provider causes circular dependency
- **Solution:** Use `FutureBuilder` with `ref.read()` for one-time data loads in dialogs
- **Example:** Base management dialog loads bases once, doesn't watch reactively

### Desktop Database Initialization
- Uses `sqflite_common_ffi` for desktop platforms
- Initialized in `AppDatabase._initDatabase()` before opening DB
- Database path determined by platform (Android/iOS/Desktop)

---

## 🚀 Future Enhancements (Planned)

### 💰 Tax Tracking Feature ⭐ **IMPLEMENTED**

**Complete tax management system for Advanced Fiefs**

✅ **Tax Data Model:**
- Tax Per Cycle (Solari)
- Next Tax Due Date (with D/H/M countdown)
- Current Owed (current cycle)
- Overdue Owed (grace period, < 14 days past due)
- Defaulted Owed (shields down, > 14 days past due)
- Tax Status: NONE, PAID, DUE, OVERDUE, DEFAULTED

✅ **Smart Auto-Increment:**
- Automatically detects missed tax cycles when editing base
- Calculates owed amounts based on time elapsed
- Moves amounts between Current → Overdue → Defaulted
- Shows helper message: "⚠️ Tax overdue by X days! Auto-calculated amounts."
- User can verify/edit for accuracy

✅ **Tax Calculator:**
- Formula: 4,000 base + (Stakes × 2,000)
- Interactive stakes input → auto-calculates tax
- Example: 2 stakes = 8,000 Solari per cycle

✅ **Add/Edit Base Dialogs:**
- Checkbox: "This is an Advanced Fief (pays taxes)"
- Tax Per Cycle input with calculator helper
- Tax Due In: [Days] [Hours] [Minutes] (matches power format)
- Current/Overdue/Defaulted Owed inputs
- All fields editable for manual accuracy

✅ **Base Display (Characters → Bases):**
- Power status with countdown
- Tax status badge (PAID/DUE/OVERDUE/DEFAULTED)
- Amount owed (if > 0)
- Tax per cycle
- Next due countdown

✅ **Alerts Screen:**
- Shows both "Time Remaining: Power" and "Time Remaining: Taxes"
- Separate countdowns with color coding
- Red (< 24h or overdue), Yellow (< 48h), Green (> 48h)
- Includes tax due date

✅ **Tax Cycle Logic:**
- **14-day cycle** (standard Dune Awakening)
- **14-day grace period** after due date
- **28+ days overdue** → Defaulted (shields down)
- Auto-calculates missed cycles on edit

---

## 🎯 Future Enhancements (Roadmap)

### **v1.1 - Data Portability** (Next Priority)
**Goal:** Allow users to backup and share their data

1. **📤 Export Feature**
   - Export all characters and bases to JSON file
   - Include timestamp in filename
   - Save to downloads/documents folder
   - Success notification with file location

2. **📥 Import Feature**
   - File picker to select backup JSON
   - Validation before import
   - Option to merge or replace existing data
   - Import summary showing what was added

3. **🧪 Testing**
   - Test export on desktop and mobile
   - Test import with various data sizes
   - Verify data integrity after import/export cycle

**Estimated Time:** 2-3 hours

---

### **v1.2 - Customizable Settings** (Quality of Life)
**Goal:** Let users customize thresholds and preferences

1. **⚙️ Alert Thresholds**
   - "Expiring Soon" threshold (default: 48h, range: 24-168h)
   - "Critical Alert" threshold (default: 24h, range: 1-48h)
   - Tax warning days (default: 1 day, range: 1-7 days)

2. **🕒 Time & Format Preferences**
   - 12-hour vs 24-hour clock
   - Date format (MM/DD/YYYY, DD/MM/YYYY, YYYY-MM-DD)
   - Time zone display

3. **💰 Tax Defaults**
   - Default tax cycle length (12-16 days)
   - Default grace period (12-16 days)
   - Auto-save preferences to database

**Estimated Time:** 3-4 hours

---

### **v2.0 - Notifications & Polish** (Major Update)
**Goal:** Proactive alerts and enhanced UX

1. **🔔 Local Notifications**
   - Notify when power < threshold
   - Notify when tax due < threshold  
   - Notify when tax becomes overdue
   - Platform-specific implementation (android/ios/desktop)

2. **🎨 Theme Customization**
   - Dark/Light mode toggle
   - Accent color picker
   - Dune-inspired color presets

3. **🌍 Multi-Language Support**
   - Internationalization (i18n) setup
   - Strings externalization
   - Priority languages: English, French, German, Spanish

4. **📊 Enhanced Dashboard**
   - Charts showing power distribution
   - Tax liability timeline
   - Next expiration preview
   - Quick actions (add character/base)

**Estimated Time:** 10-15 hours

---

### **v3.0 - Advanced Features** (Long-term)
**Goal:** Power user features and community integration

1. **👥 Multi-Account Support**
   - Manage multiple game accounts
   - Switch between accounts
   - Separate character lists per account
   - Account-level settings

2. **☁️ Cloud Sync** (Optional)
   - Firebase or custom backend
   - Sync across devices
   - Conflict resolution
   - Privacy considerations

3. **📱 Widget Support**
   - Home screen widget showing next expiration
   - Quick glance at critical bases
   - Platform-specific (Android/iOS)

4. **🔗 Community Features**
   - Share base configurations
   - Import shared templates
   - Community presets for common setups

**Estimated Time:** 20-30 hours

---

## 🚀 Immediate Next Steps (Start Here!)

### **Priority 1: User Testing** ⭐
- [ ] Test on real devices (Android, iOS, Linux, Windows)
- [ ] Gather user feedback on UX
- [ ] Fix any critical bugs discovered
- [ ] Performance testing with many characters/bases

### **Priority 2: Export/Import** (v1.1)
- [ ] Implement JSON export functionality
- [ ] Implement JSON import with validation
- [ ] Add file picker integration
- [ ] Test data portability

### **Priority 3: Polish & Documentation**
- [ ] Create user guide/tutorial
- [ ] Record demo video/GIF
- [ ] Prepare store listings (if publishing)
- [ ] Add in-app help tooltips

### **Priority 4: Customizable Settings** (v1.2)
- [ ] Add threshold customization
- [ ] Add time/date format options
- [ ] Persist settings to database
- [ ] Update UI to respect custom thresholds

---

## 📋 Testing Checklist (Before v1.0 Release)

### Core Functionality
- [ ] Add/Edit/Delete characters
- [ ] Add/Edit/Delete bases
- [ ] Power countdown updates correctly
- [ ] Tax auto-increment works
- [ ] Alerts show correct bases
- [ ] Dashboard counts accurate

### Tax System
- [ ] Tax calculator accurate
- [ ] Auto-increment detects missed cycles
- [ ] Grace period logic correct
- [ ] Defaulted status shows shields down
- [ ] Tax displays on all screens

### Cross-Platform
- [ ] Works on Android
- [ ] Works on iOS
- [ ] Works on Linux desktop
- [ ] Works on Windows desktop
- [ ] Navigation adapts correctly

### Data Integrity
- [ ] Database migrations work
- [ ] Data persists after app restart
- [ ] Clear All Data works safely
- [ ] No data corruption

### UI/UX
- [ ] All text readable
- [ ] Colors accessible (contrast)
- [ ] Buttons responsive
- [ ] Dialogs closeable
- [ ] Error messages helpful

---

## 🐛 Known Issues & Limitations

### Current Issues
1. ~~Database migration error on Android~~ ✅ **FIXED**
2. ~~Circular dependency in base dialogs~~ ✅ **FIXED**
3. ~~Missing refresh on alerts screen~~ ✅ **FIXED**

### Limitations
1. **No Background Sync:** App must be open to update countdowns (by design for battery)
2. **Manual Time Entry:** Users must manually enter/update power countdowns from in-game
3. **No In-Game Integration:** Cannot read data directly from game (API limitations)
4. **Private Server Worlds:** Must be manually entered (no official list available)

---

## 🧪 Testing Checklist

- [ ] Add character (Official server)
- [ ] Add character (Private server)
- [ ] Edit character details
- [ ] Delete character
- [ ] Add multiple bases to character
- [ ] Edit base power countdown
- [ ] Delete base
- [ ] Verify countdown display format (Xd Xh Xm)
- [ ] Check color coding (red/yellow/green)
- [ ] Navigate to alerts screen
- [ ] Verify alerts show bases < 48h
- [ ] Test pull-to-refresh on alerts
- [ ] Test navigation from alert card to characters
- [ ] Verify alert icon badge count
- [ ] Verify alert icon color changes (red/yellow/gray)
- [ ] Test on mobile (bottom nav)
- [ ] Test on desktop (side rail nav)
- [ ] Test database persistence (close/reopen app)

---

## 📦 Dependencies

### Core
- `flutter: sdk`
- `flutter_riverpod: ^2.4.0` - State management
- `riverpod_annotation: ^2.3.0` - Code generation

### Database
- `sqflite: ^2.3.0` - SQLite (mobile)
- `sqflite_common_ffi: ^2.3.0` - SQLite (desktop)
- `path: ^1.8.3`
- `path_provider: ^2.1.1`

### Utilities
- `uuid: ^4.2.2` - ID generation
- `intl: ^0.18.1` - Date formatting
- `json_annotation: ^4.8.1` - JSON serialization

### Dev Dependencies
- `build_runner: ^2.4.6`
- `json_serializable: ^6.7.1`
- `riverpod_generator: ^2.3.0`

---

## 🏃 Running the Application

### Development
```bash
# Install dependencies
flutter pub get

# Generate code (models, providers)
dart run build_runner build --delete-conflicting-outputs

# Run on desktop (Linux)
flutter run -d linux

# Run on mobile (Android)
flutter run -d android

# Hot reload: r
# Hot restart: R (capital R) - use after database schema changes
```

### Production Build
```bash
# Android APK
flutter build apk --release

# Linux Desktop
flutter build linux --release

# Install location for Linux binary:
# build/linux/x64/release/bundle/
```

### Database Management
```bash
# Location (Linux):
~/.local/share/com.example.dune_awakening_companion/dune-awakening-companion/dune_companion.db

# Delete to reset (during development):
rm ~/.local/share/com.example.dune_awakening_companion/dune-awakening-companion/dune_companion.db

# Then hot restart app to recreate with fresh schema
```

---

## 📝 Code Style & Patterns

### Naming Conventions
- **Providers:** `somethingProvider` (e.g., `charactersProvider`, `basesProvider`)
- **Models:** PascalCase (e.g., `Character`, `Base`)
- **Screens:** PascalCase with `Screen` suffix (e.g., `DashboardScreen`)
- **Private methods:** `_methodName` (e.g., `_showAddDialog`)

### File Organization
- One widget/class per file (with exception of small helper widgets)
- Group by feature, not by type
- Keep related files close (model + provider + repository + screen)

### State Management Pattern
```dart
// 1. Define provider
final somethingProvider = StateNotifierProvider<SomethingNotifier, AsyncValue<List<Something>>>(...);

// 2. Watch in widget
final dataAsync = ref.watch(somethingProvider);

// 3. Consume with .when()
dataAsync.when(
  data: (items) => ...,
  loading: () => ...,
  error: (error, stack) => ...,
);

// 4. Mutate state
ref.read(somethingProvider.notifier).create(...);
```

---

## 🤝 Contributing

### Before Making Changes
1. Run `flutter analyze` to check for issues
2. Ensure all existing tests pass
3. Update this handoff document if architecture changes

### Database Schema Changes
1. Create new migration file: `migration_00X_description.dart`
2. Increment version in `app_database.dart`
3. Add migration to `_onUpgrade` method
4. Test by deleting DB and hot restarting

### Adding New Features
1. Follow existing directory structure
2. Create model → repository → provider → screen
3. Use Riverpod for state management
4. Add to navigation if needed
5. Update handoff documentation

---

## 📞 Support & Questions

### Common Issues

**Q: App shows error after adding character**  
A: Delete database and hot restart. Schema mismatch from development.

**Q: Bases not refreshing after edit**  
A: We pop all dialogs after mutations. Reopen "Bases" dialog to see updates.

**Q: Alert icon stuck in error state**  
A: Tap refresh icon on alerts screen or pull-to-refresh.

**Q: Private server world not in dropdown**  
A: Correct! Private servers use manual entry (no official list exists).

---

## 🎉 Project Status

**Current Phase:** ✅ MVP + Tax + Export/Import Complete ⭐  
**Next Phase:** 🎨 Complete Portraits → 🌍 Multi-Language (v1.0)  
**Ready for:** Production testing, user feedback, feature expansion

### Recently Completed (Dec 22, 2024): ⭐ NEW!

✅ **Export/Import System**
- Full data backup to JSON files
- Restore from backups (Merge or Replace modes)
- Custom save/load locations
- Validation and preview
- Platform-agnostic implementation
- User-friendly dialogs and error handling

✅ **Character Portraits** ⭐ NEW!
- Add/Edit/Delete portraits for characters
- Auto-resize to 512×512 (any source size accepted)
- CircleAvatar display in character list
- Portrait picker in Add/Edit dialogs
- Automatic cleanup on character delete
- JPEG optimization (quality 85)
- Works with in-game screenshots!

### Previously Completed (Dec 21, 2024):

✅ **Tax Tracking System**
- Full tax management for Advanced Fiefs
- Smart auto-increment with missed cycle detection
- Tax calculator (4,000 base + Stakes × 2,000)
- Separate Power and Tax countdowns in Alerts
- Color-coded status badges (PAID/DUE/OVERDUE/DEFAULTED)
- Grace period handling (14 days)
- Shields down detection (28+ days)

✅ **Settings Screen**
- Complete About section with version info
- **Export/Import functionality** ⭐
- Legal disclaimers (unofficial, fan-made)
- Copyright notices (Funcom, Herbert Estate)
- Acknowledgments to community and development tools
- Clear All Data functionality
- MIT License viewer

✅ **Dashboard Enhancements**
- Real-time counts from database
- Expiring Soon: < 48h warning
- Active Alerts: < 24h critical
- Pull-to-refresh support

### Core Features (Stable):
✅ Multi-character management (unlimited characters)  
✅ Multi-base tracking (unlimited bases per character)  
✅ Power countdown system (D/H/M format)  
✅ Tax tracking with auto-increment  
✅ Smart alert system (< 48h warning, < 24h critical)  
✅ **Data backup and restore** ⭐  
✅ Adaptive navigation (desktop/mobile)  
✅ Database migrations (v4)  
✅ Professional settings with legal protection  

**Last Updated:** December 22, 2024  
**Version:** 1.0.0-beta  
**Build:** Database v4, Tax Tracking, Export/Import, Portraits (In Progress)

---

## 📞 Contact & Support

This is a community project. For issues, suggestions, or contributions:
- Review the Testing Checklist above
- Check the roadmap for planned features
- Test on your platform and provide feedback

**Development Stack:**
- Flutter (Dart)
- Riverpod for state management
- SQLite for data persistence
- Google Antigravity IDE + Claude Sonnet 4.5

**Legal:**
- Unofficial fan project
- No Funcom affiliation
- MIT License
- Use at your own risk

---

**🌟 May your power stay charged and your taxes stay paid! 🌟**
