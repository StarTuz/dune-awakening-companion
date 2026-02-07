import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/services/notification_settings.dart';

void main() {
  group('minutesToTimeString', () {
    test('midnight is 12:00 AM', () {
      expect(NotificationSettings.minutesToTimeString(0), '12:00 AM');
    });

    test('noon is 12:00 PM', () {
      expect(NotificationSettings.minutesToTimeString(720), '12:00 PM');
    });

    test('10 PM is 1320 minutes', () {
      expect(NotificationSettings.minutesToTimeString(1320), '10:00 PM');
    });

    test('8 AM is 480 minutes', () {
      expect(NotificationSettings.minutesToTimeString(480), '08:00 AM');
    });

    test('1:30 PM is 810 minutes', () {
      expect(NotificationSettings.minutesToTimeString(810), '01:30 PM');
    });
  });
}
