import 'package:json_annotation/json_annotation.dart';

part 'quest_step.g.dart';

@JsonSerializable()
class QuestStep {
  static const Object _unset = Object();

  final String id;
  final String questId;
  final String title;
  final String? notes;
  final int sortOrder;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;

  QuestStep({
    required this.id,
    required this.questId,
    required this.title,
    this.notes,
    this.sortOrder = 0,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
  });

  factory QuestStep.fromJson(Map<String, dynamic> json) =>
      _$QuestStepFromJson(json);

  Map<String, dynamic> toJson() => _$QuestStepToJson(this);

  QuestStep copyWith({
    String? id,
    String? questId,
    String? title,
    Object? notes = _unset,
    int? sortOrder,
    bool? isCompleted,
    Object? completedAt = _unset,
    DateTime? createdAt,
  }) {
    return QuestStep(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      title: title ?? this.title,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      sortOrder: sortOrder ?? this.sortOrder,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: identical(completedAt, _unset)
          ? this.completedAt
          : completedAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
