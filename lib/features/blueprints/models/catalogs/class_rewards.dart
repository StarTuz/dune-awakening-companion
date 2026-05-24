import '../blueprint_catalog.dart';

const _region = 'Class Quest Rewards';

/// Class quest completion rewards.
///
/// These are blueprint-style unlocks earned by completing class quest chains,
/// not farmable schematic chest drops. Armor set piece names should be added
/// only after in-game confirmation.
const classRewardBlueprintCatalog = [
  BlueprintCatalogEntry(
    name: 'Trooper Archetype Armor Set',
    category: 'Armor',
    sourceGroup: BlueprintSourceGroup.classQuestReward,
    sources: [
      BlueprintSource(
        region: _region,
        location: 'Complete Trooper Advanced Training',
      ),
    ],
  ),
  BlueprintCatalogEntry(
    name: 'Swordmaster Archetype Armor Set',
    category: 'Armor',
    sourceGroup: BlueprintSourceGroup.classQuestReward,
    sources: [
      BlueprintSource(
        region: _region,
        location: 'Complete Swordmaster Advanced Training',
      ),
    ],
  ),
];
