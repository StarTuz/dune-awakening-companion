import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/skills/models/character_skill.dart';

void main() {
  CharacterSkill sample() => CharacterSkill(
        id: 'cs-1',
        characterId: 'char-1',
        skillId: 'benegesserit-bindu-dodge',
        currentRank: 2,
        targetRank: 3,
        isEquipped: true,
        createdAt: DateTime.utc(2025, 1, 1, 12),
        updatedAt: DateTime.utc(2025, 5, 21, 9, 30),
      );

  test('toJson / fromJson round-trip preserves all fields', () {
    final original = sample();
    final restored = CharacterSkill.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.characterId, original.characterId);
    expect(restored.skillId, original.skillId);
    expect(restored.currentRank, original.currentRank);
    expect(restored.targetRank, original.targetRank);
    expect(restored.isEquipped, original.isEquipped);
    expect(restored.createdAt.toUtc(), original.createdAt.toUtc());
    expect(restored.updatedAt.toUtc(), original.updatedAt.toUtc());
  });

  test('toJson / fromJson round-trip handles null targetRank', () {
    final original = sample().copyWith(targetRank: null);
    // copyWith can't set a nullable field back to null with the current
    // signature (`int?` parameter falls through to `?? this.targetRank`),
    // so build directly instead — this also documents that limitation.
    final withoutTarget = CharacterSkill(
      id: original.id,
      characterId: original.characterId,
      skillId: original.skillId,
      currentRank: original.currentRank,
      targetRank: null,
      isEquipped: original.isEquipped,
      createdAt: original.createdAt,
      updatedAt: original.updatedAt,
    );

    final restored = CharacterSkill.fromJson(withoutTarget.toJson());
    expect(restored.targetRank, isNull);
  });

  test('copyWith overrides only the supplied fields', () {
    final original = sample();
    final updated = original.copyWith(currentRank: 3, isEquipped: false);

    expect(updated.currentRank, 3);
    expect(updated.isEquipped, false);
    expect(updated.id, original.id);
    expect(updated.characterId, original.characterId);
    expect(updated.skillId, original.skillId);
    expect(updated.targetRank, original.targetRank);
    expect(updated.createdAt, original.createdAt);
    expect(updated.updatedAt, original.updatedAt);
  });
}
