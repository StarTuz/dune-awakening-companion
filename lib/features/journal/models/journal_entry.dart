import '../../../core/models/base_model.dart';

/// A single player-authored RPG journal entry, scoped to a character.
///
/// Tags are modelled as a list here but stored as a comma-separated string in
/// the database (`JournalRepository`); see `docs/RESEARCH_RPG_JOURNAL_NOTES.md`
/// for the rationale behind starting with a denormalised tag column.
class JournalEntry implements BaseModel {
  @override
  final String id;
  final String characterId;
  final String title;
  final String body;
  final List<String> tags;
  final DateTime entryDate;

  /// Phase 2: optional place this entry happened.
  final String? location;

  /// Phase 2: optional mood/tone label.
  final String? mood;

  /// Phase 3: optional link to a tracked quest (`Quest.id`).
  final String? questId;

  /// Phase 3: optional local path to a screenshot/image.
  final String? imagePath;
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  static const Object _unset = Object();

  JournalEntry({
    required this.id,
    required this.characterId,
    required this.title,
    this.body = '',
    this.tags = const [],
    required this.entryDate,
    this.location,
    this.mood,
    this.questId,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag as String)
          .toList(),
      entryDate: DateTime.parse(json['entryDate'] as String),
      location: json['location'] as String?,
      mood: json['mood'] as String?,
      questId: json['questId'] as String?,
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'title': title,
      'body': body,
      'tags': tags,
      'entryDate': entryDate.toIso8601String(),
      'location': location,
      'mood': mood,
      'questId': questId,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  JournalEntry copyWith({
    String? id,
    String? characterId,
    String? title,
    String? body,
    List<String>? tags,
    DateTime? entryDate,
    Object? location = _unset,
    Object? mood = _unset,
    Object? questId = _unset,
    Object? imagePath = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      entryDate: entryDate ?? this.entryDate,
      location:
          identical(location, _unset) ? this.location : location as String?,
      mood: identical(mood, _unset) ? this.mood : mood as String?,
      questId: identical(questId, _unset) ? this.questId : questId as String?,
      imagePath:
          identical(imagePath, _unset) ? this.imagePath : imagePath as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
