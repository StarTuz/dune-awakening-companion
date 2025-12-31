# Release Notes v1.0.8

**Date:** December 30, 2025  
**Status:** Stable Release (Tax System Enhancement)

This release introduces **automatic tax cycle tracking** based on Dune Awakening's 14-day tax cycle mechanics.

## ✨ New Feature: Tax Auto-Increment

### The Problem

When your `nextTaxDueDate` passed and you had previously paid your taxes (all owed amounts = 0), the app showed "DUE" and "Overdue by: Xd Xh" but didn't show **how much** you owed. This was confusing because a new tax cycle starts automatically every 14 days.

### The Solution

The app now automatically calculates:

- **Missed Cycles**: How many 14-day tax periods have passed since your due date
- **Effective Current Owed**: Auto-adds `taxPerCycle` for the current cycle
- **Effective Overdue Owed**: Previous cycle taxes that aged past the due date (within 14-day grace period)
- **Effective Defaulted Owed**: All taxes that aged past the grace period (shields down!)
- **Effective Next Due Date**: Rolls forward by missed cycles × 14 days

### How It Works

| Scenario | What Happens |
|----------|-------------|
| Due date passes (was paid) | Auto-sets amount owed to `taxPerCycle` |
| 1-13 days overdue | Current → Overdue, new Current = taxPerCycle |
| 14+ days overdue | Everything → Defaulted (shields down) |
| Multiple cycles missed | Accumulates correctly |

### Display Changes

- Shows "1 cycle overdue (Xd Xh Xm)" instead of "Overdue by: -Xd -Xh"
- Shows "X cycles overdue" for multiple missed cycles
- Amount Owed now displays the correct auto-calculated total

## 🔧 Technical Changes

### Constants Added

- `kTaxCycleDays = 14` - Standard tax cycle length
- `kGracePeriodDays = 14` - Grace period before shields down

### New Computed Getters in `Base` Model

- `missedCycles` - Number of 14-day cycles past due
- `effectiveCurrentOwed` - Auto-calculated current owed
- `effectiveOverdueOwed` - Includes aged current owed
- `effectiveDefaultedOwed` - Past grace period amounts
- `effectiveNextTaxDueDate` - Rolled forward due date
- `daysPastDue` - Days since original due date
- `storedTaxOwed` - Raw stored values (for reference)

### Files Changed

- `lib/features/bases/models/base.dart` - Core auto-increment logic
- `lib/features/characters/screens/character_management_screen.dart` - Updated display
- `lib/core/services/alert_checker_service.dart` - Uses effective values

## 📥 Install

- **Linux:** Download `dune-companion-linux-v1.0.8.tar.gz`
- **Windows:** Download `dune-companion-windows-v1.0.8.zip`
- **Android:** Download `app-release.apk`
- **macOS:** Download `dune-companion-macos-v1.0.8.dmg`
