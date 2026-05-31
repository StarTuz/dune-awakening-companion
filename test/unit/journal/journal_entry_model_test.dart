import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/features/journal/models/journal_entry.dart';

void main() {
  JournalEntry sample() => JournalEntry(
        id: 'je-1',
        characterId: 'char-1',
        title: 'Arrival at Hagga Basin',
        body: 'Made landfall near the Imperial testing station.',
        tags: const ['arrival', 'hagga'],
        entryDate: DateTime.utc(2026, 5, 30),
        location: 'Hagga Basin South',
        mood: 'Determined',
        questId: 'quest-1',
        imagePath: '/tmp/screenshot.png',
        createdAt: DateTime.utc(2026, 5, 30, 8),
        updatedAt: DateTime.utc(2026, 5, 30, 9, 15),
      );

  test('toJson / fromJson round-trip preserves all fields', () {
    final original = sample();
    final restored = JournalEntry.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.characterId, original.characterId);
    expect(restored.title, original.title);
    expect(restored.body, original.body);
    expect(restored.tags, original.tags);
    expect(restored.entryDate.toUtc(), original.entryDate.toUtc());
    expect(restored.location, original.location);
    expect(restored.mood, original.mood);
    expect(restored.questId, original.questId);
    expect(restored.imagePath, original.imagePath);
    expect(restored.createdAt.toUtc(), original.createdAt.toUtc());
    expect(restored.updatedAt.toUtc(), original.updatedAt.toUtc());
  });

  test('copyWith can clear nullable Phase 2/3 fields back to null', () {
    final original = sample();
    final cleared = original.copyWith(
      location: null,
      mood: null,
      questId: null,
      imagePath: null,
    );

    expect(cleared.location, isNull);
    expect(cleared.mood, isNull);
    expect(cleared.questId, isNull);
    expect(cleared.imagePath, isNull);
    expect(cleared.title, original.title);
  });

  test('copyWith leaves nullable fields untouched when omitted', () {
    final original = sample();
    final updated = original.copyWith(title: 'Renamed');

    expect(updated.location, original.location);
    expect(updated.mood, original.mood);
    expect(updated.questId, original.questId);
    expect(updated.imagePath, original.imagePath);
  });

  test('fromJson tolerates missing body and tags', () {
    final restored = JournalEntry.fromJson({
      'id': 'je-2',
      'characterId': 'char-1',
      'title': 'Quiet day',
      'entryDate': DateTime.utc(2026, 5, 30).toIso8601String(),
      'createdAt': DateTime.utc(2026, 5, 30).toIso8601String(),
      'updatedAt': DateTime.utc(2026, 5, 30).toIso8601String(),
    });

    expect(restored.body, '');
    expect(restored.tags, isEmpty);
  });

  test('copyWith overrides only the supplied fields', () {
    final original = sample();
    final updated = original.copyWith(title: 'Updated', tags: const ['edit']);

    expect(updated.title, 'Updated');
    expect(updated.tags, const ['edit']);
    expect(updated.id, original.id);
    expect(updated.characterId, original.characterId);
    expect(updated.body, original.body);
    expect(updated.entryDate, original.entryDate);
    expect(updated.createdAt, original.createdAt);
  });
}
