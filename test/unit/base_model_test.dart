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

  test('Base missedCycles counts overdue tax cycles', () {
    final now = DateTime.now();
    final base = Base(
      id: 'base-2',
      characterId: 'char-2',
      name: 'Tax Base',
      powerExpirationTime: now.add(const Duration(hours: 2)),
      createdAt: now,
      updatedAt: now,
      isAdvancedFief: true,
      taxPerCycle: 100,
      nextTaxDueDate: now.subtract(const Duration(days: 1)),
      currentOwed: 50,
      overdueOwed: 0,
      defaultedOwed: 0,
    );

    expect(base.missedCycles, 1);
    expect(base.effectiveCurrentOwed, 100);
  });
}
