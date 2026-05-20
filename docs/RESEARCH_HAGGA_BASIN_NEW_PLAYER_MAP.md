# Research: Hagga Basin New-Player Guide & Interactive Map

**Status:** Research, analysis, and assessment — *not* a committed implementation spec.  
**Last updated:** 2026-03-19  

## Why this document

Community appetite for “more than manual quest tracking” is real: the **in-game quest journal is thin** for some loops (notably **class / specialization-adjacent quests**), and **new players** get rushed through early beats. Feedback points to **Hagga Basin South** and the wider **Hagga** / **Rift** onboarding band: people **miss schematics**, **miss the planetologist** thread, and leave the starter arc with gaps they only discover later.

This project angle is **onboarding and spatial clarity**, not replacing the companion’s existing manual quest notebook.

**Related (existing app today):** `lib/features/quest_journal/` — structured manual quests/steps.  
**Related (future narrative layer):** `NEXT_STEPS.md` §7 *RPG Elements & Storytelling* (Adventure Journal / chronicles — separate from map POIs).

---

## Problem framing

| Stakeholder | Pain |
|-------------|------|
| **New player** | High cognitive load; VO and UI push forward; easy to skip optional but important beats (schematics, NPCs, threads). |
| **Returning / alt** | May still want a single “did I do X in Hagga?” reference without wiki tab disco. |
| **Companion positioning** | A **manual-only** quest list does not match expectations set by games with richer journals; **guided regional maps** are a different value proposition. |

**Hypothesis (to validate):** An **interactive regional map** with **toggleable concern layers** (e.g. schematics, key NPCs, named quest threads), **sub-grouped by sub-region** (e.g. Hagga Basin South, Rift, …), reduces “I missed the planetologist” class feedback and supports class-quest confusion — *if* content is accurate, maintainable, and legally/safely sourced.

---

## Proposed product direction (high level)

1. **Interactive Hagga Basin map** (zoom/pan, usable on phone and desktop).
2. **Layer / filter toggles** — “show schematic pickups”, “show planetologist-relevant pins”, “class-quest breadcrumbs”, etc. (exact list TBD by research).
3. **Sub-categories / chapters** aligned to **player mental geography** (e.g. Hagga Basin South, Rift, … — names and boundaries must match community + in-game usage).
4. **New-player first**: default experience favors “don’t miss the basics” rather than 100% completionist checklists.

This is a **substantial undertaking**: content accuracy, update cadence with patches, UX, performance, and asset/map licensing are all non-trivial.

---

## Research & analysis workstreams

### A. Game and community verification

- [ ] Confirm **official / semi-official** naming for sub-areas (Hagga Basin South vs patch renames).
- [ ] Build a **source hierarchy**: in-game verification > official maps/patch notes > vetted community (with date and version).
- [ ] **Class / specialization quests**: list what’s *actually* trackable in-game vs what must be *guide* content only.
- [ ] **Planetologist** and **schematic** flows: step-by-step “what players miss” from support/reddit/wiki (document links, not copy-paste of third-party guides without permission).
- [ ] **Patch volatility:** Chapter/patch cadence — how often does the companion need a content pass?

### B. UX / information architecture

- [ ] **Map vs list:** when is map primary vs supplementary checklist?
- [ ] **Progress model:** per-character checkoffs vs account-wide vs “seen only” — privacy and multi-character alts.
- [ ] **Spoilers:** toggles for story-sensitive pins?
- [ ] **Accessibility:** zoom, contrast, screen reader labels for pins (WCAG-minded).

### C. Content authoring & maintenance

- [ ] **Who authors POIs?** (core maintainer vs community PRs vs both, with review).
- [ ] **Data format:** JSON/GeoJSON-style regions vs raster hotspots — impacts tooling.
- [ ] **Versioning:** `contentVersion` tied to game patch; in-app “last verified for patch X.Y”.

### D. Legal, ethical, and platform

- [ ] **Map / imagery:** cannot assume reuse of game textures/minimaps without explicit rights; likely **original diagrammatic map** or **licensed** base (research Funcom’s fan guidelines / ToS).
- [ ] **Trademark** copy: “Dune Awakening” attribution already in app; avoid implying official endorsement.
- [ ] **Store policies:** no cheating, no datamined client extraction if that violates ToS (preference: observable + public patch notes).

### E. Technical assessment (Flutter companion)

- [ ] **Map stack:** e.g. `flutter_map` + tiles vs custom `CustomPainter` over static art; offline bundle size.
- [ ] **Coordinate system:** if using a reference image, define normalized coordinates (0–1) vs pixel space for hit-testing pins.
- [ ] **i18n:** pin titles/descriptions in ARB vs keyed content files.
- [ ] **Integration:** optional deep link from a **quest** or **chronicle** entry → map region (later).

**Deliverable from this stream:** a short **technical spike** (prototype with dummy pins + one sub-region) — time-boxed, after A/B are clearer.

---

## Risks & open questions

- **Accuracy debt:** wrong pin erodes trust faster than no feature.
- **Scope creep:** “full world” before Hagga is validated.
- **Duplicate effort:** wikis and video guides exist — companion must offer **offline, structured, patch-aware** value.
- **Class quest data:** may never be fully API-like; product may stay **guide-layer** not **sync-layer**.

---

## Suggested phases (for planning only)

1. **Discovery (this doc + research notes)** — sources, persona journeys, competitive scan.
2. **Content spec (Hagga-only)** — definitive sub-region list, POI taxonomy, “must not miss” vs optional.
3. **Design prototype** — Figma or in-app wireframe; toggle + section IA.
4. **Legal/content sourcing decision** — what base map art is allowed.
5. **MVP scope lock** — e.g. Hagga Basin South + one adjacent band, N POI types, no class automation.
6. **Engineering spike** — map widget + data-driven pins + one toggle group.
7. **Beta / community review** — accuracy pass before marketing.

---

## Next steps

1. Keep this file as the **single index** for Hagga/new-player map research; add meeting notes or link out to `wiki/` as needed.
2. When research matures, add a **one-page executive summary** (problem, scope, recommendation, “go/no-go”) at the top.
3. ~~Optional: add a bullet under `docs/ROADMAP_2026.md`~~ — **Done** (long-term product points here).

---

## Internet research: methodology & verification

**Can AI/assistant web research be “verified”?** Only with **clear limits**:

| Tier | Examples | Use in companion POIs |
|------|----------|------------------------|
| **1 — First-party** | `duneawakening.com` news, official patch notes, Funcom-sourced media | **Preferred** for mechanics, zone names if stated |
| **2 — Official-adjacent** | Cited primary video/dev stream only when transcript/primary link is known | Supporting only |
| **3 — Professional guides** | Large outlets (e.g. IGN wikis), specialist guide sites | **Hypotheses** — must cross-check in-game |
| **4 — Community wiki** | e.g. `awakening.wiki` | Good for **bibliography & leads**; wiki ≠ proof |
| **5 — Social / forums** | Reddit, Discord quotes | **Signal only** (“players report…”) |

**Assistant tooling:** Web search + URL fetch (like any researcher using a browser). **Not a substitute for:** in-game verification, datamine ethics review, or legal clearance on map assets.

**Rule for this project:** No companion POI ships as “confirmed” until **Tier 1/Tier 2** or **recorded in-game check** on a named patch/build.

### Snapshot — 2026-03-19 (exploratory; not POI-ready)

Purpose: show *how* we’d log research—not to lock coordinates or content.

1. **Community wiki (fetched 2026-03-19):** [Hagga Basin — Dune: Awakening Community Wiki](https://awakening.wiki/Hagga_Basin)  
   - **Claims (summary):** Hagga Basin is the **starting survival** overland-style area; mostly **PvE**, **some PvP** (e.g. crashed ship sites); **~64 km²**; multiple basin instances; cites among refs a Funcom page: [What makes Dune Awakening an MMO](https://duneawakening.com/en/what-makes-dune-awakening-an-mmo).  
   - **Verification note:** Wiki is **Tier 4**; useful index; corroborate each claim against Tier 1 or in-game.

2. **Web search hits (not fetched line-by-line here):** Third-party articles and guide hubs discuss **Hagga Basin South**, **Planetologist** / **Derek Chinara**, **Minimic Film Recovery**, **Imperial Testing Station No. 2**, schematic-related onboarding pain—consistent with *player-reported* confusion.  
   - **Verification note:** Treat as **Tier 3–5** until each step is re-walked in the current client; patch renames and bug reports (e.g. NPC positioning) are common failure modes.

3. **Ecosystem note:** Independent **interactive map** sites exist for the game (search: “Dune Awakening interactive map Hagga”). Any companion feature must assume **competition** and focus on **integration, versioning, trust, and offline**—not duplicating uncertain tiles.

**Action:** Replace this snapshot with a **living bibliography table** (URL, date accessed, tier, claim used, in-game verified Y/N, game build).

---

## References (seed list — expand during research)

- Funcom / Dune Awakening news and patch notes (primary for mechanical changes).
- In-game verification runs (record build version).
- Community signal (reddit, discord summaries) — **triangulate**, do not treat as sole source.
