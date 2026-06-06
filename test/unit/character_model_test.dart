import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/characters/models/character.dart';

void main() {
  final now = DateTime.now();

  test('copyWith preserves unset fields', () {
    final character = Character(
      id: 'c1',
      name: 'Paul',
      region: 'NA',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    );
    final copy = character.copyWith(name: 'Muad\'Dib');
    expect(copy.id, 'c1');
    expect(copy.name, 'Muad\'Dib');
    expect(copy.region, 'NA');
    expect(copy.serverType, 'Official');
    expect(copy.world, 'Arrakis');
    expect(copy.sietch, 'Tabr');
  });

  test('copyWith with provider', () {
    final character = Character(
      id: 'c2',
      name: 'Chani',
      region: 'EU',
      serverType: 'Private',
      provider: 'GPORTAL',
      world: 'Custom',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    );
    expect(character.provider, 'GPORTAL');
    final copy = character.copyWith(provider: 'BisectHosting');
    expect(copy.provider, 'BisectHosting');
  });

  test('closedWorldAcknowledged defaults false and round-trips via JSON', () {
    final c = Character(
      id: 'c3',
      name: 'Stilgar',
      region: 'Asia',
      serverType: 'Official',
      world: 'Bifrost',
      sietch: 'Tabr',
      closedWorldAcknowledged: true,
      createdAt: now,
      updatedAt: now,
    );
    expect(c.closedWorldAcknowledged, isTrue);

    final json = c.toJson();
    expect(json['closedWorldAcknowledged'], true);
    expect(Character.fromJson(json).closedWorldAcknowledged, isTrue);

    // Older backups predate the field; fromJson must default to false.
    final legacy = Map<String, dynamic>.from(json)
      ..remove('closedWorldAcknowledged');
    expect(Character.fromJson(legacy).closedWorldAcknowledged, isFalse);

    // Default when omitted from the constructor.
    final fresh = Character(
      id: 'c4',
      name: 'Paul',
      region: 'NA',
      serverType: 'Official',
      world: 'Arrakis',
      sietch: 'Tabr',
      createdAt: now,
      updatedAt: now,
    );
    expect(fresh.closedWorldAcknowledged, isFalse);
    expect(
        fresh.copyWith(closedWorldAcknowledged: true).closedWorldAcknowledged,
        isTrue);
  });
}
