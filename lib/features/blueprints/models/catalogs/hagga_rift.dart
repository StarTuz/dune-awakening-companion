import '../blueprint_catalog.dart';

const _region = 'Hagga Rift';

// IGN guides use "Imperial Testing Station #29" and "Choam Mineral
// Extraction Facility #6"; the catalog normalises both to "No. N" to match
// the Hagga Basin South and Vermillius Gap conventions.

const _deserterCamp = 'Deserter Camp in Imperial Testing Station No. 29';
const _choamFacility = 'Choam Mineral Extraction Facility No. 6';
const _stepstone = 'Stepstone Cavern';
const _spiral = 'The Spiral';
const _arctus = 'Arctus Cavern';
const _kytheria = 'Wreck of Kytheria';

// Cross-region sources (Jabal Eifrit) — many Hagga Rift schematics also
// drop in the three Jabal Eifrit sub-regions. Sources for those are
// appended here so each schematic stays in one row regardless of which
// region the player explores first.
const _alGharb = 'Jabal Eifrit Al-gharb';
const _alJanub = 'Jabal Eifrit Al-Janub';
const _alSharq = 'Jabal Eifrit Al-sharq';
const _piter = "Piter's Net";
const _easternJumble = 'Eastern Jumble';
const _its76 = 'Imperial Testing Station No. 76';
const _khidrShadow = "Khidr's Shadow";
const _runawayCamp = 'Runaway Station Camp';
const _handOfKhidr = 'Hand of Khidr';
const _tisiphone = 'Wreck of the Tisiphone';
const _kelsFallback = "Kel's Fallback";
const _farholdCamp = 'Unnamed observation point east of Farhold';

/// Seed list from IGN's Hagga Rift unique schematics guide:
/// https://www.ign.com/wikis/dune-awakening/All_Hagga_Rift_Unique_Schematics_and_Locations
///
/// Several schematics share a drop pool — IGN renders them as "X or Y" in
/// the location column. Those collapse into one catalog entry with
/// multiple sources here, so unlocking from any listed site flips the
/// checklist for the schematic everywhere it appears.
///
/// Note: `Buoyant Reaper Mk3` also drops in Hagga Rift / Stepstone Cavern,
/// but its catalog entry lives in `vermillius_gap.dart` next to its
/// Vermillius Gap East source. The canon test still asserts the Hagga
/// Rift source is wired up.
const haggaRiftBlueprintCatalog = [
  // ─── The Spiral / Arctus Cavern shared pool ───────────────────────────
  // Inkvine set + Handheld Life Scanner Mk3 also drop in Jabal Eifrit
  // Al-Janub at Khidr's Shadow; Assassin's Rifle is Hagga Rift only.
  BlueprintCatalogEntry(
    name: 'Inkvine Mask',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Pants',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Inkvine Boots',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Handheld Life Scanner Mk3',
    category: 'Tool',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
      BlueprintSource(region: _alJanub, location: _khidrShadow),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Assassin's Rifle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _spiral),
      BlueprintSource(region: _region, location: _arctus),
    ],
  ),

  // ─── Deserter Camp (Station 29) / Choam #6 shared pool ────────────────
  // Most of these also drop in all three Jabal Eifrit sub-regions; the
  // exception is Focused Buggy Cutteray Mk3 (Hagga Rift only).
  BlueprintCatalogEntry(
    name: 'Artisan Disruptor Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Callie's Breaker",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(region: _alJanub, location: _its76),
      BlueprintSource(region: _alSharq, location: _kelsFallback),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Old Sparky Mk3',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(region: _alJanub, location: _its76),
      BlueprintSource(region: _alSharq, location: _kelsFallback),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Seb's Kisser",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(region: _alJanub, location: _its76),
      BlueprintSource(region: _alSharq, location: _kelsFallback),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shock-sword',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _alGharb, location: _easternJumble),
      BlueprintSource(region: _alJanub, location: _its76),
      BlueprintSource(region: _alSharq, location: _kelsFallback),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Focused Buggy Cutteray Mk3',
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  // Community wiki places the schematic on the Shock-Knife Corpse across
  // from Choam #6, up a level.
  BlueprintCatalogEntry(
    name: 'Shock-Knife',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _choamFacility),
    ],
  ),
  // Glutton's Bloodbag — six sources: three in Hagga Rift, two in
  // Al-Janub (Runaway Camp + Hand of Khidr), and one in Al-sharq
  // (Farhold observation camp).
  BlueprintCatalogEntry(
    name: "Glutton's Bloodbag",
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _deserterCamp),
      BlueprintSource(region: _region, location: _choamFacility),
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),

  // ─── Stepstone Cavern + Jabal Eifrit Camp/Hand/Farhold pools ──────────
  // Each of these schematics drops in Hagga Rift's Stepstone Cavern, both
  // Jabal Eifrit Al-Janub camps (Runaway + Hand of Khidr), and the Al-sharq
  // Farhold observation point.
  BlueprintCatalogEntry(
    name: 'Hajra Literjon Mk3',
    category: 'Utility',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Shock Gauntlets',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Skin-Lined Jacket',
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Ta'lab Softstep Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),
  BlueprintCatalogEntry(
    name: "The Emperor's Wings Mk3",
    category: 'Vehicle',
    sources: [
      BlueprintSource(region: _region, location: _stepstone),
      BlueprintSource(region: _alJanub, location: _runawayCamp),
      BlueprintSource(region: _alJanub, location: _handOfKhidr),
      BlueprintSource(region: _alSharq, location: _farholdCamp),
    ],
  ),

  // ─── Wreck of Kytheria + Jabal Eifrit "Wreck/Net" pools ───────────────
  // Karak's set + Way of the Lost + Zaal's Companion also drop at the
  // Al-gharb Piter's Net camp and the Al-sharq Wreck of the Tisiphone.
  // Ripper Scattergun only adds Al-sharq (Al-gharb has the distinct
  // Ripper Searing Shiv instead — see jabal_eifrit.dart).
  BlueprintCatalogEntry(
    name: "Karak's Helmet",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Jacket",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Gauntlets",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Pants",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Karak's Boots",
    category: 'Armor',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Way of the Lost Maula Pistol',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: "Zaal's Companion Assault Rifle",
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alGharb, location: _piter),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Ripper Scattergun',
    category: 'Weapon',
    sources: [
      BlueprintSource(region: _region, location: _kytheria),
      BlueprintSource(region: _alSharq, location: _tisiphone),
    ],
  ),
];
