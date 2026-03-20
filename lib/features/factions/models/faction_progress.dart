import 'package:json_annotation/json_annotation.dart';

part 'faction_progress.g.dart';

@JsonSerializable()
class FactionProgress {
  final String id;
  final String characterId;
  final String factionName;
  final int currentRank;
  final int? reputationPoints;
  final int contractsCompleted;
  final DateTime updatedAt;

  FactionProgress({
    required this.id,
    required this.characterId,
    required this.factionName,
    this.currentRank = 1,
    this.reputationPoints,
    this.contractsCompleted = 0,
    required this.updatedAt,
  });

  factory FactionProgress.fromJson(Map<String, dynamic> json) =>
      _$FactionProgressFromJson(json);

  Map<String, dynamic> toJson() => _$FactionProgressToJson(this);

  FactionProgress copyWith({
    String? id,
    String? characterId,
    String? factionName,
    int? currentRank,
    int? reputationPoints,
    int? contractsCompleted,
    DateTime? updatedAt,
  }) {
    return FactionProgress(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      factionName: factionName ?? this.factionName,
      currentRank: currentRank ?? this.currentRank,
      reputationPoints: reputationPoints ?? this.reputationPoints,
      contractsCompleted: contractsCompleted ?? this.contractsCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
