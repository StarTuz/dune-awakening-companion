# Dune Awakening Companion App - FAQ

**Frequently Asked Questions**

---

## ⏰ Time Tracking & Countdowns

### Q: If I close the app for hours or days and then reopen it, will the tracking update correctly?

**A: YES!** ✅ All countdowns update automatically and accurately.

**How it works:**
- We store **absolute dates/times** in the database (e.g., "Power expires at Dec 23, 2:05 PM")
- When you open the app, we calculate: `targetTime - currentTime = remaining`
- This means countdowns are always accurate, regardless of when you last opened the app

**Example:**
- Close app with "Power: 1d 5h" → Reopen 6 hours later → Shows "Power: 23h" ✅

**Note:** The app doesn't run in the background (to save battery), but everything updates the instant you open it!

---

### Q: Do I need to keep the app open for tracking to work?

**A: No!** You can close the app completely. When you reopen it, all countdowns will immediately show the correct current time.

---

### Q: Will I get notifications when power is running low?

**A: YES!** (v1.0.4+)
- **Desktop:** Notifications appear in your system notification center
- **Mobile:** Background notifications (check every 15-60 mins)
- **Controls:** Customize sound, vibration, and quiet hours in Settings
- **History:** View past alerts in the Notification History screen

---

## Chapter 3 Tax Removal

### Q: What happened to tax tracking?

**A:** Dune Awakening Chapter 3 removed base taxes, so the companion app removed tax tracking, tax alerts, and tax calculator workflows. Existing old backup data with tax fields is harmless and ignored by current imports.

---

## 📊 Characters & Bases

### Q: How many characters and bases can I add?

**A:** Unlimited! You can add:
- Unlimited characters across any servers
- Unlimited bases per character
- No restrictions

---

### Q: Can I have characters on different servers?

**A: Yes!** The app supports:
- **Official Servers**: 227 worlds across 5 regions (North America, Europe, Asia, Oceania, South America)
- **Private Servers**: 5 major hosting providers (G-Portal, Nitrado, etc.)

Each character stores its server info independently.

---

### Q: What's the difference between Official and Private servers?

**A:**
- **Official**: Select from a curated list of 227 worlds
- **Private**: Select provider, then manually enter world/server name

This is because private server names are custom and unpredictable.

---

## 💾 Data Management

### Q: Can I backup my data?

**A: Yes!** Go to Settings → Data Management → Export Data

This creates a JSON file with all your characters and bases, saved to your Downloads folder with a timestamp: `dune_companion_backup_20241222_143000.json`

---

### Q: How do I restore from a backup?

**A:** Go to Settings → Data Management → Import Data

You'll see two options:
- **Merge**: Add backup data to existing data (keeps everything)
- **Replace**: Delete all current data, then import backup (fresh start)

The app will show you how many characters and bases are in the backup before you import.

---

### Q: What happens if I delete a character?

**A:** Deleting a character also deletes:
- All bases belonging to that character
- **Character portrait** (if one was added)
- All data is permanently removed

**Tip:** Export a backup before deleting, just in case!

---

### Q: Can I add a picture/portrait to my characters?

**A: Yes!** ⭐ NEW in v1.0!

**How to add a portrait:**
1. Go to Characters screen
2. Click **Add Character** (or **Edit** for existing characters)
3. Tap the circle at the top of the dialog
4. Select an image from your device
5. The portrait appears instantly!

**Best practices:**
- 📸 **In-game screenshots work perfectly!**
- Any image size accepted (we auto-resize to 512×512)
- Use Photo Mode in-game for best results
- Center your character in the frame
- Remove UI/HUD if possible
- Square crops look best (but not required!)

**Technical specs:**
- Max file size: 2MB
- Accepted formats: PNG, JPG, WEBP
- Auto-converted to JPEG (quality 85%)
- Stored locally on your device

**Editing/removing:**
- Edit the character to change the portrait
- Click "Remove" to delete the portrait
- Portraits are auto-deleted when you delete a character

**Pro tip:** Just take a screenshot and upload it – the app handles all the optimization! 🎨

---

## 🎨 User Interface

### Q: What do the different colors mean?

**A:** We use color-coding for quick status recognition:

**Power & Tax Countdowns:**
- 🔴 **Red**: Critical (< 24 hours or overdue)
- 🟡 **Yellow**: Warning (< 48 hours)
- 🟢 **Green**: Safe (> 48 hours)

**Tax Status Badges:**
- 🟢 **PAID**: All taxes paid, no amount owed
- 🟡 **DUE**: Tax payment is due soon
- 🟠 **OVERDUE**: Past due, still in grace period
- 🔴 **DEFAULTED**: Shields down! Base at risk!

---

### Q: What's the difference between Dashboard and Alerts?

**A:**
- **Dashboard**: Overview statistics (total characters, bases, expiring soon, critical alerts)
- **Alerts**: Detailed list of bases needing attention (< 48h for power or tax)

Both screens auto-update based on your data!

---

## 🔧 Technical

### Q: Where is my data stored?

**A:** Locally on your device in an SQLite database:
- **Linux**: `~/.local/share/com.example.dune_awakening_companion/`
- **Windows**: `%APPDATA%\com.example.dune_awakening_companion\`
- **Android**: App data directory
- **iOS**: App documents directory

Your data **never leaves your device** unless you manually export it.

---

### Q: Do you collect any data?

**A: No!** This app:
- Stores everything locally on your device
- Does not connect to the internet
- Does not send data anywhere
- Does not track you
- Is completely offline

The only data that exists is what you enter, and it stays on your device.

---

### Q: Can I use this on multiple devices?

**A:** Yes, but you need to manually sync:
1. Export data from Device A (Settings → Export)
2. Transfer the JSON file to Device B
3. Import data on Device B (Settings → Import → Merge)

**Future:** Cloud sync is planned for v3.0 (optional, opt-in only)

---

## 🎮 Game Integration

### Q: Does this connect to the game?

**A: No.** This is a **companion app**, not an integration. You manually enter your character and base information from the game.

**Why:** Dune Awakening doesn't have a public API, so we can't pull data automatically.

---

### Q: Is this official / approved by Funcom?

**A: No.** This is an **unofficial, fan-made** companion app:
- NOT affiliated with Funcom
- NOT endorsed or supported by Funcom
- Funcom had no input in development
- Use at your own risk

See Settings → Legal & Acknowledgments for full disclaimers.

---

### Q: Can I get banned for using this?

**A:** No risk of bans because:
- The app doesn't connect to the game
- It doesn't modify game files
- It's purely a tracking tool (like a notebook)
- It's completely separate from Dune Awakening

---

## 🐛 Troubleshooting

### Q: The app won't open / crashes on startup

**A:** Try these steps:
1. Restart your device
2. Check if you have the latest version
3. If still failing, try deleting the database (Settings → Clear All Data)
4. Export a backup first if you have important data!

---

### Q: My countdowns aren't updating

**A:** Try:
1. Pull-to-refresh (swipe down) on the Alerts screen
2. Close and reopen the app
3. Check that the base's expiration time was entered correctly

Remember: The app only updates when it's open (no background processes).

---

### Q: I lost my data after an update

**A:** App updates should preserve data, but:
- Always export a backup before major updates
- If data is lost, try importing your latest backup
- Report the issue so we can investigate

---

## 🚀 Feature Requests

### Q: Will you add [feature]?

**A:** Check the roadmap in `NEXT_STEPS.md`! Planned features include:
- **v1.0**: Character portraits, Multi-language support
- **v1.1**: Quest journal
- **v2.0**: Push notifications, Theme customization
- **v3.0**: Cloud sync, Multi-account support

Feel free to suggest features! This is a community project.

---

### Q: Can I contribute?

**A:** Yes! This project is open source (MIT License). See the GitHub repository for:
- Source code
- Issue tracker
- Contribution guidelines
- Development setup

---

## 📞 Getting Help

### Q: I have a question not answered here

**A:** You can:
1. Check the `HANDOFF.md` documentation for technical details
2. Review the `NEXT_STEPS.md` for feature plans
3. Open an issue on GitHub
4. Ask in Dune Awakening community forums

---

### Q: I found a bug!

**A:** Please report it with:
- What you were doing when the bug occurred
- What you expected to happen
- What actually happened
- Your platform (Linux, Windows, Android, iOS)
- App version (found in Settings → About)

Screenshots help too!

---

## 💡 Tips & Tricks

### Tip 1: Keep Power Timers Fresh
Update each base's power countdown right after refueling so alerts stay accurate.

### Tip 2: Export Regularly
Make it a habit to export your data monthly. It's your safety net!

### Tip 3: Color Coding is Your Friend
Scan the Alerts screen for color codes:
- All green? Relax!
- Yellow? Check soon
- Red? Urgent action needed!

### Tip 4: Use the Quest Journal
Break longer quest chains into steps and add notes while details are fresh.

### Tip 5: Use Descriptive Base Names
"Main Base" is okay, but "Aluminium Production" or "Desert Outpost" helps you identify bases faster!

### Tip 6: Check Alerts Before Logging Out
Make it the last screen you check before closing the app – know what needs attention next time you play!

---

**Last Updated:** May 19, 2026  
**App Version:** 1.3.0-beta  
**Database Version:** v11

---

**Need more help?** Check `HANDOFF.md` for technical documentation or open a GitHub issue.

**May your power stay charged!** 🌟
