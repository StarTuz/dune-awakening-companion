# Server Migrations — Research & Assessment

Status: **Phases 1–3c implemented.** (closed-world flagging + corrected world
list, "(closed)" markers, custom-world entry, dashboard summary, tap-through to
the official guide, dismissible per-character acknowledgement, dashboard
deep-link to a filtered character list; non-destructive)

This document assesses surfacing Funcom's **server migration / world closures** in
the companion app: flagging characters that live on a world which closed in the
2026-05-26 migration, while still letting users add a character to any world.

Source of truth (official):
`https://duneawakening.com/news/server-migrations/`

---

## Background (game side)

- On **2026-05-26** Funcom ran a server migration that **closed lower-population
  Worlds** to rebalance populations.
- Characters on closing Worlds could **transfer off without spending a Transfer
  Token**; bases/vehicles were preserved via the Base Reconstruction Tool and
  Vehicle Backup Tool. Players could also move to a private or self-hosted server.
- There is **no fixed 1:1 closing → destination mapping**. Migrations to the most
  popular Worlds (e.g. **Pax**, **Harmony**) were limited; most characters were
  distributed across less-populated Worlds. The app therefore links the official
  guide rather than naming a destination.

References:
- [Prepare for Server Migrations](https://duneawakening.com/news/server-migrations/)
- [Server Migrations — Live today](https://duneawakening.com/news/server-migrations-live-today/)
- [Funcom Help Center — How to Migrate & Closing World List](https://funcom.helpshift.com/hc/en/4-dune-awakening/faq/87-server-migration-how-to-migrate-closing-world-list/)
- [MMORPG.com coverage](https://www.mmorpg.com/news/dune-awakening-announces-server-migrations-and-list-of-servers-closing-later-this-month-2000138033)

---

## App side — current model

- `Character` stores `region`, `serverType` (`Official` / `Private` /
  `Self Hosted`), optional `provider`, `world`, `sietch`
  (`lib/features/characters/models/character.dart`).
- For **Official** servers the add/edit flow constrains `world` to a dropdown
  built from `AppConstants.regionWorlds`
  (`lib/core/utils/constants.dart`). Private / Self-Hosted use free-text worlds.
- Closed status is **derivable at runtime from the world name**, so flagging
  needs **no DB migration**.

## The authoritative list vs. the in-app list

The closing list (162 worlds) is a curated, corrected subset of the app's
`regionWorlds`. Two things differ:

1. **Spelling corrections** of names already shipped (garbled in-app → correct):

   | Correct (official) | Legacy in-app | Region |
   |---|---|---|
   | Archidamas III | Archidadas III | EU |
   | Cycliadas | Cyclades | EU |
   | Lampadas | Lamps | EU |
   | Laurrant | Laurent | EU |
   | Octans | Octane | EU |
   | Serpens | Serpents | EU |
   | Bootes | Boots | NA |
   | Fallow Eight | Fall Eight | NA |
   | Laran | Lara | NA |
   | Sagitta | Sagittarius | NA |
   | House of Ilm | House of Knowledge | NA |

   (`Leto` is genuinely new.)

2. **Survivors absent from the closing list** include the announced destination
   Worlds **Pax** and **Harmony** (and **Arrakis**), confirming the list is the
   set of *closing* Worlds, not survivors.

### Correctness trap — name drift
Existing characters were created from the **legacy** dropdown spellings, so a
naïve match against the corrected official names would **silently fail to flag**
them. The closed set therefore includes **both** the official names **and** the
11 legacy aliases above. Matching is trim + case-insensitive.

---

## Design (implemented in Phase 1)

**Data (`lib/core/utils/constants.dart`), no DB migration:**
- `AppConstants.migrationClosedWorlds` — 162 official names + 11 legacy aliases.
- `AppConstants.isClosedWorld(String world)` — trim + case-insensitive lookup.

**Flag UI:**
- A non-destructive badge on the character card (`character_management_screen`)
  when `isClosedWorld(character.world)` is true, with an explanatory tooltip
  referencing the 2026-05-26 migration. Nothing is auto-edited.

**i18n:** badge label + tooltip added to all 7 ARB locales.

**Tests:** unit test for `isClosedWorld` (incl. every legacy alias and a known
survivor like `Arrakis`/`Pax`); widget test asserting the badge renders for a
closed-world character and not for a survivor.

---

## Done in Phase 3a

- **Tap-through to the guide:** the badge is an `InkWell` that opens
  `AppConstants.serverMigrationGuideUrl` via `url_launcher`
  (`LaunchMode.externalApplication`), with an `open_in_new` affordance and a
  localized failure snackbar. Covered by a mocked-`UrlLauncherPlatform` test.

## Done in Phase 3b

- **Dismiss/acknowledge per character:** the badge has a `×` that sets
  `Character.closedWorldAcknowledged` (migration 017, DB v17) via the repository,
  with an Undo snackbar. Badge and dashboard count both respect the flag, and
  editing a character to a *different* world resets the acknowledgement. The
  field is threaded through `copyWith` / `toJson`/`fromJson` (defaulting false
  for older backups) / repo `toMap`/`fromMap`, so it is durable and export-safe.

## Done in Phase 3c

- **Dashboard deep-link / filtered list:** the "On closed worlds" stat is
  tappable — it sets `closedWorldCharacterFilterProvider` and switches to the
  Characters tab, which then shows only characters on closed (unacknowledged)
  worlds with a filter banner + Clear. Covered by widget tests on both screens.
