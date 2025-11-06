import 'package:intl/intl.dart';
import 'package:restaurant_reservation/core/constants/app_constants.dart';

/// Date and time utility functions.
///
/// Provides helper methods for date/time operations.
class AppDateUtils {
  AppDateUtils._();

  /// Formats a [DateTime] to 'dd/MM/yyyy'.
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formats a [DateTime] to 'HH:mm'.
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Formats a [DateTime] to 'dd/MM/yyyy HH:mm'.
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formats a [DateTime] with custom pattern.
  static String formatCustom(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Parses date string in format 'dd/MM/yyyy'.
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parses time string in format 'HH:mm'.
  static DateTime? parseTime(String timeString) {
    try {
      return DateFormat('HH:mm').parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Parses date-time string in format 'dd/MM/yyyy HH:mm'.
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Parses ISO 8601 date-time string.
  static DateTime? parseIso8601(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  /// Converts [DateTime] to ISO 8601 string.
  static String toIso8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Returns true if the date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if the date is tomorrow.
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Returns true if the date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Returns the start of day (00:00:00) for the given date.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of day (23:59:59) for the given date.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Returns the first day of the month for the given date.
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  /// Returns the last day of the month for the given date.
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Returns the difference in days between two dates.
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = startOfDay(from);
    final toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }

  /// Returns the difference in hours between two dates.
  static int hoursBetween(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  /// Returns the difference in minutes between two dates.
  static int minutesBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes;
  }

  /// Returns true if the given date is in the past.
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Returns true if the given date is in the future.
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Returns true if the given date is between two dates (inclusive).
  static bool isBetween(DateTime date, DateTime start, DateTime end) {
    return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
        (date.isBefore(end) || date.isAtSameMomentAs(end));
  }

  /// Returns true if the date is a weekend (Saturday or Sunday).
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  /// Returns true if the date is a weekday (Monday to Friday).
  static bool isWeekday(DateTime date) {
    return !isWeekend(date);
  }

  /// Returns the next weekday (skipping weekends).
  static DateTime nextWeekday(DateTime date) {
    var next = date.add(const Duration(days: 1));
    while (isWeekend(next)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  /// Returns relative date string (Today, Tomorrow, Yesterday, or formatted date).
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    if (isYesterday(date)) return 'Yesterday';
    return formatDate(date);
  }

  /// Returns relative time string (e.g., "2 hours ago", "in 3 days").
  static String getRelativeTimeString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past
      final absDifference = difference.abs();
      if (absDifference.inSeconds < 60) {
        return 'Just now';
      } else if (absDifference.inMinutes < 60) {
        final minutes = absDifference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (absDifference.inHours < 24) {
        final hours = absDifference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (absDifference.inDays < 7) {
        final days = absDifference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        return formatDate(dateTime);
      }
    } else {
      // Future
      if (difference.inSeconds < 60) {
        return 'In a moment';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return 'In $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return 'In $hours ${hours == 1 ? 'hour' : 'hours'}';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return 'In $days ${days == 1 ? 'day' : 'days'}';
      } else {
        return formatDate(dateTime);
      }
    }
  }

  /// Generates list of time slots for reservations.
  ///
  /// Returns list of [DateTime] objects representing available time slots
  /// between opening and closing hours with specified interval.
  static List<DateTime> generateTimeSlots(
    DateTime date, {
    int startHour = AppConstants.openingHour,
    int endHour = AppConstants.closingHour,
    int intervalMinutes = AppConstants.slotDurationMinutes,
  }) {
    final slots = <DateTime>[];
    var currentTime = DateTime(date.year, date.month, date.day, startHour);
    final endTime = DateTime(date.year, date.month, date.day, endHour);

    while (currentTime.isBefore(endTime)) {
      slots.add(currentTime);
      currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    }

    return slots;
  }

  /// Returns the minimum valid reservation date.
  ///
  /// Adds the minimum advance booking time to current date/time.
  static DateTime getMinReservationDate() {
    return DateTime.now().add(
      Duration(hours: AppConstants.minAdvanceBookingHours),
    );
  }

  /// Returns the maximum valid reservation date.
  ///
  /// Adds the maximum advance booking days to current date.
  static DateTime getMaxReservationDate() {
    return DateTime.now().add(
      Duration(days: AppConstants.maxAdvanceBookingDays),
    );
  }

  /// Validates if the given date is within valid reservation range.
  static bool isValidReservationDate(DateTime date) {
    final min = getMinReservationDate();
    final max = getMaxReservationDate();
    return isBetween(date, min, max);
  }

  /// Returns the name of the day of week.
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Returns the abbreviated name of the day of week.
  static String getDayNameShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// Returns the name of the month.
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// Returns the abbreviated name of the month.
  static String getMonthNameShort(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  /// Combines a date and time into a single [DateTime].
  static DateTime combineDateTime(DateTime date, DateTime time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  /// Returns current timestamp in milliseconds.
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Converts timestamp in milliseconds to [DateTime].
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Returns the age in years from a birth date.
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
