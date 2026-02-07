import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/models/notification_history_entry.dart';

void main() {
  group('toMap / fromMap roundtrip', () {
    test('preserves all fields', () {
      final entry = NotificationHistoryEntry(
        id: 1,
        type: 'power',
        title: 'Power Critical',
        body: 'Your base is running low on power.',
        baseId: 'base-1',
        baseName: 'Outpost Alpha',
        characterName: 'Paul',
        severity: 'critical',
        sentAt: DateTime(2026, 2, 6, 12, 0),
        read: false,
      );

      final map = entry.toMap();
      final restored = NotificationHistoryEntry.fromMap(map);

      expect(restored.id, 1);
      expect(restored.type, 'power');
      expect(restored.title, 'Power Critical');
      expect(restored.body, 'Your base is running low on power.');
      expect(restored.baseId, 'base-1');
      expect(restored.baseName, 'Outpost Alpha');
      expect(restored.characterName, 'Paul');
      expect(restored.severity, 'critical');
      expect(restored.sentAt, DateTime(2026, 2, 6, 12, 0));
      expect(restored.read, isFalse);
    });
  });

  group('iconEmoji', () {
    test('returns lightning for power', () {
      final entry = _makeEntry(type: 'power');
      expect(entry.iconEmoji, '⚡');
    });

    test('returns money bag for tax', () {
      final entry = _makeEntry(type: 'tax');
      expect(entry.iconEmoji, '💰');
    });

    test('returns bell for unknown type', () {
      final entry = _makeEntry(type: 'other');
      expect(entry.iconEmoji, '🔔');
    });
  });

  group('timeAgo', () {
    test('returns "Just now" for recent entries', () {
      final entry = _makeEntry(sentAt: DateTime.now());
      expect(entry.timeAgo, 'Just now');
    });

    test('returns minutes ago', () {
      final entry = _makeEntry(
        sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );
      expect(entry.timeAgo, '10m ago');
    });

    test('returns hours ago', () {
      final entry = _makeEntry(
        sentAt: DateTime.now().subtract(const Duration(hours: 3)),
      );
      expect(entry.timeAgo, '3h ago');
    });

    test('returns days ago', () {
      final entry = _makeEntry(
        sentAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(entry.timeAgo, '2d ago');
    });

    test('returns date for entries older than a week', () {
      final entry = _makeEntry(
        sentAt: DateTime.now().subtract(const Duration(days: 10)),
      );
      expect(entry.timeAgo, contains('/'));
    });
  });

  group('copyWith', () {
    test('copies and overrides selected fields', () {
      final entry = _makeEntry(read: false);
      final copy = entry.copyWith(read: true);
      expect(copy.read, isTrue);
      expect(copy.type, entry.type);
    });
  });
}

NotificationHistoryEntry _makeEntry({
  String type = 'power',
  DateTime? sentAt,
  bool read = false,
}) {
  return NotificationHistoryEntry(
    type: type,
    title: 'Test',
    body: 'Test body',
    severity: 'warning',
    sentAt: sentAt ?? DateTime.now(),
    read: read,
  );
}
