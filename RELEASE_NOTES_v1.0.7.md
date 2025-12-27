# Release Notes v1.0.7

**Date:** December 27, 2025  
**Status:** Stable Release (Bug Fix)

This release fixes a critical bug causing **false tax notifications** every 30 minutes.

## 🐛 Bug Fixes

### False Tax Notifications (Critical)
- **Problem:** Users received "Tax Payment Due" notifications every 30 minutes even when all taxes were paid (Tax: PAID status).
- **Cause:** The notification system was checking only if `nextTaxDueDate` was within 24/48 hours, ignoring whether any tax was actually owed.
- **Fix:** Added `totalTaxOwed > 0` check to both the alert checker and dashboard logic. Notifications now only trigger when there is unpaid tax.

### Dashboard "Expiring Soon" Count
- **Problem:** The "Expiring Soon" counter on the Dashboard was incorrectly counting bases with upcoming tax dates even when taxes were paid.
- **Fix:** Added the same `totalTaxOwed > 0` check to ensure only bases with actual unpaid taxes are counted.

## 📦 Files Changed
- `lib/core/services/alert_checker_service.dart`
- `lib/features/dashboard/screens/dashboard_screen.dart`

## 📥 Install
- **Linux:** Download `dune-companion-linux-v1.0.7.tar.gz`
- **Windows:** Download `dune-companion-windows-v1.0.7.zip`
- **Android:** Download `app-release.apk`
- **macOS:** Download `dune-companion-macos-v1.0.7.dmg`
