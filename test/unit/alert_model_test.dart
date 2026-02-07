import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/alerts/models/alert.dart';

void main() {
  final now = DateTime.now();

  test('isActive is true when not acknowledged or dismissed', () {
    final alert = Alert(
      id: 'a1',
      baseId: 'b1',
      thresholdHours: 24,
      createdAt: now,
    );
    expect(alert.isActive, isTrue);
    expect(alert.isAcknowledged, isFalse);
    expect(alert.isDismissed, isFalse);
  });

  test('isActive is false when acknowledged', () {
    final alert = Alert(
      id: 'a2',
      baseId: 'b1',
      thresholdHours: 12,
      createdAt: now,
      acknowledgedAt: now,
    );
    expect(alert.isActive, isFalse);
    expect(alert.isAcknowledged, isTrue);
  });

  test('isActive is false when dismissed', () {
    final alert = Alert(
      id: 'a3',
      baseId: 'b1',
      thresholdHours: 6,
      createdAt: now,
      dismissedAt: now,
    );
    expect(alert.isActive, isFalse);
    expect(alert.isDismissed, isTrue);
  });

  test('copyWith preserves unset fields', () {
    final alert = Alert(
      id: 'a4',
      baseId: 'b1',
      thresholdHours: 24,
      createdAt: now,
    );
    final copy = alert.copyWith(thresholdHours: 12);
    expect(copy.id, 'a4');
    expect(copy.baseId, 'b1');
    expect(copy.thresholdHours, 12);
    expect(copy.createdAt, now);
  });
}
