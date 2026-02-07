import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/alerts/models/alert_settings.dart';

void main() {
  test('defaults are sensible', () {
    final settings = AlertSettings();
    expect(settings.warningThresholds, [24]);
    expect(settings.checkIntervalMinutes, 1);
    expect(settings.repeatIntervalMinutes, 0);
    expect(settings.enableSound, isFalse);
    expect(settings.enableNotifications, isTrue);
    expect(settings.minimizeToTray, isTrue);
  });

  test('copyWith overrides only specified fields', () {
    final settings = AlertSettings();
    final copy = settings.copyWith(
      warningThresholds: [24, 12, 6],
      enableSound: true,
    );
    expect(copy.warningThresholds, [24, 12, 6]);
    expect(copy.enableSound, isTrue);
    // Unchanged
    expect(copy.checkIntervalMinutes, 1);
    expect(copy.enableNotifications, isTrue);
  });
}
