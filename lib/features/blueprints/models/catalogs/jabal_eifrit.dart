import '../blueprint_catalog.dart';

const _alGharb = 'Jabal Eifrit Al-gharb';
const _alJanub = 'Jabal Eifrit Al-Janub';
const _alSharq = 'Jabal Eifrit Al-sharq';

const _piter = "Piter's Net";
const _easternJumble = 'Eastern Jumble';
const _its76 = 'Imperial Testing Station No. 76';
const _khidrShadow = "Khidr's Shadow";
const _runawayCamp = 'Runaway Station Camp';
const _handOfKhidr = 'Hand of Khidr';
const _kelsFallback = "Kel's Fallback";

/// Seed list from IGN's Jabal Eifrit unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Jabal_Eifrit_Unique_Schematics_and_Locations
///
/// Jabal Eifrit splits into three sub-regions (Al-gharb, Al-Janub,
/// Al-sharq), each treated as its own region in the catalog so the region
/// filter chip stays close to in-game terminology.
///
/// Many Jabal Eifrit schematics also drop in Hagga Rift or Vermillius
/// Gap — those entries live in their original region's catalog file
/// (`hagga_rift.dart` / `vermillius_gap.dart`) with the Jabal Eifrit
/// sources appended. This file only contains schematics that are
/// **exclusive to Jabal Eifrit**.
///
/// IGN renders "Inkvine" as "lnkvine" (lowercase L) on the Jabal Eifrit
/// page; that's a typo in the source guide. "Skin-lined Jacket" / "Skin-
/// Lined Jacket" are also normalised. Both are matched to the existing
/// Hagga Rift catalog entries.
const jabalEifritBlueprintCatalog = [
  // ─── Jabal Eifrit Al-gharb ────────────────────────────────────────────
  BlueprintCatalogEntry(
    name: 'Ripper Searing Shiv',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _alGharb, location: _piter),
    ],
  ),
  // Spice-infused Steel Dust drops at both Al-gharb sites.
  BlueprintCatalogEntry(
    name: 'Spice-infused Steel Dust',
    category: 'Other',
    sources: [
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alGharb, location: _easternJumble),
    ],
  ),
  // Also drops in Shield Wall — see canon test for ITS 142 / ITS 60.
  BlueprintCatalogEntry(
    name: 'Spice-infused Copper Dust',
    category: 'Other',
    sources: [
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(
        region: 'Eastern Shield Wall',
        location: 'Imperial Testing Station No. 142',
      ),
      BlueprintSource(
        region: 'Western Shield Wall',
        location: 'Imperial Testing Station No. 60',
      ),
    ],
  ),

  // ─── Jabal Eifrit Al-Janub ────────────────────────────────────────────
  // Glutton's Drinker also drops in Al-gharb (Eastern Jumble) and
  // Al-sharq (Kel's Fallback). Distinct from Glutton's Bloodbag (which
  // lives in hagga_rift.dart with its own multi-region source list).
  BlueprintCatalogEntry(
    name: "Glutton's Drinker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(region: _alJanub, location: _its76),
      BlueprintSource(region: _alSharq, location: _kelsFallback),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Reaper Gloves',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _alJanub, location: _its76),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'The Tapper',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  // Rigged Suspensor Jacket — Runaway Camp only (the only entry in the
  // Al-Janub camp/Hand pool that does NOT also appear at Hand of Khidr).
  BlueprintCatalogEntry(
    name: 'Rigged Suspensor Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _alJanub, location: _runawayCamp),
    ],
  ),
  // Filter Extractor Mk3 — Hand of Khidr only (the only entry in the
  // same pool that does NOT also appear at the Runaway Camp).
  BlueprintCatalogEntry(
    name: 'Filter Extractor Mk3',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
    ],
  ),
];
