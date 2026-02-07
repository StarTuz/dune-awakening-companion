import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/bases/models/base.dart';

void main() {
  test('Base power status reflects expiration time', () {
    final now = DateTime.now();
    final base = Base(
      id: 'base-1',
      characterId: 'char-1',
      name: 'Test Base',
      powerExpirationTime: now.add(const Duration(hours: 2)),
      createdAt: now,
      updatedAt: now,
    );

    expect(base.isExpired, isFalse);
    expect(base.isExpiringSoon, isTrue);
    expect(base.hoursRemaining, greaterThan(0));
  });

  test('Base expired when power time is in the past', () {
    final now = DateTime.now();
    final base = Base(
      id: 'base-2',
      characterId: 'char-2',
      name: 'Expired Base',
      powerExpirationTime: now.subtract(const Duration(hours: 2)),
      createdAt: now,
      updatedAt: now,
    );

    expect(base.isExpired, isTrue);
    expect(base.hoursRemaining, lessThan(0));
  });
}
