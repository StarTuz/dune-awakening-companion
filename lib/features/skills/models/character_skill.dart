import '../../../core/models/base_model.dart';

class CharacterSkill implements BaseModel {
  @override
  final String id;
  final String characterId;
  final String skillId;
  final int currentRank;
  final int? targetRank;
  final bool isEquipped;
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  CharacterSkill({
    required this.id,
    required this.characterId,
    required this.skillId,
    required this.currentRank,
    this.targetRank,
    required this.isEquipped,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CharacterSkill.fromJson(Map<String, dynamic> json) {
    return CharacterSkill(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      skillId: json['skillId'] as String,
      currentRank: json['currentRank'] as int,
      targetRank: json['targetRank'] as int?,
      isEquipped: json['isEquipped'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'skillId': skillId,
      'currentRank': currentRank,
      'targetRank': targetRank,
      'isEquipped': isEquipped,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CharacterSkill copyWith({
    String? id,
    String? characterId,
    String? skillId,
    int? currentRank,
    int? targetRank,
    bool? isEquipped,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CharacterSkill(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      skillId: skillId ?? this.skillId,
      currentRank: currentRank ?? this.currentRank,
      targetRank: targetRank ?? this.targetRank,
      isEquipped: isEquipped ?? this.isEquipped,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
