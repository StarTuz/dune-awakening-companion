/// Model for a notification history entry
class NotificationHistoryEntry {
  final int? id;
  final String type; // 'power', 'tax'
  final String title;
  final String body;
  final String? baseId;
  final String? baseName;
  final String? characterName;
  final String severity; // 'critical', 'warning', 'info'
  final DateTime sentAt;
  final bool read;

  const NotificationHistoryEntry({
    this.id,
    required this.type,
    required this.title,
    required this.body,
    this.baseId,
    this.baseName,
    this.characterName,
    required this.severity,
    required this.sentAt,
    this.read = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'base_id': baseId,
      'base_name': baseName,
      'character_name': characterName,
      'severity': severity,
      'sent_at': sentAt.toIso8601String(),
      'read': read ? 1 : 0,
    };
  }

  factory NotificationHistoryEntry.fromMap(Map<String, dynamic> map) {
    return NotificationHistoryEntry(
      id: map['id'] as int?,
      type: map['type'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      baseId: map['base_id'] as String?,
      baseName: map['base_name'] as String?,
      characterName: map['character_name'] as String?,
      severity: map['severity'] as String,
      sentAt: DateTime.parse(map['sent_at'] as String),
      read: (map['read'] as int) == 1,
    );
  }

  NotificationHistoryEntry copyWith({
    int? id,
    String? type,
    String? title,
    String? body,
    String? baseId,
    String? baseName,
    String? characterName,
    String? severity,
    DateTime? sentAt,
    bool? read,
  }) {
    return NotificationHistoryEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      baseId: baseId ?? this.baseId,
      baseName: baseName ?? this.baseName,
      characterName: characterName ?? this.characterName,
      severity: severity ?? this.severity,
      sentAt: sentAt ?? this.sentAt,
      read: read ?? this.read,
    );
  }

  /// Get a display icon based on type
  String get iconEmoji {
    switch (type) {
      case 'power':
        return '⚡';
      case 'tax':
        return '💰';
      default:
        return '🔔';
    }
  }

  /// Get relative time string
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(sentAt);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${sentAt.day}/${sentAt.month}/${sentAt.year}';
    }
  }
}
