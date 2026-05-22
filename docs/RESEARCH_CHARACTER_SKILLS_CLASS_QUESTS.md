# Character Skills and Class Quests Research

Last updated: 2026-05-22

This document tracks **in-game progression systems**, what the companion app implements today, and what remains planned.

---

## Two Different “Level” Systems

Dune Awakening has two progression layers that are easy to conflate:

| System | In-game meaning | App tab | App status |
|--------|-----------------|---------|------------|
| **Specializations** (Chapter 3) | Five Landsraad tracks: Combat, Crafting, Gathering, Exploration, Sabotage — 0–100 each, **500 total** | **Specializations** | **Shipped** — manual sliders per character |
| **Class quests** | Trainer unlock chains (basic + advanced) that gate each class tree | **Class Quests** | **Shipped** — step checklists for 5 classes |
| **Class skills** | Five class paths (Bene Gesserit, Mentat, Planetologist, Swordmaster, Trooper), each with **3 skill trees**, **108 skills**, **200 skill point** cap | **Skill Planner** | **Shipped** — per-character rank/target/equipped tracking against a canonical catalog |

Class Quests and Skill Planner are now separate tabs in Character Progress. The Skill Planner does not yet derive unlock state from quest completion or enforce point-budget prerequisites — see *Product Direction* below.

---

## In-Game Class Skill Model (Reference)

- Five class paths; each class has three skill trees → **15 trees total** [Game8](https://game8.co/games/Dune-Awakening/archives/524020).
- Skills include abilities, passives, and techniques; actives must be equipped on the ability bar [Fextralife](https://duneawakening.wiki.fextralife.com/Skill+Trees).
- Players unlock secondary classes by finding trainers. **Basic** trainer quests unlock a class tree; **advanced** chains unlock deeper progression [Method](https://www.method.gg/dune-awakening/dune-awakening-all-trainer-locations-how-to-unlock-each-secondary-class-fast).

### Starting class rule

The character generator supports **Bene Gesserit, Mentat, Swordmaster, and Trooper** as starting classes. **Planetologist is secondary-only** [Game8](https://game8.co/games/Dune-Awakening/archives/524020).

If a character starts as a class, that class should not require its basic unlock quest. Trooper and Swordmaster guides state starting as that class skips the basic quest [Trooper](https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening), [Swordmaster](https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening). Mentat uses the same conditional framing [Mentat](https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening).

---

## What the App Implements Today (v1.3.0-beta)

### Specializations — shipped

- **UI:** Characters → Progress → **Specializations** tab.
- **Data:** One row per character in `character_specializations` (migration 006).
- **Fields:** `combat_level`, `crafting_level`, `gathering_level`, `exploration_level`, `sabotage_level` (each 0–100); computed total `/ 500`.
- **UX:** Manual sliders; user saves when values match in-game.
- **Backup:** Included in ZIP export/import.

**Not implemented:** auto-sync, XP sources, Landsraad contract linkage, trait unlock hints.

### Class quests — first slice shipped

- **UI:** Characters → Progress → **Class Quests** tab.
- **Data:** `character_class_quests`, `character_class_quest_steps` (migration 011); `characters.primary_class` for starting class.
- **Catalog:** Static seed in `lib/features/class_quests/models/class_quest_catalog.dart` — **10 entries** (basic + advanced per class).
- **UX:**
  - Step checkboxes per quest.
  - Start / Complete / Reset status.
  - Starting class auto-marks that class’s **basic unlock** as “Not required”.
  - **Planetologist basic unlock is always tracked** (never a starting class).
- **Backup:** `classQuests` and `classQuestSteps` in ZIP export/import.

### Skill planner — shipped

- **UI:** Characters → Progress → **Skill Planner** tab.
- **Data:** `character_skills` (migration 012, DB v12) — `(character_id, skill_id)` unique, with `current_rank`, `target_rank`, `is_equipped`, `updated_at`.
- **Catalog:** Static seed in `lib/features/skills/models/skill_catalog.dart` — **108 skills** across 5 classes × 3 sub-trees (Bene Gesserit: Weirding Way / The Voice / Body Control; Mentat: Mental Calculus / Assassination / Tactician; Planetologist: Scientist / Explorer / Mechanic; Trooper: Gunnery / Suspensor Training / Tactical Tech; Swordmaster: The Blade / The Will / The Way). Skills typed as **active** (Ability), **passive**, or **technique**.
- **Sources:** Fextralife (skills + types), PCGamesN (sub-tree groupings).
- **UX:**
  - Class dropdown defaulting to the character’s primary class.
  - Skills grouped into per-sub-tree Cards mirroring the in-game layout.
  - Per-skill current rank and target rank (0–maxRank, default 3).
  - Equip checkbox for Abilities and Techniques (3 of each per class in-game; checkbox enforces no slot count yet).
  - Colored type badge per row (Ability / Technique / Passive).
  - Total points spent shown against a `/ 200` budget (display only — no enforcement yet).
- **Tests:** 29 unit tests — canon comparison (no hallucinations / missing skills / wrong types / wrong trees), `CharacterSkill` JSON round-trip, sqflite_common_ffi schema smoke test for migration 012.

**Not yet implemented:**

- “Tree unlocked” state derived from class-quest completion.
- Point-budget enforcement (currently a display-only counter — over-budget shown in red but not blocked).
- Equipped-slot count enforcement (3 abilities + 3 techniques in-game).
- Skill prerequisites within a tree.
- Tree-position layout matching the in-game node graph (linear list within each tree card today).

### Related progression (separate tabs)

| Tab | Purpose |
|-----|---------|
| **Factions** | Rank, contracts, reputation — not class skills |
| **Augments** | Acquired/equipped augmentations — not class skills |

---

## Seeded Class Quest Catalog

| Class | Basic unlock | Advanced chain |
|-------|--------------|----------------|
| Bene Gesserit | Sister Mesa — *The Missing Pieces* | Jocasta — advanced chain |
| Mentat | Samin Moro — *First Blood* | Arrakeen advanced trainer |
| Trooper | Ghavouri — *Proving Grounds* | Kara — advanced chain |
| Swordmaster | Arno — *Checking the Post* | Seron — advanced chain |
| Planetologist | Derek Chinara — *Minimic Film Recovery* | Full Imperial Testing Station chain (below) |

Sources per entry are linked in the catalog (`sourceUrl` on each `ClassQuestCatalogEntry`).

---

## Planetologist Questline (Corrected)

**Common misconception:** Derek Chinara does **not** relocate as a mobile trainer. He can be **hard to find**, and follow-up objectives (hidden rooms, false bookshelves, station chains) are easy to miss.

**Hub:** Hagga Basin South, above **Imperial Testing Station No. 2**. This camp is the recurring return point throughout the chain [MMOPIXEL](https://www.mmopixel.com/news/dune-awakening-planetologist-skill-guide).

### Basic unlock (app: `planetologist-basic-minimic-film`)

1. Find Derek above Imperial Testing Station No. 2.
2. Enter Station No. 2; look for a **glowing vertical yellow line** behind a bookshelf to reveal a hidden room.
3. Loot **Minimic Film** from the chest.
4. Return to Derek → unlocks **Planetologist level 1**.

### Advanced chain (app: `planetologist-advanced-route`)

Seeded steps in the catalog match this walkthrough:

| Step | Location / beat | Notes |
|------|-----------------|-------|
| 1 | **Imperial Testing Station No. 197** — Vermillius Gap | Derek at bottom of circular pit; locked-room combat gauntlet; unlocks **level 2** |
| 2 | **Adhering to Hierarchy** — Arrakeen | Bar → Ciprian in back corner; return to Derek |
| 3 | **Imperial Testing Station No. 76** — Jabal Eifrit Al-Janub | Keys in book downstairs; film behind false bookshelf; rescue Derek; **level 3** |
| 4 | **Mission to Thufir** — Arrakeen → Sietch Tabr | Speak with Thufir Hawat; crumbling ruins at edge of O'odham; return to camp |
| 5 | **Imperial Testing Station No. 29** — Hagga Rift | Purple ID band; false bookshelf; **Spice Surveyor** capstone |
| 6 | **Imperial Testing Station No. 71** — O'odham | Blue ID band; hidden bookshelf; side-chamber notes; second capstone |
| 7 | **Betrayal at Arrakeen** | Deliver report to Ciprian; defend Hagga camp from two sniper waves; loot Derek’s notes |
| 8 | **Imperial Testing Station No. 163** — final dungeon | Holographic recording; return to Derek to complete |

**Pattern:** Many stations use **false bookshelves** and **vertical yellow interaction lines** for hidden Minimic Film / data rooms.

---

## Code & Schema Reference

| Area | Path |
|------|------|
| Specialization model | `lib/features/specializations/models/character_specialization.dart` |
| Specialization UI | `lib/features/characters/screens/character_progress_dialog.dart` (`_SpecializationsTab`) |
| Class quest catalog | `lib/features/class_quests/models/class_quest_catalog.dart` |
| Class quest persistence | `lib/features/class_quests/services/class_quest_repository.dart` |
| Class quest UI | `lib/features/characters/screens/character_progress_dialog.dart` (`_ClassQuestsTab`) |
| Skill catalog | `lib/features/skills/models/skill_catalog.dart` |
| Skill model | `lib/features/skills/models/character_skill.dart` |
| Skill repository | `lib/features/skills/services/character_skill_repository.dart` |
| Skill providers | `lib/features/skills/providers/skill_provider.dart` |
| Skill planner UI | `lib/features/characters/screens/character_progress_dialog.dart` (`_SkillPlannerTab`, `_SkillTypeBadge`) |
| Starting class on character | `lib/features/characters/models/character.dart` (`primaryClass`) |
| Class constants | `lib/core/utils/constants.dart` (`primaryClasses`, `allProgressionClasses`) |
| DB migrations | `migration_006_add_progression_and_quests.dart`, `migration_011_add_class_quests.dart`, `migration_012_add_character_skills.dart` |
| Tests | `test/unit/class_quest_catalog_test.dart`, `test/integration/class_quest_flow_test.dart`, `test/unit/skills/` (catalog canon, model round-trip, migration schema) |

---

## Product Direction (Not Yet Built)

Foundation shipped (catalog + per-character ranks/equipped + planner UI). Remaining work to couple skills to the rest of the progression model:

1. **Unlock linkage** — derive “tree unlocked” from class-quest completion (today: Skill Planner shows all skills regardless of trainer-quest state).
2. **Point-budget enforcement** — the planner displays totals vs. `/ 200` but does not block over-spend.
3. **Equipped-slot enforcement** — in-game caps are 3 Abilities + 3 Techniques per class; planner allows unlimited equip toggles today.
4. **Prerequisites within a tree** — `prerequisiteSkillIds` exists on `SkillCatalogEntry` but is not yet populated or enforced.
5. **In-game tree layout** — planner currently renders each tree as a flat alphabetical list; the in-game node graph (with branching prereq edges) would be a visual upgrade.

---

## Sources

- [All Skill Trees | Dune: Awakening - Game8](https://game8.co/games/Dune-Awakening/archives/524020)
- [Skill Trees | Dune Awakening Wiki](https://duneawakening.wiki.fextralife.com/Skill+Trees)
- [All Dune Awakening Skills (per-class sub-tree groupings) - PCGamesN](https://www.pcgamesn.com/dune-awakening/skills)
- [Dune Awakening Trainer Locations - Method](https://www.method.gg/dune-awakening/dune-awakening-all-trainer-locations-how-to-unlock-each-secondary-class-fast)
- [Bene Gesserit Trainer Locations and Quests - IGN](https://www.ign.com/wikis/dune-awakening/Bene_Gesserit_Trainer_Locations_and_Quests)
- [Planetologist Trainer Locations and Quests - IGN](https://www.ign.com/wikis/dune-awakening/Planetologist_Trainer_Locations_and_Quests)
- [Planetologist Skill Guide (step-by-step) - MMOPIXEL](https://www.mmopixel.com/news/dune-awakening-planetologist-skill-guide)
- [Trooper Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening)
- [Swordmaster Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening)
- [Mentat Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening)
