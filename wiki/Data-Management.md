# Data Management

Backup and restore your data with export/import features.

---

## 💾 Overview

Protect your data with:
- **Export:** Create JSON backups
- **Import:** Restore from backups
- Cross-platform compatible files

---

## 📤 Exporting Data

### How to Export

1. Go to **Settings**
2. Tap **Export Data**
3. Choose save location
4. File saved with timestamp

### What's Exported

| Data | Included |
|------|----------|
| Characters | ✅ All character details |
| Bases | ✅ All bases with power/tax |
| Portraits | ✅ Base64 encoded images |
| Settings | ❌ App settings not included |

### File Format

Exports are JSON files:
```
dune_companion_backup_2025-12-25_12-30-00.json
```

### Storage Tips

- Save to cloud storage (Google Drive, Dropbox)
- Keep multiple backup versions
- Export before major updates
- Export before uninstalling

---

## 📥 Importing Data

### How to Import

1. Go to **Settings**
2. Tap **Import Data**
3. Select your backup file
4. Choose import mode:
   - **Merge:** Add to existing data
   - **Replace:** Clear all data first

### Merge Mode

- Adds imported characters/bases
- Skips duplicates
- Preserves existing data
- Best for combining data from devices

### Replace Mode

- **Clears all existing data first!**
- Imports all data from backup
- Best for full restore
- Use with caution

---

## 🔄 Transferring Between Devices

1. **Export** on your old device
2. Transfer the `.json` file (email, cloud, USB)
3. **Import** on your new device
4. Choose **Replace** for full transfer

---

## ⚠️ Backup Best Practices

### Regular Backups

- Export weekly
- Export before updates
- Export before device changes
- Keep multiple versions

### Safe Storage

Store backups in:
- Cloud storage (synced)
- External drive
- Email to yourself
- Multiple locations

### Version Naming

Consider renaming with dates:
```
dune_backup_christmas_2025.json
dune_backup_before_update.json
```

---

## 🔧 Troubleshooting

### Import Fails

- Verify it's a valid JSON file
- Check file isn't corrupted
- Ensure correct file was selected
- Try a different backup

### Data Missing After Import

- Did you use Merge when you meant Replace?
- Check if data was in the backup
- Verify backup was complete

### Large Backups

Backups with many portraits can be large:
- This is normal
- Images are embedded in the file
- Just takes longer to transfer

---

## 📱 Platform Storage Locations

### Where Data is Stored

| Platform | Location |
|----------|----------|
| Windows | `%APPDATA%\dune_awakening_companion\` |
| Linux | `~/.local/share/dune_awakening_companion/` |
| macOS | `~/Library/Application Support/dune_awakening_companion/` |
| Android | Internal app storage |

### Database File

- Main database: `app_database.db`
- Contains all characters and bases
- Use Export for portable backups

---

*Protect your data like you protect the spice!* 🏜️
