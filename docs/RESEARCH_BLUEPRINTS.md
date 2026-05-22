# Unique Schematic Blueprints Research

Last updated: 2026-05-22 (The O'odham added)

This document tracks the **unique schematic** catalog that powers the
Blueprints / Schematics tracker. Schematics are static drops the app cannot
auto-detect, so the catalog is seeded from public guides and verified by
the player in-game.

---

## How chest drops actually work

Each unique-schematic chest **rolls one schematic from a shared pool**
on each respawn cycle, not a fixed drop. IGN's "drops at site A or
site B" wording is misleading — it's "chests at A and B share a pool,
so players farm both in rotation while waiting on the 45-minute
respawn." This shapes the data model and the player workflow:

- The catalog stores **every chest a schematic can roll from** as a
  separate `BlueprintSource`. Unlock state is keyed by schematic name,
  so a single successful roll at *any* listed chest ticks the schematic
  off everywhere it appears.
- The respawn timer (`Blueprint.respawnTimerEnabled`, set per row)
  exists precisely so players can manage the multi-site cycling loop.
  Auto-enabling it on seed for chest-locked rows is a backlog item.
- A given site can be a chest pool of size 1 (single fixed schematic)
  or N (e.g. Imperial Testing Station No. 10's 10-entry pool).

When a schematic appears in many sources (e.g. Glutton's Bloodbag at 6
sites), that doesn't mean "6 chests guaranteed to drop it" — it means
"6 chests that include it in their pool, and players sometimes need
multiple rolls before it lands."

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
| Jabal Eifrit (Al-gharb, Al-Janub, Al-sharq) | [All Jabal Eifrit Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_Jabal_Eifrit_Unique_Schematics_and_Locations) |
| Shield Wall (Eastern + Western) | [All Shield Wall Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_Shield_Wall_Unique_Schematics_and_Locations) |
| The O'odham | [All The O'odham Unique Schematics and Locations — IGN](https://www.ign.com/wikis/dune-awakening/All_The_O%27odham_Unique_Schematics_and_Locations) |

---

## Region coverage

| Region | Sites | Source rows | Unique schematics within region |
|--------|-------|-------------|-------------------|
| Hagga Basin South | 7 | 17 | 17 |
| Vermillius Gap West | 7 | 29 | 29 |
| Vermillius Gap East | 4 | 25 | 25 |
| Hagga Rift | 6 | 41 | 27 |
| Jabal Eifrit Al-gharb | 2 | 16 | 16 |
| Jabal Eifrit Al-Janub | 4 | 29 | 22 |
| Jabal Eifrit Al-sharq | 3 | 20 | 13 |
| Eastern Shield Wall | 4 | 45 | 35 |
| Western Shield Wall | 4 | 48 | 25 |
| The O'odham | 5 | 52 | 13 |
| **Total source rows** | — | **322** | — |
| **Unique catalog entries** | — | — | **148** (17 Hagga + 39 VG + 26 Hagga Rift¹ + 8 Jabal Eifrit² + 55 Shield Wall³ + 3 O'odham⁴) |

¹ Hagga Rift has 27 unique schematic *names* internally, but one of them
(`Buoyant Reaper Mk3`) is shared with Vermillius Gap East — so it
contributes 26 *new* catalog entries on top of the existing VG row, which
gains a second source.

² Jabal Eifrit reuses **most** of the Hagga Rift + Vermillius Gap drop
pool (Karak set, Inkvine set, Way of the Lost Maula Pistol, Zaal's
Companion Assault Rifle, Ripper Scattergun, Callie's Breaker, Old Sparky
Mk3, Seb's Kisser, Shock-sword, Glutton's Bloodbag, Handheld Life
Scanner Mk3, Hajra Literjon Mk3, Shock Gauntlets, Skin-Lined Jacket,
Ta'lab Softstep Boots, The Emperor's Wings Mk3, Buoyant Reaper Mk3) —
those existing entries each gain 1-3 Jabal Eifrit sources rather than
new catalog rows. Only 8 schematics are truly Jabal-Eifrit-exclusive
(Ripper Searing Shiv, Spice-infused Steel/Copper Dust, Glutton's
Drinker, Reaper Gloves, The Tapper, Rigged Suspensor Jacket, Filter
Extractor Mk3).

⁴ The O'odham is **almost entirely overlap** with Shield Wall — 29 of
the 32 schematics IGN lists at O'odham sites are existing Shield Wall
catalog rows gaining O'odham sources rather than new rows. Only three
schematics are O'odham-exclusive: Firestorm (ITS 163), Ironwatch
Special (ITS 163), and Compression-Stim Leggings (ITS 71).

³ Shield Wall is mostly Mk4 versions of earlier-tier schematics
(Bigger Buggy Boot Mk4, Filter Extractor Mk4, Focused Buggy Cutteray
Mk4, The Emperor's Wings Mk4, Buoyant Reaper Mk4, Mohandis Sandbike
Engine Mk4, Old Sparky Mk4, Hajra Literjon Mk4, Bluddshot Buggy Engine
Mk4, Compact Compactor Mk4, Night Rider Sandbike Boost Mk4, plus new
Mk4-only series: Stormrider Boost Module Mk4, Rattler Boost Module Mk4,
Albatross Wing Module Mk4, Collapsible Dew Reaper Mk4). These are
**different schematics** from their lower-Mk counterparts, not extra
sources for the same entry. One entry — Spice-infused Copper Dust —
genuinely overlaps with Jabal Eifrit Al-gharb and gains two Shield Wall
sources on the existing row.

### Cross-source schematics

Vermillius Gap West and East share **15 schematics** — same name, two drop
sites:

- `Old Sparky Mk2`, `Hajra Literjon Mk2`, `Scipio's Bloodbag`, `The Emperor's Wings Mk2` (Table of the Gods ↔ Mirzabah's Head)
- `Oathbreaker` ×5 (Coils of the Wyrm ↔ Suk Alusus)
- `Pseudo-Pulse-Sword`, `Mendia's` ×5 (Miner's Watch ↔ Imperial Testing Station No. 10)

Hagga Rift overlaps with Vermillius Gap East on **1 schematic**:

- `Buoyant Reaper Mk3` (Mirzabah's Head ↔ Stepstone Cavern). Jabal Eifrit
  adds **three more sources** for the same entry (Runaway Camp + Hand of
  Khidr in Al-Janub, plus the Farhold observation point in Al-sharq) —
  it's now the most widely-shared schematic in the catalog at 5 sources.

Jabal Eifrit shares **18 schematic names** with previously-catalogued
regions. Highlights:

- Karak ×5, Way of the Lost Maula Pistol, Zaal's Companion Assault Rifle
  drop at **all three "Wreck" sites** — Wreck of Kytheria (Hagga Rift),
  Piter's Net (Al-gharb), Wreck of the Tisiphone (Al-sharq).
- Ripper Scattergun adds Wreck of the Tisiphone — note that Al-gharb's
  *Ripper Searing Shiv* is a different weapon.
- Callie's Breaker, Old Sparky Mk3, Seb's Kisser, Shock-sword each drop
  at **five sites** across Hagga Rift + all three Jabal Eifrit
  sub-regions.
- Inkvine ×5 and Handheld Life Scanner Mk3 add Khidr's Shadow (Al-Janub).
- Hajra Literjon Mk3, Shock Gauntlets, Skin-Lined Jacket, Ta'lab Softstep
  Boots, The Emperor's Wings Mk3 each go from 1 source to 4 (Hagga Rift
  Stepstone + Al-Janub Runaway Camp + Hand of Khidr + Al-sharq Farhold).
- Glutton's Bloodbag — 6 sources total (3 in Hagga Rift + 2 in Al-Janub
  + 1 in Al-sharq), tied with Buoyant Reaper Mk3 for catalog breadth.

Shield Wall is mostly Mk4 (a fresh tier separate from the Mk1-Mk3 chain
that earlier regions cover). Its biggest cross-sub-region pools are:

- **Spice-infused Aluminum Dust** — 6 sources spanning both Shield Wall
  pools and ITS 60. Tied with Glutton's Bloodbag and Buoyant Reaper Mk3
  for the most-widely-shared schematic in the catalog.
- **Tri-source pool** — Southern Comms (E), Passage of Artemis (W),
  Sirr'asraar Vault (W) all share a 12-entry pool (Sentinel armor set
  ×5, Long Shot, Spark-Knife, The Emperor's Wings Mk4, Bigger Buggy
  Boot Mk4, Filter Extractor Mk4, Focused Buggy Cutteray Mk4, plus
  Spice-infused Aluminum Dust).
- **Sentinel City (E) / Wreck of the Alecto (W)** — Quirth's armor set
  ×5, Denira's Gift, House Disruptor Pistol, Sinner's Bloodbag, Way of
  the Fighter, plus Spice-infused Aluminum Dust.

Spice-infused Copper Dust now drops at three sites across two regions —
Jabal Eifrit Al-gharb (Eastern Jumble), Eastern Shield Wall (ITS 142),
and Western Shield Wall (ITS 60).

Within a region, several schematics drop in 2-3 sites:

- 7 schematics drop in *either* **The Spiral** *or* **Arctus Cavern**
  (Inkvine ×5, Handheld Life Scanner Mk3, Assassin's Rifle)
- 6 schematics drop in *either* the **Deserter Camp** *or* **Choam #6**
  (Callie's Breaker, Old Sparky Mk3, Seb's Kisser, Shock-sword,
  Focused Buggy Cutteray Mk3, Glutton's Bloodbag)
- `Glutton's Bloodbag` actually has **three** drop sites — Deserter Camp,
  Choam #6, *and* Stepstone Cavern.

All multi-source schematics collapse into single catalog entries with
the full sources list. Because chests are RNG (see "How chest drops
actually work" above), the multi-source list represents the **chest
pools that include this schematic** — players cycle through them
waiting for the roll they want, not visit them in sequence as
alternatives.

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

³ Drops at *either* The Spiral *or* Arctus Cavern (and at Khidr's Shadow in Jabal Eifrit Al-Janub).
⁴ Drops at *either* the Deserter Camp *or* Choam Mineral Extraction Facility No. 6 (and at one site in each Jabal Eifrit sub-region).
⁵ Glutton's Bloodbag drops at *all three* of Deserter Camp, Choam #6, and Stepstone Cavern (plus three Jabal Eifrit sites).

### Jabal Eifrit Al-gharb

| Site | Schematics |
|------|------------|
| Piter's Net | Karak's set², Ripper Searing Shiv, Spice-infused Steel Dust⁶, Way of the Lost Maula Pistol², Zaal's Companion Assault Rifle² |
| Eastern Jumble (Beneath the Jumble) | Callie's Breaker⁴, Glutton's Drinker⁷, Old Sparky Mk3⁴, Seb's Kisser⁴, Shock-sword⁴, Spice-infused Copper Dust, Spice-infused Steel Dust⁶ |

⁶ Drops at *both* Piter's Net *and* Eastern Jumble within Al-gharb.
⁷ Glutton's Drinker drops at one site in each Jabal Eifrit sub-region.

### Jabal Eifrit Al-Janub

| Site | Schematics |
|------|------------|
| Imperial Testing Station No. 76 | Callie's Breaker⁴, Glutton's Drinker⁷, Old Sparky Mk3⁴, Reaper Gloves, Seb's Kisser⁴, Shock-sword⁴ |
| Khidr's Shadow | Inkvine set³, Handheld Life Scanner Mk3³, The Tapper |
| Runaway Station Camp | Buoyant Reaper Mk3⁸, Glutton's Bloodbag⁵, Hajra Literjon Mk3⁸, Rigged Suspensor Jacket, Shock Gauntlets⁸, Skin-Lined Jacket⁸, Ta'lab Softstep Boots⁸, The Emperor's Wings Mk3⁸ |
| Hand of Khidr | Buoyant Reaper Mk3⁸, Filter Extractor Mk3, Glutton's Bloodbag⁵, Hajra Literjon Mk3⁸, Shock Gauntlets⁸, Skin-Lined Jacket⁸, Ta'lab Softstep Boots⁸, The Emperor's Wings Mk3⁸ |

⁸ Drops at *both* Al-Janub camps (Runaway Camp + Hand of Khidr) *and*
Hagga Rift Stepstone Cavern *and* Al-sharq Farhold observation point.

### Jabal Eifrit Al-sharq

| Site | Schematics |
|------|------------|
| Wreck of the Tisiphone | Karak's set², Ripper Scattergun, Way of the Lost Maula Pistol², Zaal's Companion Assault Rifle² |
| Kel's Fallback | Callie's Breaker⁴, Glutton's Drinker⁷, Old Sparky Mk3⁴, Seb's Kisser⁴, Shock-sword⁴ |
| Unnamed observation point east of Farhold | Buoyant Reaper Mk3⁸, Glutton's Bloodbag⁵, Hajra Literjon Mk3⁸, Shock Gauntlets⁸, Skin-Lined Jacket⁸, Ta'lab Softstep Boots⁸, The Emperor's Wings Mk3⁸ |

### Eastern Shield Wall

| Site | Schematics |
|------|------------|
| Southern Comms | Sentinel set (Boots, Gauntlets, Helmet, Jacket, Pants)⁹, Long Shot⁹, Spark-Knife⁹, The Emperor's Wings Mk4⁹, Bigger Buggy Boot Mk4⁹, Filter Extractor Mk4⁹, Focused Buggy Cutteray Mk4⁹, Spice-infused Aluminum Dust¹⁰ |
| Fangs of Maraqeb | Collapsible Dew Reaper Mk4, Idaho Softstep Boots, Power Gauntlets, Shadrath's Stillsuit (Boots, Garment, Gloves, Mask), Stammershot, Stormrider Boost Module Mk4 |
| Sentinel City | Denira's Gift¹¹, House Burst Drillshot, House Disruptor Pistol¹¹, Poison Mist, Quirth's set (Boots, Gauntlets, Helmet, Jacket, Pants)¹¹, Sinner's Bloodbag¹¹, Way of the Fighter¹¹, Spice-infused Aluminum Dust¹⁰ |
| Imperial Testing Station No. 142 | Abulurd's Rapture, Buoyant Reaper Mk4, Improved Reaper Gloves, Maraqeb Stillsuit (Boots, Garment, Gloves, Mask), Mohandis Sandbike Engine Mk4, Old Sparky Mk4, Rattler Boost Module Mk4, Spark-sword, Spice-infused Copper Dust¹² |

### Western Shield Wall

| Site | Schematics |
|------|------------|
| Passage of Artemis | Sentinel set + Mk4 buggy/tool pool⁹, Spice-infused Aluminum Dust¹⁰ — same 12 entries as Southern Comms |
| Sirr'asraar Vault | Same 12-entry pool as Southern Comms / Passage of Artemis⁹ |
| Wreck of the Alecto | Denira's Gift¹¹, House Disruptor Pistol¹¹, Quirth's set¹¹, Sinner's Bloodbag¹¹, Way of the Fighter¹¹, Spice-infused Aluminum Dust¹⁰ |
| Imperial Testing Station No. 60 | Albatross Wing Module Mk4, Bluddshot Buggy Engine Mk4, Compact Compactor Mk4, Eviscerator, Experimental Vulcan GAU-94, Hajra Literjon Mk4, Improved Suspensor Jacket, Miner's Blessing, Night Rider Sandbike Boost Mk4, Pipecleaner, Shadrath's Drinker, Tarl Cutteray, Spice-infused Aluminum Dust¹⁰, Spice-infused Copper Dust¹² |

⁹ The Southern Comms (E) / Passage of Artemis (W) / Sirr'asraar Vault (W) tri-source pool.
¹⁰ Spice-infused Aluminum Dust drops at **six** sites: Southern Comms, Passage of Artemis, Sirr'asraar Vault, Sentinel City, Wreck of the Alecto, *and* ITS 60.
¹¹ The Sentinel City (E) / Wreck of the Alecto (W) dual-source pool (+ Batigh Grotto in The O'odham — see below).
¹² Spice-infused Copper Dust drops at Jabal Eifrit Al-gharb (Eastern Jumble), ITS 142, *and* ITS 60.

### The O'odham

| Site | Schematics |
|------|------------|
| Stonestep Village | Mk4 tri-source pool¹³ |
| Imperial Testing Station No. 71 | Mk4 tri-source pool¹³, Compression-Stim Leggings |
| Rockwarren Village | Mk4 tri-source pool¹³ |
| Imperial Testing Station No. 163 | Buoyant Reaper Mk4¹⁴, Improved Reaper Gloves¹⁴, Maraqeb Stillsuit (Boots, Garment, Gloves, Mask)¹⁴, Mohandis Sandbike Engine Mk4¹⁴, Rattler Boost Module Mk4¹⁴, Spark-sword¹⁴, Firestorm, Ironwatch Special |
| Batigh Grotto | Denira's Gift¹¹, House Disruptor Pistol¹¹, Poison Mist¹⁵, Quirth's set¹¹, Sinner's Bloodbag¹¹, Way of the Fighter¹¹ |

¹³ The O'odham tri-source pool (Stonestep / ITS 71 / Rockwarren) shares
its 10-entry pool with Western Shield Wall / ITS 60: Bluddshot Buggy
Engine Mk4, Compact Compactor Mk4, Eviscerator, Hajra Literjon Mk4,
Improved Suspensor Jacket, Miner's Blessing, Night Rider Sandbike Boost
Mk4, Pipecleaner, Shadrath's Drinker, **Tarl Cutteray** (see Pending
corrections re: Sheol).

¹⁴ Also drops at Eastern Shield Wall / ITS 142.

¹⁵ Poison Mist is otherwise Sentinel City-only — Batigh Grotto adds a
second source.

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
- **Pentashields with coloured ID bands.** Recurring in Jabal Eifrit:
  Piter's Net (Al-gharb) uses a **green** band from the NE building to
  unlock a NW pentashield. Khidr's Shadow (Al-Janub) uses a **purple**
  band pulled from the helipad building. Arctus Cavern (Hagga Rift) is
  also red-band / green-shield gated.
- **Poison traps.** Wreck of the Tisiphone (Al-sharq) has multiple
  poison traps in the chest room — deactivate before looting.
- **Multi-band gating.** Wreck of the Tisiphone needs **two** sequential
  ID bands — one from outside wreckage, then a second to reach the
  smaller split section.
- **Vertical climbs to the top.** Hand of Khidr (Al-Janub) is another
  Ornithopter-or-grapple climb; the chest sits next to a corpse at the
  summit. Same pattern as Mirzabah's Head and Table of the Gods.
- **Twin chests at one site.** The Unnamed observation point east of
  Farhold (Al-sharq) has *two* chests but they share the same drop pool —
  no extra schematics, just an additional chance per visit.
- **Granite blockage / Cutteray cut-throughs.** Sirr'asraar Vault (W
  Shield Wall) hides its chest behind a granite deposit — scan the
  rocks and cut through with a Cutteray. Same trick as the
  scan-and-cut sealed door at Wreck of Kytheria (Hagga Rift).
- **Moisture-seal break-throughs.** Batigh Grotto (The O'odham) hides
  its chest behind a moisture seal in a corner — break through it
  after clearing the cave to reach a hidden room. Similar pattern to
  Micro-sandwich Fabric seals seen in earlier regions.
- **Layered Pentashield gating in Shield Wall.** Passage of Artemis
  (W) and Sentinel City (E) both use the now-familiar ID-band →
  pentashield gate; Wreck of the Alecto (W) requires retrieving the
  ID band deep in the wreck and walking it back to the entrance
  pentashield.
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

## Pending corrections (resolve when Sheol is added)

Known-stale data carried over from IGN's published guides. Don't touch
the catalog rows yet — wait until Sheol is being added so the move can
land in a single, consistent commit.

- **Tarl Cutteray** is currently catalogued at Western Shield Wall /
  Imperial Testing Station No. 60 (per IGN's Shield Wall guide) **and**
  at The O'odham / Stonestep Village + ITS 71 + Rockwarren Village (per
  IGN's O'odham guide). User has separately reported it as **moved to
  Sheol** in-game. Three possibilities to resolve when Sheol is added:
  1. Both IGN guides are stale and Tarl Cutteray is now Sheol-only.
  2. Tarl Cutteray genuinely drops in all four regions (Shield Wall +
     O'odham + Sheol).
  3. One of the IGN guides is fresh and the other is stale.
  Something was probably swapped into ITS 60 (and possibly the O'odham
  tri-pool) in its place; need to identify those exchanges when
  reviewing the Sheol guide.
- General rule when adding Sheol: cross-check every Shield Wall and
  O'odham entry against the Sheol guide for swaps, not just adds.
  Recent IGN guide pages may still show the pre-move state.

## Backlog

### Per-site tips/notes

Promote the gotchas above to per-source `BlueprintSource.tip`
(currently those details live only in this doc).

### Respawn-timer auto-enable (settings toggle)

**Don't blanket-prefill** — many players track collection status
without farming, and an always-running timer would clutter the UI for
them. Make it an opt-in setting.

- **Setting:** "Auto-start respawn timer when I unlock a schematic"
  (default OFF).
- **Storage:** SharedPreferences key `blueprint_auto_respawn_timer`,
  bool.
- **Surface:** Settings screen, under a Blueprints / Schematics
  section.
- **Where it applies:** `BlueprintEditor.toggleUnlocked` (or
  `_toggleChecklistRow` in the screen) — when a row transitions to
  unlocked, read the pref and set `respawnTimerEnabled: true` if on.
  When it's off, leave `respawnTimerEnabled` alone so the per-row
  manual toggle still works.
- **Effort:** ~1 hour. No schema change; just a pref, a settings
  switch, and a conditional in the unlock path.

### Per-pool progress UI

The current tracker is schematic-centric ("X / N schematics collected
across all regions"). Because chests are RNG pools (see top of doc),
the farming-oriented workflow is **site-centric**: "I'm at Imperial
Testing Station No. 10 — which of its 10 pool members do I still
need?"

**Design:**

- Add a **"View by: Schematic | Site"** segmented control to the
  tracker header (alongside the region filter chips).
- In **Site** mode, group entries by `(region, location)` instead of
  flat:
  - One Card per site, header showing `<site name>` + `<region>` +
    `<X / N collected>` chip.
  - Body: the list of pool members (schematics that include this
    site as a source) with the existing checkbox/rank UI.
  - Optional: an aggregate **respawn countdown** per site showing the
    earliest cooldown across that site's unlocked-with-timer rows.
- In **Schematic** mode, keep the current layout unchanged.
- Region filter still applies in both modes — Site mode filters which
  sites' cards are shown.
- Persist the view preference per character alongside the region
  filter (same `_regionFilterByCharacter` pattern, new SharedPreferences
  key).

**Data needs:** Nothing in the persistence layer changes. The pool
inversion is a one-pass groupBy over `blueprintCatalog`:

```dart
final pools = <(String, String), List<BlueprintCatalogEntry>>{};
for (final entry in blueprintCatalog) {
  for (final source in entry.sources) {
    pools.putIfAbsent(
      (source.region, source.location), () => [],
    ).add(entry);
  }
}
```

**Effort:** ~3-4 hours. Mostly UI — toggle, pool index, Card layout
that re-uses the existing per-row widgets.

**When:** Defer until **all regions are catalogued**. The per-pool
view's payoff scales with the number of pools, and a mid-build
implementation would compete with data work. Once Hagga Basin
North/East/West and Deep Desert are in, this becomes the more
ergonomic default for farming-oriented players.
- **Hagga Basin North / East / West** — IGN guides exist; same pattern
  applies.
- **Deep Desert** — schematics there are dynamic / event-driven, so they
  may need a separate model (not chest-locked).
- **Cross-character schematic unlocks** — if Funcom confirms unique
  schematics are per-account rather than per-character, the persistence
  layer needs to denormalise `is_unlocked` out of the per-character row.
