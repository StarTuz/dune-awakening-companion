import 'package:intl/intl.dart';

class DateUtils {
  /// Format duration as human-readable string
  /// Example: "2 days, 5 hours, 30 minutes"
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    final parts = <String>[];
    
    if (days > 0) {
      parts.add('$days ${days == 1 ? 'day' : 'days'}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (minutes > 0 || parts.isEmpty) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    return parts.join(', ');
  }

  /// Format hours remaining as human-readable string
  static String formatHoursRemaining(double hours) {
    if (hours < 0) {
      return 'Expired';
    }
    
    final duration = Duration(minutes: (hours * 60).round());
    return formatDuration(duration);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  /// Format date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// Format time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Get relative time string (e.g., "in 2 hours", "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return '${absDiff.inDays} ${absDiff.inDays == 1 ? 'day' : 'days'} ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours} ${absDiff.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes} ${absDiff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } else {
      if (difference.inDays > 0) {
        return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'Now';
      }
    }
  }
}

