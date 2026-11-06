import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat _dateTime = DateFormat('MMM d, yyyy • h:mm a');
  static final DateFormat _timeOnly = DateFormat('h:mm a');
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _relativeDay = DateFormat('EEEE, MMM d');

  static String formatShort(DateTime? date) {
    if (date == null) return 'N/A';
    return _shortDate.format(date);
  }

  static String formatDate(DateTime? date) => formatShort(date);

  static String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return _dateTime.format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return _timeOnly.format(date);
  }

  static String formatMonthYear(DateTime? date) {
    if (date == null) return 'N/A';
    return _monthYear.format(date);
  }

  static String formatRelativeDay(DateTime? date) {
    if (date == null) return 'N/A';
    return _relativeDay.format(date);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatShort(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
