# Base Calculator Research & Assessment

Status: **Phase 4 implemented.** (assessment complete and audited, revision 2)

This document assesses a local-first **Base Calculator** feature for the Dune
Awakening Companion App. It uses the TCNO calculator shared by the user as the
primary reference and cross-checks against other public calculator/tool pages and
the current app architecture.

Reference URL:
`https://tools.tcno.co/dune?config=czpXOjEsRlBHOjIsTUNSOjE%3D`

Decoded reference config: `s:W:1,FPG:2,MCR:1`

Interpretation: a compact, shareable selection string using short item codes and
counts. This should influence future share/export design, but the first local
implementation should keep its data model explicit and versioned.

---

## External Calculator Findings

The TCNO calculator is a browser-local Dune base-cost planner with categories
for **Utilities**, **Fabricators**, **Refineries**, **Storage**, **Buildings**,
and **Vehicles**; it calculates upfront base costs and is positioned as
especially useful for Deep Desert planning
([TCNO Dune Base Calculator](https://tools.tcno.co/dune)).

The TCNO visible item set includes utilities such as Sub-Fief Console,
Advanced Sub-Fief Console, Fuel-Powered Generator, Wind Turbine Omnidirectional,
Wind Turbine Directional, Spice-Powered Generator, Repair Station, Recycler,
Windtrap, Large Windtrap, and Pentashield Surface variants, with power deltas
and resource requirements per item
([TCNO Dune Base Calculator](https://tools.tcno.co/dune)).

The alternate DuneCalc tool exposes a similar feature shape: storage
configuration, power summary, resource requirements, volume requirements, Deep
Desert 50% resource reduction mode, and trip calculations based on the selected
storage capacity
([Dune Awakening Base Calculator](https://dunecalc.com/base-calculator.html)).

DuneCalc's storage configuration lists inventory/storage volumes and slots for
player inventory, ornithopter storage, sandbike inventory, buggy storage,
sandcrawler centrifuge, Regis spice container, and bigger buggy boot variants
([Dune Awakening Base Calculator](https://dunecalc.com/base-calculator.html)).

The Steam guide for TCNO describes the website as supporting power/resource
calculation, export/import via plain JSON, shareability over Discord, and
browser persistence via LocalStorage
([Steam Community: The Base Cost Calculator](https://steamcommunity.com/sharedfiles/filedetails/?id=3509428130)).

DaOpa's power calculator is narrower than TCNO/DuneCalc but validates a related
user need: calculating generator build/running costs over a time period,
including refinery selections, windtrap bonuses, target-power optimization, and
exported results
([Dune Awakening Power Calculator](https://gamingwithdaopa.ellatha.com/duneawakening/power-calculator/)).

Funcom's official building article frames bases as both expression and
progression infrastructure: players claim land, build piece-by-piece, choose an
architectural style, develop crafting capability, and store gear/resources
([Building in Dune: Awakening](https://duneawakening.com/news/building-in-dune-awakening-claim-your-piece-of-arrakis)).

---

## Current App Fit

The current app's `Base` feature is a **power-decay countdown tracker**, not a
building/resource planner. The model stores `characterId`, `name`,
`powerExpirationTime`, notification toggles, and warning/critical threshold
overrides in `lib/features/bases/models/base.dart`.

There is no existing resource inventory, storage volume, building catalog,
power-budget model, or resource-cost calculator in the `bases` feature. The
closest local patterns are the static catalog architecture used by Blueprints and
Skills, plus Riverpod repository-backed feature modules.

`NEXT_STEPS.md` already contains adjacent ideas: **Resource Tracker**,
**Crafting & Building Tracker**, **Material requirements calculator**,
**Building cost estimator**, **Base Templates**, and **Power Cost Calculator**.
This research consolidates those ideas into one scoped feature proposal.

---

## Product Recommendation

Add Base Calculator as a **new feature module**, not as extra fields on the
existing `Base` model.

Recommended module: `lib/features/base_calculator/`

Rationale:

- The existing `Base` model answers "when does this base lose power?"
- A Base Calculator answers "what do I need to build this plan, does it have
  enough power, and how many storage trips will it take?"
- Persisting calculator selections directly on `Base` would force migration
  churn, backup compatibility concerns, and a confusing UX boundary.
- A separate module can later link a saved calculator plan to a tracked base via
  optional `baseId` or `characterId` without bloating the countdown tracker.

---

## Proposed Feature Scope

### Phase 1: Local Planner MVP — IMPLEMENTED

Shipped in `lib/features/base_calculator/`:

- `models/base_calculator_item.dart` — item + category model.
- `models/base_calculator_catalog.dart` — static, sourced catalog (Utilities +
  Fabricators only; other categories deferred per Audit Findings).
- `models/base_calculator_summary.dart` — pure power/material math with the
  Deep Desert discount (materials only, rounded up).
- `providers/base_calculator_provider.dart` — in-memory `StateNotifier` (no
  persistence yet — that is Phase 3).
- `screens/base_calculator_screen.dart` — adaptive two-pane (desktop) /
  stacked (mobile) UI with quantity steppers, a live summary, a power
  deficit/surplus banner, and a "verify in-game" disclaimer.
- Wired into main navigation (rail + bottom nav) with localized labels across
  all 7 locales.
- Tests: `test/unit/base_calculator/` (math + catalog structure) and
  `test/widget/base_calculator_screen_test.dart`.

Original goal: useful calculator without persistence or build-sharing
complexity.

- Static item catalog with categories, item names, power deltas, resource costs,
  and optional item codes.
- Quantity steppers per item.
- Build summary:
  - total generated power
  - total used power
  - net power
  - "needs more power" warning when net power is negative
  - resource totals
- Deep Desert toggle:
  - applies 50% material reduction to resource totals **only** (power is
    unaffected — see Audit Findings)
  - label clearly explains this is for Deep Desert build planning
- Reset all.
- Unit tests for power/resource math.
- Widget test for selecting items and seeing resource totals.

### Phase 2: Storage & Trip Planning — IMPLEMENTED

Shipped:

- `models/resource_volumes.dart` — sourced per-unit material volumes (DuneCalc
  Materials tab) used to convert material totals into transport volume. A
  coverage test asserts every catalog resource has a volume.
- `models/storage_option.dart` + `models/storage_catalog.dart` — 15 storage
  containers (player inventory, sandbikes, ornithopters, buggies, sandcrawler,
  Regis container) with volume + slot capacity.
- `models/storage_summary.dart` — pure capacity aggregation plus a `tripsNeeded`
  helper (`ceil(volume / capacity)`; `null` when no storage configured).
- `BaseCalculatorSummary.totalVolume` — transport volume derived from the
  discounted material totals (Deep Desert halves volume too, since you haul
  less).
- Provider extended with storage quantities and a derived `trips`.
- Screen: a "Storage & Transport" catalog section, a transport block in the
  summary (total volume, storage capacity, trips), and a "Show volumes" toggle
  that reveals per-material volume.
- New unit tests (`storage_and_volume_test.dart`) and a widget test for the
  trip flow.

Notes / deferred refinements:

- Trips are **volume-based**. Slot capacity is shown but does not yet bind the
  trip count; per-stack slot limits are a future refinement (Audit Findings).

Original goal: match the most useful differentiator in TCNO/DuneCalc.

### Phase 3: Saved Plans — IMPLEMENTED

Shipped:

- Migration 016 (`base_calculator_plans` table).
- `BaseCalculatorPlan` model + `BaseCalculatorPlanRepository`.
- Saved-plan sheet (load, duplicate, delete) and save/update dialog with optional
  character/base links.
- ZIP export/import includes `baseCalculatorPlans`.
- Tests: migration smoke + model encode/decode.

### Phase 4: Shareable Configs — IMPLEMENTED

Shipped:

- `BaseCalculatorPortablePlan` JSON format (`dune-base-calculator-plan` v1).
- `BaseCalculatorShareCodec` compact string (`dac-v1;dd;i:code=qty;s:code=qty;n:name`).
- Per-plan and live-build actions: copy share code, export/import JSON, paste
  share code (share menu on calculator + saved-plan sheet).
- Unknown catalog codes are ignored on import; TCNO codes are **not** supported.

Deferred: URL/deep-link config parameters.

### Phase 5: Optimization Helpers

Goal: higher-value planning once the basic catalog is trusted.

- "How much power do I need?" helper.
- Generator recommendations for a target net power.
- Running cost estimator for fuel/spice generators if reliable data is sourced.
  Note: fuel burns at a constant rate per **running generator**, independent of
  consumer load (see Audit Findings), so this must be modeled over time, not
  from net power.
- Presets/templates for common starter, Deep Desert, refinery, and guild builds.

---

## Data Model Sketch

Use explicit, versioned local models even if the UI later supports compact share
codes.

```dart
class BaseCalculatorItem {
  final String id;
  final String code;
  final String name;
  final String category;
  final int powerDelta;
  final Map<String, int> resourceCosts;
  final int? volume;
}

class BaseCalculatorSelection {
  final String itemId;
  final int quantity;
}

class StorageOption {
  final String id;
  final String name;
  final int volumeCapacity;
  final int? slotCapacity;
}

class BaseCalculatorPlan {
  final String id;
  final String? characterId;
  final String? baseId;
  final String name;
  final bool deepDesertDiscountEnabled;
  final List<BaseCalculatorSelection> selections;
  final List<BaseCalculatorSelection> storageSelections;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

Catalogs should be static Dart data under
`lib/features/base_calculator/models/catalogs/`, mirroring the blueprint catalog
pattern.

---

## UX Placement

Recommended first placement: a new **Calculator** or **Base Calculator** screen
in main navigation.

Alternatives:

- Place it under **Blueprints**: related to crafting/build planning, but likely
  too large to bury there.
- Place it inside each character's Base dialog: useful for linking plans to
  bases, but too cramped for Phase 1 and risks mixing "power expiration" with
  "build planning."
- Place it under Settings/Data tools: too hidden for a feature users will revisit.

The screen should be responsive like existing desktop/mobile navigation and use
card/list patterns from Blueprint Tracker rather than dense data grids.

---

## Data Sourcing & Maintenance Risks

This feature is only as good as its catalog.

Risks:

- Public tools can be wrong, stale, or differently patched by region/version.
- External websites may not license their data for direct copying.
- Game patches may alter build costs, power values, storage capacity, or Deep
  Desert rules.
- Catalog size will grow over time and will need tests like the blueprint catalog
  structure tests.

Mitigations:

- Mark the catalog source and date in code comments and docs.
- Keep item costs in a single static catalog, not scattered through UI.
- Add structural tests: unique item IDs/codes, non-negative quantities, non-empty
  costs unless intentionally free/decorative, and category coverage.
- Add a "verify in-game" note in the UI until the catalog is audited.
- Prefer user-editable custom items later instead of overfitting the first static
  catalog.

---

## Implementation Assessment

Recommended effort:

- Phase 1: medium (static catalog + calculator screen + math tests).
- Phase 2: medium (storage/trip planner).
- Phase 3: medium-high (migration, repository, export/import, saved-plan UI).
- Phase 4: medium (versioned share/import format).
- Phase 5: high (optimization, fuel/running cost correctness).

Recommended starting point:

1. Build Phase 1 with a small audited catalog slice (Utilities + power items).
2. Add catalog tests before expanding to all categories.
3. Add Phase 2 storage after power/resource totals feel correct.
4. Only persist plans after users confirm the planner UI is worth saving.

---

## Audit Findings (revision 2)

This section records a self-audit of the assessment above against the source
data and the codebase.

### Verified

- **Codebase claims are accurate.** `lib/features/bases/models/base.dart` is a
  power-decay tracker only; a repo-wide search found no resource, volume,
  storage, building-catalog, or power-budget model in `lib/`. A new
  `lib/features/base_calculator/` module is the correct placement.
- **Per-item power values are internally consistent.** The shared config
  `s:W:1,FPG:2,MCR:1` reconciles with the in-game screenshot summary
  (Generation 150, Used 425, deficit 275):
  - Fuel-Powered Generator x2 = `+150`
  - Windtrap x1 = `-75`
  - Medium Spice Refinery x1 = `-350`
  - Net = `150 - 425 = -275` ("you need 275 more power")
  This validates that generators are positive power and that windtraps and
  crafting/refining stations are power **consumers** in this model
  ([Dune Awakening Base Calculator](https://dunecalc.com/base-calculator.html)).
- **Deep Desert 50% is materials-only.** Confirmed that the Deep Desert reduces
  building **material** cost by 50%; power values are unaffected
  ([Dune Awakening Base Calculator](https://dunecalc.com/base-calculator.html),
  [Steam Community: The Base Cost Calculator](https://steamcommunity.com/sharedfiles/filedetails/?id=3509428130)).
  The Phase 1 Deep Desert toggle must apply the discount to resource totals
  only, never to the power summary.

### Corrected / clarified

- **Net power is capacity headroom, not fuel burn.** A fueled generator consumes
  fuel at a constant rate whether or not its power output is used; turning off
  consumers does not save fuel
  ([Base Power Consumption — Steam Discussion](https://steamcommunity.com/app/1172710/discussions/0/596286707636134249/)).
  Therefore the Phase 1 "net power" figure answers "do my generators cover the
  placed consumers?", and any Phase 5 running-cost estimate must be driven by
  **running generators over time**, not by consumer load. Do not present net
  power as a fuel-consumption number.
- **Power vs water.** Windtraps are a water mechanic in-game, but in these
  calculators they appear purely as a power **cost** line. The calculator models
  a single power budget and does not model water; the UI copy should not imply
  windtraps generate power.

### Open data gaps (resolve during implementation, not now)

- **Buildings and Vehicles costs are not yet captured.** TCNO exposes
  "Buildings" and "Vehicles" tabs (visible in the shared screenshot), but the
  client-rendered rows for those tabs were not retrievable via extraction, and
  DuneCalc does not expose those categories at all. Their per-item power/material
  costs must be sourced and verified in-game before shipping those tabs. Phase 1
  should ship Utilities + power items (which are fully captured and validated)
  and treat Buildings/Vehicles as later additions.
- **Storage/trip formula is an assumption.** Both tools compute "trips" from
  total resource volume vs configured storage capacity; the exact rounding
  (`ceil(totalVolume / totalCapacity)`) and whether slot limits also bind should
  be confirmed against in-game behavior during Phase 2. DuneCalc lists both
  `Volume` and `Slots` per container, so `StorageOption` should keep both.
- **Item codes are tool-specific.** `W`, `FPG`, `MCR` are TCNO's codes. Our
  catalog should own its own stable codes and not assume TCNO compatibility
  unless we explicitly implement their import format (Phase 4).

### Assessment-artifact note

The companion canvas
(`canvases/base-calculator-assessment.canvas.tsx`) was rebuilt this revision to
fix SDK violations (numeric `gap`, valid `Stat`/`Pill` tones, `Text size`
values, `CardHeader` children instead of a non-existent `title` prop, and a
valid theme token).

---

## Sources

- [TCNO Dune Base Calculator](https://tools.tcno.co/dune)
- [Dune Awakening Base Calculator](https://dunecalc.com/base-calculator.html)
- [Dune Awakening Power Calculator](https://gamingwithdaopa.ellatha.com/duneawakening/power-calculator/)
- [Building in Dune: Awakening](https://duneawakening.com/news/building-in-dune-awakening-claim-your-piece-of-arrakis)
- [Steam Community: The Base Cost Calculator](https://steamcommunity.com/sharedfiles/filedetails/?id=3509428130)

Search artifact: `dune-base-calculator-research.json`
