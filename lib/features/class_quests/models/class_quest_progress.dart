class ClassQuestProgress {
  static const Object _unset = Object();

  final String id;
  final String characterId;
  final String questId;
  final String status;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;

  const ClassQuestProgress({
    required this.id,
    required this.characterId,
    required this.questId,
    this.status = ClassQuestStatus.notStarted,
    this.notes,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });

  factory ClassQuestProgress.fromJson(Map<String, dynamic> json) {
    return ClassQuestProgress(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      questId: json['questId'] as String,
      status: json['status'] as String? ?? ClassQuestStatus.notStarted,
      notes: json['notes'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'questId': questId,
      'status': status,
      'notes': notes,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ClassQuestProgress copyWith({
    String? id,
    String? characterId,
    String? questId,
    String? status,
    Object? notes = _unset,
    Object? startedAt = _unset,
    Object? completedAt = _unset,
    DateTime? updatedAt,
  }) {
    return ClassQuestProgress(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      questId: questId ?? this.questId,
      status: status ?? this.status,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      startedAt: identical(startedAt, _unset)
          ? this.startedAt
          : startedAt as DateTime?,
      completedAt: identical(completedAt, _unset)
          ? this.completedAt
          : completedAt as DateTime?,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ClassQuestStepProgress {
  final String id;
  final String classQuestProgressId;
  final String stepId;
  final bool isCompleted;
  final DateTime? completedAt;

  const ClassQuestStepProgress({
    required this.id,
    required this.classQuestProgressId,
    required this.stepId,
    this.isCompleted = false,
    this.completedAt,
  });

  factory ClassQuestStepProgress.fromJson(Map<String, dynamic> json) {
    return ClassQuestStepProgress(
      id: json['id'] as String,
      classQuestProgressId: json['classQuestProgressId'] as String,
      stepId: json['stepId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classQuestProgressId': classQuestProgressId,
      'stepId': stepId,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class ClassQuestStatus {
  static const notStarted = 'not_started';
  static const notRequired = 'not_required';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
}
