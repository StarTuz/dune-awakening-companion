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
}
