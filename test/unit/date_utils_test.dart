import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/utils/date_utils.dart';

void main() {
  group('formatDuration', () {
    test('formats days, hours, minutes', () {
      expect(
        DateUtils.formatDuration(
            const Duration(days: 2, hours: 5, minutes: 30)),
        '2 days, 5 hours, 30 minutes',
      );
    });

    test('formats singular units correctly', () {
      expect(
        DateUtils.formatDuration(const Duration(days: 1, hours: 1, minutes: 1)),
        '1 day, 1 hour, 1 minute',
      );
    });

    test('shows 0 minutes when duration is zero', () {
      expect(DateUtils.formatDuration(Duration.zero), '0 minutes');
    });

    test('omits zero-valued parts except minutes', () {
      expect(DateUtils.formatDuration(const Duration(hours: 3)), '3 hours');
    });
  });

  group('formatHoursRemaining', () {
    test('returns Expired for negative hours', () {
      expect(DateUtils.formatHoursRemaining(-1), 'Expired');
    });

    test('formats positive hours', () {
      final result = DateUtils.formatHoursRemaining(2.5);
      expect(result, contains('hour'));
    });
  });

  group('formatDate / formatTime', () {
    test('formatDate returns yyyy-MM-dd', () {
      final dt = DateTime(2026, 2, 6);
      expect(DateUtils.formatDate(dt), '2026-02-06');
    });

    test('formatTime returns HH:mm', () {
      final dt = DateTime(2026, 2, 6, 14, 30);
      expect(DateUtils.formatTime(dt), '14:30');
    });
  });

  group('getRelativeTime', () {
    test('returns "Just now" for recent past', () {
      final result = DateUtils.getRelativeTime(
        DateTime.now().subtract(const Duration(seconds: 10)),
      );
      expect(result, 'Just now');
    });

    test('returns minutes ago', () {
      final result = DateUtils.getRelativeTime(
        DateTime.now().subtract(const Duration(minutes: 5)),
      );
      expect(result, '5 minutes ago');
    });

    test('returns hours ago', () {
      final result = DateUtils.getRelativeTime(
        DateTime.now().subtract(const Duration(hours: 3)),
      );
      expect(result, '3 hours ago');
    });

    test('returns days ago', () {
      final result = DateUtils.getRelativeTime(
        DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(result, '2 days ago');
    });

    test('returns in X for future times', () {
      final result = DateUtils.getRelativeTime(
        DateTime.now().add(const Duration(hours: 5)),
      );
      expect(result, contains('in'));
    });
  });
}
