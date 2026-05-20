import 'package:json_annotation/json_annotation.dart';

part 'quest.g.dart';

@JsonSerializable()
class Quest {
  static const Object _unset = Object();

  final String id;
  final String characterId;
  final String title;
  final String? description;
  final String? notes;
  final String status;
  final String questType;
  final String? missionType;
  final bool isLandsraadContract;
  final bool isRepeatable;
  final int? specializationXpGained;

  /// One-shot reminder (local time). Cleared after it fires.
  final DateTime? reminderAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quest({
    required this.id,
    required this.characterId,
    required this.title,
    this.description,
    this.notes,
    this.status = 'active',
    this.questType = 'general',
    this.missionType,
    this.isLandsraadContract = false,
    this.isRepeatable = false,
    this.specializationXpGained,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  Map<String, dynamic> toJson() => _$QuestToJson(this);

  Quest copyWith({
    String? id,
    String? characterId,
    String? title,
    Object? description = _unset,
    Object? notes = _unset,
    String? status,
    String? questType,
    Object? missionType = _unset,
    bool? isLandsraadContract,
    bool? isRepeatable,
    Object? specializationXpGained = _unset,
    Object? reminderAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quest(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      status: status ?? this.status,
      questType: questType ?? this.questType,
      missionType: identical(missionType, _unset)
          ? this.missionType
          : missionType as String?,
      isLandsraadContract: isLandsraadContract ?? this.isLandsraadContract,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      specializationXpGained: identical(specializationXpGained, _unset)
          ? this.specializationXpGained
          : specializationXpGained as int?,
      reminderAt: identical(reminderAt, _unset)
          ? this.reminderAt
          : reminderAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
