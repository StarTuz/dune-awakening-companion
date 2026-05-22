# Unique Schematic Blueprints Research

Last updated: 2026-05-22 (Hagga Rift added)

This document tracks the **unique schematic** catalog that powers the
Blueprints / Schematics tracker. Schematics are static drops the app cannot
auto-detect, so the catalog is seeded from public guides and verified by
the player in-game.

---

## Data model

| Field | Notes |
|-------|-------|
| `BlueprintCatalogEntry.name` | Unique across the whole catalog. Duplicate-name schematics that drop in multiple sites are collapsed into one entry with multiple sources. |
| `BlueprintCatalogEntry.category` | One of `Weapon` / `Armor` / `Tool` / `Vehicle` / `Utility` / `Building` / `Schematic` / `Other`. Used for the card subtitle and the edit dialog dropdown. |
| `BlueprintCatalogEntry.sources` | List of `BlueprintSource(region, location)` pairs. Each source describes one in-world chest where the schematic can drop. |
| `Blueprint.region` (persisted) | Stores the *one* region the player marked the schematic discovered at — defaults to the active region filter. The catalog still surfaces every source even after the player marks it found. |

Persistence schema (migration 009 + 010, **DB v12**) is unchanged by the
multi-region rewrite — the catalog shape is presentational only.

---

## Source guides

| Region | Guide |
|--------|-------|
| Hagga Basin South | [All Hagga Basin South Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_Hagga_Basin_South_Unique_Schematics_and_Locations) |
| Vermillius Gap (West + East) | [All Vermillius Gap Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_Vermillius_Gap_Unique_Schematics_and_Locations) |
| Hagga Rift | [All Hagga Rift Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_Hagga_Rift_Unique_Schematics_and_Locations) |

---

## Region coverage

| Region | Sites | Source rows | Unique schematics within region |
|--------|-------|-------------|-------------------|
| Hagga Basin South | 7 | 17 | 17 |
| Vermillius Gap West | 7 | 29 | 29 |
| Vermillius Gap East | 4 | 25 | 25 |
| Hagga Rift | 6 | 41 | 27 |
| **Total source rows** | — | **112** | — |
| **Unique catalog entries** | — | — | **82** (17 Hagga + 39 VG + 26 Hagga Rift¹) |

¹ Hagga Rift has 27 unique schematic *names* internally, but one of them
(`Buoyant Reaper Mk3`) is shared with Vermillius Gap East — so it
contributes 26 *new* catalog entries on top of the existing VG row, which
gains a second source.

### Cross-source schematics

Vermillius Gap West and East share **15 schematics** — same name, two drop
sites:

- `Old Sparky Mk2`, `Hajra Literjon Mk2`, `Scipio's Bloodbag`, `The Emperor's Wings Mk2` (Table of the Gods ↔ Mirzabah's Head)
- `Oathbreaker` ×5 (Coils of the Wyrm ↔ Suk Alusus)
- `Pseudo-Pulse-Sword`, `Mendia's` ×5 (Miner's Watch ↔ Imperial Testing Station No. 10)

Hagga Rift overlaps with Vermillius Gap East on **1 schematic**:

- `Buoyant Reaper Mk3` (Mirzabah's Head ↔ Stepstone Cavern)

Within Hagga Rift, several schematics drop in 2-3 sites of the same region:

- 7 schematics drop in *either* **The Spiral** *or* **Arctus Cavern**
  (Inkvine ×5, Handheld Life Scanner Mk3, Assassin's Rifle)
- 6 schematics drop in *either* the **Deserter Camp** *or* **Choam #6**
  (Callie's Breaker, Old Sparky Mk3, Seb's Kisser, Shock-sword,
  Focused Buggy Cutteray Mk3, Glutton's Bloodbag)
- `Glutton's Bloodbag` actually has **three** drop sites — Deserter Camp,
  Choam #6, *and* Stepstone Cavern.

All multi-source schematics collapse into single catalog entries with the
full sources list — unlocking from any listed site flips the checklist
everywhere it appears.

---

## Site → schematic map

### Hagga Basin South

| Site | Schematics |
|------|------------|
| Wreck of the Alcyon | Kaleff's Drinker |
| Key Hole Rock | Old Sparky Mk1, Mohandis Sandbike Engine Mk1, Sim's Cutter |
| Hagga Basin South (general) | Aren's set (Mask, Chestpiece, Boots, Gloves, Pants), Hajra Literjon Mk1 |
| Broken Stone Station | Aren's Vengeance |
| Imperial Testing Station No. 2 | The Emperor's Wings Mk1 |
| Old Griffin Hideaway | Way of the Fallen |
| Dewgap Gateway | Hollower Stillsuit (Mask, Garment, Gloves, Boots) |

### Vermillius Gap West

| Site | Schematics |
|------|------------|
| Northwest Iron Works | Iri's Gauntlets, Old Sparky Mk2¹, Scipio's Drinker |
| Miner's Watch | Mendia's set (Boots, Gauntlets, Jacket, Pants, Wrap)¹, Pseudo-Pulse-Sword¹ |
| Table of the Gods | Buoyant Reaper Mk2, Hajra Literjon Mk2¹, Scipio's Bloodbag¹, The Emperor's Wings Mk2¹ |
| Coils of the Wyrm | Oathbreaker set (Boots, Chestpiece, Gauntlets, Headwrap, Pants)¹ |
| Imperial Station No. 197 | Olef's Quickcutter, Softstep Boots |
| Wreck of the Pallas | Fila's Regret, Legion Tattoo, Mohandis Sandbike Engine Mk2, Way of the Wanderer |
| The Anomaly | Compact Compactor Mk3, Kel's Stillsuit (Boots, Garment, Gloves, Mask) |

### Vermillius Gap East

| Site | Schematics |
|------|------------|
| Mirzabah's Head | Buoyant Reaper Mk3², Hajra Literjon Mk2¹, Old Sparky Mk2¹, Scipio's Bloodbag¹, The Emperor's Wings Mk2¹ |
| Suk Alusus | Oathbreaker set¹ |
| Ghanima Cavern | Menol's Stillsuit (Boots, Garment, Gloves, Mask), Night Rider Sandbike Boost Mk2 |
| Imperial Testing Station No. 10 | Pseudo-Pulse-Sword¹, Bigger Buggy Boot Mk3, Bluddshot Buggy Engine Mk3, Mendia's set¹, Mohandis Sandbike Engine Mk3, Night Rider Sandbike Boost Mk3 |

¹ Also drops in the other Vermillius Gap sub-region.
² Also drops in Hagga Rift (Stepstone Cavern).

### Hagga Rift

| Site | Schematics |
|------|------------|
| The Spiral | Inkvine set (Mask, Jacket, Gauntlets, Pants, Boots)³, Handheld Life Scanner Mk3³, Assassin's Rifle³ |
| Arctus Cavern | Inkvine set³, Handheld Life Scanner Mk3³, Assassin's Rifle³ |
| Deserter Camp in Imperial Testing Station No. 29 | Callie's Breaker⁴, Glutton's Bloodbag⁵, Old Sparky Mk3⁴, Seb's Kisser⁴, Shock-sword⁴, Focused Buggy Cutteray Mk3⁴ |
| Choam Mineral Extraction Facility No. 6 | Callie's Breaker⁴, Glutton's Bloodbag⁵, Old Sparky Mk3⁴, Seb's Kisser⁴, Shock-sword⁴, Focused Buggy Cutteray Mk3⁴ |
| Stepstone Cavern | Buoyant Reaper Mk3², Glutton's Bloodbag⁵, Hajra Literjon Mk3, Shock Gauntlets, Skin-Lined Jacket, Ta'lab Softstep Boots, The Emperor's Wings Mk3 |
| Wreck of Kytheria | Karak's set (Helmet, Jacket, Gauntlets, Pants, Boots), Way of the Lost Maula Pistol, Zaal's Companion Assault Rifle, Ripper Scattergun |

³ Drops at *either* The Spiral *or* Arctus Cavern.
⁴ Drops at *either* the Deserter Camp *or* Choam Mineral Extraction Facility No. 6.
⁵ Glutton's Bloodbag drops at *all three* of Deserter Camp, Choam #6, and Stepstone Cavern.

---

## Gotchas worth surfacing in-app later

These don't shape the data model today, but the IGN guides flag them
repeatedly — worth a per-site "tips" string in a future iteration:

- **ID bands required.** Wreck of the Pallas (VG West) needs a band cut
  out of a sealed door with a Cutteray. Suk Alusus (VG East) uses a
  **purple** band pulled from a market room. The Spiral and Arctus
  Cavern (Hagga Rift) both gate the chest behind a **pentashield**;
  Arctus Cavern's ID band is **red** and the matching shield turns
  green once the band is collected.
- **False bookshelves / glowing vertical yellow lines** open hidden rooms
  containing Minimic Films in most Imperial Testing Stations.
- **Radiation hazards.** The Anomaly (VG West) requires radiation
  protection; Wreck of the Pallas has irradiated rooms that can be
  avoided.
- **Poison gas.** Choam Mineral Extraction Facility No. 6 (Hagga Rift)
  has multiple gas-filled rooms — bring filters or move fast.
- **Fire / scan-and-cut doors.** Wreck of Kytheria (Hagga Rift) is
  reached via a "ragged hole" in the main floor with fire below; the
  chest sits behind a sealed door that must be scanned, then cut
  through.
- **Vertical descent / climb.** Deserter Camp sits inside a giant
  vertical tunnel above Imperial Testing Station No. 29; the chest is
  in a secret cavern partway down. Stepstone Cavern requires
  Grappler + suspension gear (or careful stamina-managed climbing) to
  reach the schematic ledge.
- **45-minute chest respawn.** Every multi-schematic site loops back:
  each chest cycles through the drop pool, so completionists need
  multiple visits. The `respawnTimerEnabled` flag on `Blueprint` exists
  for this but is not auto-enabled by the seed.
- **Climb requirements.** Table of the Gods, Mirzabah's Head: easiest
  via Ornithopter; otherwise scale an adjacent butte and grapple/jump.

---

## Categorisation notes

IGN guides don't tag schematics with a category — entries below were
classified by name pattern and existing Hagga Basin precedent:

| Pattern | Category | Examples |
|---------|----------|----------|
| `... Stillsuit ...`, `... Mask/Boots/Gauntlets/Gloves/Pants/Jacket/Wrap/Chestpiece/Headwrap` | Armor | Hollower set, Kel's set, Mendia's set, Oathbreaker set |
| `Old Sparky`, `... Sword`, `... Drinker`, `Aren's Vengeance`, `Way of the ...`, `Fila's Regret` | Weapon | Old Sparky Mk1/Mk2, Pseudo-Pulse-Sword |
| `... Compactor`, `... Cutter / Quickcutter`, `Buoyant Reaper` | Tool | Compact Compactor Mk3, Sim's Cutter, Olef's Quickcutter |
| `... Literjon`, `... Bloodbag` | Utility | Hajra Literjon Mk1/Mk2, Scipio's Bloodbag |
| `... Sandbike Engine / Boost`, `... Buggy Engine / Boot`, `... Wings` | Vehicle | Mohandis Sandbike Engine, Night Rider Boost, The Emperor's Wings |
| `Legion Tattoo` | Other | — (cosmetic; no dedicated category yet) |

If in-game inspection contradicts any of these, update both the catalog
and the canon test in lockstep.

---

## Backlog

- **Per-site tips/notes** — promote the gotchas above to per-source
  `BlueprintSource.tip` (currently those details live only in this doc).
- **Respawn-timer auto-enable** — IGN confirms a uniform 45-minute respawn
  for all chest-locked schematics; could prefill `respawnTimerEnabled` on
  seeded rows.
- **Hagga Basin North / East / West** — IGN guides exist; same pattern
  applies.
- **Deep Desert** — schematics there are dynamic / event-driven, so they
  may need a separate model (not chest-locked).
- **Cross-character schematic unlocks** — if Funcom confirms unique
  schematics are per-account rather than per-character, the persistence
  layer needs to denormalise `is_unlocked` out of the per-character row.
