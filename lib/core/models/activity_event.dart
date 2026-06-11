/// What kind of app action an [ActivityEvent] records.
enum ActivityEventType {
  characterCreated,
  characterDeleted,
  baseCreated,
  baseDeleted,
  journalEntryWritten;

  static ActivityEventType fromName(String name) =>
      ActivityEventType.values.firstWhere(
        (t) => t.name == name,
        orElse: () => ActivityEventType.journalEntryWritten,
      );
}

/// One row in the dashboard's Recent Activity feed.
///
/// [subject] and [characterName] are display-name snapshots taken when the
/// event happened, so the feed stays meaningful after the referenced
/// character or base is deleted.
class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.type,
    required this.subject,
    this.characterName,
    required this.createdAt,
  });

  final String id;
  final ActivityEventType type;
  final String subject;
  final String? characterName;
  final DateTime createdAt;
}
