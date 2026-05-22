import 'package:uuid/uuid.dart';

import 'blueprint.dart';
import 'catalogs/hagga_basin_south.dart';
import 'catalogs/hagga_rift.dart';
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

  const BlueprintCatalogEntry({
    required this.name,
    required this.category,
    required this.sources,
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

  Blueprint toBlueprint(String characterId, {BlueprintSource? source}) {
    final src = source ?? sources.first;
    final now = DateTime.now();
    return Blueprint(
      id: const Uuid().v4(),
      characterId: characterId,
      name: name,
      category: category,
      region: src.region,
      sourceType: 'Chest',
      sourceLocation: src.location,
      notes:
          'Seeded from IGN unique schematics guide; verify in-game before treating as confirmed.',
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Aggregate catalog across every region the app knows about. Per-region
/// lists live under `catalogs/`.
const blueprintCatalog = [
  ...haggaBasinSouthBlueprintCatalog,
  ...vermilliusGapBlueprintCatalog,
  ...haggaRiftBlueprintCatalog,
];

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
