# Smoke Test Runbook – Dune Awakening Companion App

Last updated: 2026-03-17  
Targets: **Linux, Windows, Android** (with most hands-on testing on Linux/Android)

This runbook defines a fast, high-signal smoke test to run before releases or major merges.  
It assumes the app is built and runnable on the target platform.

---

## 1. Core CRUD & Persistence (All Platforms)

### 1.1 Characters & Bases

1. Launch the app.
2. Create:
   - **One Official character** with at least **2 bases**.
   - **One Private character** (with a hosting provider selected) and at least **1 base**.
3. Navigate through:
   - `Dashboard` – counts should reflect created characters/bases.
   - `Characters` – verify character cards and their Bases button.
   - `Bases` – verify list shows bases with correct owning character names.
4. Fully close and relaunch the app.
5. Re-check the screens above and confirm **data persisted correctly**.

### 1.2 Quest Journal

1. Open the **Journal** tab in the main navigation.
2. Confirm **Add Quest** is blocked (snackbar) when there are no characters; create a character if needed.
3. For each character:
   - Add a quest with:
     - Type (e.g. `challenge`).
     - Status (e.g. `active`).
     - Mission Type (e.g. `Exploration`, or **None**).
     - Landsraad Contract = ON for at least one quest.
     - Repeatable = ON for at least one quest.
     - Optional **reminder** (date + time); on **Android/iOS** a system notification should fire at that time (with app notifications enabled). On **Linux/desktop**, opening the app after that time should show the reminder and clear it from the quest.
   - Add **2–3 steps**, mark at least one step completed; **edit** a step; **drag-reorder** steps and confirm order persists after closing the sheet.
4. Use **search**, **status**, and **type** filter chips; confirm the list filters as expected (empty filter message vs. “no quests yet”).
5. Close and relaunch the app.
6. Return to **Journal** and confirm:
   - Quests and steps still exist.
   - Completed steps remain completed.
   - Step order persisted.

### 1.3 Character Progress

1. Open **Characters**.
2. For one character, tap **Progress**:
   - Adjust all 5 specialization sliders (Combat, Crafting, Gathering, Exploration, Sabotage) to non-zero values.
   - Add a **Faction entry** (e.g. Atreides rank 5, some contracts completed).
   - Add an **Augmentation** with:
     - Name, slot (e.g. Helmet), optional source boss, notes.
     - Mark it as **Equipped**.
3. Fully close and relaunch the app.
4. Re-open **Progress** and verify all values persisted and are correctly displayed.

---

## 2. Alerts & Per‑Base Overrides

### 2.1 Baseline Alerts (All Platforms)

1. Create at least two bases with different expiration times:
   - Base A: expires in **~2 hours**.
   - Base B: expires in **~30 hours**.
2. On **Dashboard**:
   - Confirm **Expiring Soon** and **Active Alerts** counts align with expectations:
     - Active Alerts should reflect bases below the critical threshold.
3. On **Alerts**:
   - Confirm both bases appear with correct severity labels:
     - Base A should be **CRITICAL**.
     - Base B should be **WARNING**.

### 2.2 Per‑Base Notification Overrides

1. Edit one base (e.g. Base B):
   - Turn **Notifications** OFF and save.
2. Verify:
   - That base no longer appears in the **Alerts** screen.
   - Dashboard’s alert counts update accordingly after a refresh.
3. Re-edit the base:
   - Turn **Notifications** ON.
   - Enable **Custom alert thresholds** (e.g. Warning 72h, Critical 12h).
4. Adjust expiration time so that:
   - The base is above default warning/critical thresholds but inside the custom thresholds.
5. Confirm:
   - The base appears in **Alerts** with severity based on **custom thresholds**, not the default 48h/24h rules.

### 2.3 Quiet Hours (Linux/Windows + Android)

1. In **Settings → Notifications**:
   - Enable **Quiet Hours**.
   - Set a short window (e.g. starting 1 minute from now and ending 5 minutes later).
2. Ensure a base will cross a threshold during quiet hours (e.g. set expiration very near).
3. On desktop:
   - Use tray **Check Alerts** (or Settings → Test Alerts) during quiet hours.
4. On Android:
   - Trigger a manual alert check (through in-app controls) during quiet hours.
5. Confirm:
   - No notifications are displayed during quiet hours.
6. After quiet hours end:
   - Trigger another check and confirm notifications now appear.

---

## 3. Dashboard Analytics (All Platforms)

With the test data from sections 1–2 in place:

1. Open **Dashboard**.
2. Verify:
   - Character and base **stat cards** show expected counts.
   - **Characters by Region** bar chart:
     - Each region with characters appears with the correct count.
   - **Base Alert Distribution** pie chart:
     - Critical, Warning, and Safe slices match the current bases and their notification settings.
3. Modify data:
   - Change a character’s region.
   - Change a base’s expiration time and/or notification overrides.
4. Pull-to-refresh on Dashboard.
5. Confirm both charts and stat cards update to reflect the new data.

---

## 4. Export / Import (Linux + Android)

### 4.1 Export ZIP Backup (Linux)

1. On Linux, open **Settings → Data Management → Export Data**.
2. Choose a save location and export.
3. Confirm:
   - A `.zip` file is created.
   - Size is non-zero and reasonable for your data volume.

Optional: Copy this ZIP to an Android device for cross-platform restore testing.

### 4.2 Clear & Import – Replace

1. Use **Settings → Clear All Data**.
2. Fully restart the app.
3. Confirm:
   - `Dashboard`, `Characters`, `Bases`, `Alerts`, `Journal`, and `Progress` are all empty.
4. Import the previously exported ZIP in **Replace** mode:
   - `Settings → Import Data → Replace`.
5. Confirm:
   - All characters and bases are restored.
   - Quests and quest steps are restored.
   - Specializations, faction progress, and augmentations are restored.

### 4.3 Import – Merge

1. Create **one new character** locally (distinct name from backup characters).
2. Import the same ZIP, this time in **Merge** mode:
   - `Settings → Import Data → Merge`.
3. Confirm:
   - The new character still exists.
   - Imported content is present.
   - No unexpected duplicates beyond what the import format would naturally produce.

---

## 5. System Tray & Notifications (Linux/Windows)

These are primarily desktop checks.

1. Start the app on **Linux or Windows**.
2. Close the window:
   - Confirm the app **minimizes to tray** instead of exiting.
3. From the tray menu:
   - **Show Window**: window restores and focuses.
   - **Toggle Notifications**:
     - When turned OFF, confirm alerts no longer fire.
     - When turned ON, alerts resume normally.
   - **Check Alerts**:
     - With critical/expiring bases configured, confirm:
       - A notification is shown (outside quiet hours).
       - The tray alert badge count matches critical alerts.
   - **Quit**:
     - App exits fully and tray icon disappears.

---

## 6. Quick Regression Checklist

Before tagging a release, at minimum:

1. **Linux desktop**
   - Run sections **1**, **2.1**, **3**, **4.1–4.2**, and **5**.
2. **Android**
   - Run sections **1**, **2.1–2.3**, and **4.3** (merge import).
3. **Windows**
   - Run section **5** plus a brief pass of **1.1** and **2.1**.

If all of the above pass, the build is in good enough shape to proceed to the full release checklist in `docs/RELEASE_CHECKLIST.md`.

