import 'package:json_annotation/json_annotation.dart';

part 'character_specialization.g.dart';

@JsonSerializable()
class CharacterSpecialization {
  final String id;
  final String characterId;
  final int combatLevel;
  final int craftingLevel;
  final int gatheringLevel;
  final int explorationLevel;
  final int sabotageLevel;
  final DateTime updatedAt;

  CharacterSpecialization({
    required this.id,
    required this.characterId,
    this.combatLevel = 0,
    this.craftingLevel = 0,
    this.gatheringLevel = 0,
    this.explorationLevel = 0,
    this.sabotageLevel = 0,
    required this.updatedAt,
  });

  factory CharacterSpecialization.fromJson(Map<String, dynamic> json) =>
      _$CharacterSpecializationFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterSpecializationToJson(this);

  int get totalLevel =>
      combatLevel +
      craftingLevel +
      gatheringLevel +
      explorationLevel +
      sabotageLevel;

  CharacterSpecialization copyWith({
    String? id,
    String? characterId,
    int? combatLevel,
    int? craftingLevel,
    int? gatheringLevel,
    int? explorationLevel,
    int? sabotageLevel,
    DateTime? updatedAt,
  }) {
    return CharacterSpecialization(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      combatLevel: combatLevel ?? this.combatLevel,
      craftingLevel: craftingLevel ?? this.craftingLevel,
      gatheringLevel: gatheringLevel ?? this.gatheringLevel,
      explorationLevel: explorationLevel ?? this.explorationLevel,
      sabotageLevel: sabotageLevel ?? this.sabotageLevel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
