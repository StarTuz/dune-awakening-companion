import 'package:uuid/uuid.dart';

import 'blueprint.dart';
import 'catalogs/class_rewards.dart';
import 'catalogs/deep_desert.dart';
import 'catalogs/deep_desert_t6.dart';
import 'catalogs/dlc.dart';
import 'catalogs/hagga_basin_south.dart';
import 'catalogs/hagga_rift.dart';
import 'catalogs/jabal_eifrit.dart';
import 'catalogs/mysa_tarill.dart';
import 'catalogs/oodham.dart';
import 'catalogs/sheol.dart';
import 'catalogs/shield_wall.dart';
import 'catalogs/vermillius_gap.dart';

/// A single in-world location where a schematic can drop.
class BlueprintSource {
  final String region;
  final String location;

  const BlueprintSource({required this.region, required this.location});

  String get label => '$region, $location';
}

class BlueprintCatalogEntry {
  final String name;
  final String category;
  final List<BlueprintSource> sources;
  final String sourceGroup;

  const BlueprintCatalogEntry({
    required this.name,
    required this.category,
    required this.sources,
    this.sourceGroup = BlueprintSourceGroup.worldChest,
  });

  /// Region of the first source — used when creating a `Blueprint` record
  /// for a schematic the player just discovered.
  String get primaryRegion => sources.first.region;

  /// Distinct regions this schematic drops in (preserves source order).
  List<String> get regions {
    final seen = <String>{};
    return [
      for (final s in sources)
        if (seen.add(s.region)) s.region,
    ];
  }

  /// Display-friendly joined source labels (region, location pairs).
  String get sourceSummary => sources.map((s) => s.label).join(' / ');

  bool get isDeepDesert => regions.contains('Deep Desert');

  String get effectiveSourceGroup =>
      isDeepDesert ? BlueprintSourceGroup.deepDesert : sourceGroup;

  String get sourceGroupLabel =>
      BlueprintSourceGroup.label(effectiveSourceGroup);

  Blueprint toBlueprint(String characterId, {BlueprintSource? source}) {
    final src = source ?? sources.first;
    final sourceLocation =
        isDeepDesert ? 'Deep Desert weekly rotating drop pool' : src.location;
    final notes = switch (effectiveSourceGroup) {
      BlueprintSourceGroup.deepDesert =>
        'Seeded from known Deep Desert schematic pools. Current-week POI/grid locations rotate after the Coriolis Storm and are not synced by this app.',
      BlueprintSourceGroup.dlc =>
        'Seeded from DLC / reward unlock data; verify ownership and unlock conditions in-game.',
      BlueprintSourceGroup.classQuestReward =>
        'Seeded from class quest completion rewards; complete the associated class quest chain in-game.',
      _ =>
        'Seeded from IGN unique schematics guide; verify in-game before treating as confirmed.',
    };
    final now = DateTime.now();
    return Blueprint(
      id: const Uuid().v4(),
      characterId: characterId,
      name: name,
      category: category,
      region: src.region,
      sourceType: 'Chest',
      sourceLocation: sourceLocation,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }
}

class BlueprintSourceGroup {
  static const worldChest = 'world_chest';
  static const deepDesert = 'deep_desert';
  static const dlc = 'dlc';
  static const classQuestReward = 'class_quest_reward';

  static const ordered = [
    worldChest,
    deepDesert,
    dlc,
    classQuestReward,
  ];

  static String label(String group) {
    return switch (group) {
      deepDesert => 'Deep Desert',
      dlc => 'DLC / Lost Harvest',
      classQuestReward => 'Class Quest Rewards',
      _ => 'World / Chest Drops',
    };
  }
}

/// Aggregate catalog across every region the app knows about. Per-region
/// lists live under `catalogs/`.
const blueprintCatalog = [
  ...deepDesertBlueprintCatalog,
  ...deepDesertT6BlueprintCatalog,
  ...dlcBlueprintCatalog,
  ...classRewardBlueprintCatalog,
  ...haggaBasinSouthBlueprintCatalog,
  ...vermilliusGapBlueprintCatalog,
  ...haggaRiftBlueprintCatalog,
  ...jabalEifritBlueprintCatalog,
  ...shieldWallBlueprintCatalog,
  ...oodhamBlueprintCatalog,
  ...mysaTarillBlueprintCatalog,
  ...sheolBlueprintCatalog,
];

List<String> blueprintCatalogSourceGroups() {
  final present = {
    for (final entry in blueprintCatalog) entry.effectiveSourceGroup,
  };
  return [
    for (final group in BlueprintSourceGroup.ordered)
      if (present.contains(group)) group,
  ];
}

/// Distinct region names that appear in the catalog, in the order the
/// catalog declares them.
List<String> blueprintCatalogRegions() {
  final seen = <String>{};
  final ordered = <String>[];
  for (final entry in blueprintCatalog) {
    for (final source in entry.sources) {
      if (seen.add(source.region)) ordered.add(source.region);
    }
  }
  return ordered;
}
