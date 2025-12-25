# Tax System

Complete guide to tracking taxes for Advanced Fiefs.

---

## 💰 Overview

Advanced Fiefs in Dune Awakening require regular tax payments. The companion app helps you track:
- Tax per cycle amount
- Current owed taxes
- Overdue taxes (grace period)
- Defaulted taxes (shields down)

---

## 🏰 Enabling Tax Tracking

1. Add or edit a base
2. Enable the **Advanced Fief** toggle
3. The base now tracks taxes

---

## 📅 Tax Cycle

Advanced Fiefs have a weekly tax cycle:
- **Cycle:** 7 days
- **Grace Period:** 14 days after cycle ends
- **Default:** After grace period expires

### Status Breakdown

| Status | Condition | Meaning |
|--------|-----------|---------|
| **PAID** | Current owed = 0 | All taxes paid |
| **DUE** | Current owed > 0 | Payment due this cycle |
| **OVERDUE** | Overdue > 0, < 14 days | In grace period |
| **DEFAULTED** | Overdue > 14 days | Shields may drop! |

---

## 🧮 Tax Calculator

The base tax formula:

```
Tax = 4,000 + (Stakes × 2,000)
```

| Stakes | Tax Per Cycle |
|--------|---------------|
| 0 | 4,000 |
| 1 | 6,000 |
| 2 | 8,000 |
| 3 | 10,000 |
| 4 | 12,000 |
| 5 | 14,000 |

The app includes a built-in calculator to help determine your tax amount.

---

## ✏️ Managing Taxes

### Updating Owed Amount

1. Edit the Advanced Fief base
2. Update the **Current Owed** field
3. The app tracks changes

### Smart Auto-Increment

When you edit a base and cycles have passed:
- The app detects missed tax cycles
- Prompts you to update the owed amount
- Helps you stay accurate

---

## 📊 Tax Status Display

Each Advanced Fief shows:
- Tax per cycle amount
- Current owed
- Overdue owed (if any)
- Defaulted owed (if any)
- Status badge

### Status Badges

| Badge | Color | Meaning |
|-------|-------|---------|
| **PAID** | Green | All good! |
| **DUE** | Yellow | Payment needed soon |
| **OVERDUE** | Orange | In grace period |
| **DEFAULTED** | Red | Critical! |

---

## 🔔 Tax Alerts

You'll receive alerts for:
- **Tax Due:** When payment is required
- **Tax Overdue:** When in grace period
- **Tax Defaulted:** Critical - shields at risk!

See [Notifications](Notifications.md) to configure alerts.

---

## 💡 Tips

### Stay on Top of Taxes

- Check tax status weekly
- Pay before the cycle ends
- Don't let overdue accumulate

### Multiple Advanced Fiefs

- Name bases clearly
- Review all fiefs before logging off
- Use the Alerts screen for overview

---

*Pay your taxes, or face the Landsraad!* 🏜️
