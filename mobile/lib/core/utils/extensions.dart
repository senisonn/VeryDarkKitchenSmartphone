import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_reservation/core/constants/string_constants.dart';

/// Extension methods for [String].
extension StringExtensions on String {
  /// Capitalizes first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes first letter of each word.
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email.
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid phone number.
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(this);
  }

  /// Checks if string is a valid URL.
  bool get isValidUrl {
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlPattern.hasMatch(this);
  }

  /// Truncates string to specified length with ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Removes all whitespace from string.
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Checks if string is numeric.
  bool get isNumeric {
    return int.tryParse(this) != null || double.tryParse(this) != null;
  }

  /// Converts string to integer safely.
  int? toIntOrNull() => int.tryParse(this);

  /// Converts string to double safely.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Checks if string is empty or only contains whitespace.
  bool get isBlank => trim().isEmpty;

  /// Checks if string is not empty and not only whitespace.
  bool get isNotBlank => trim().isNotEmpty;
}

/// Extension methods for [DateTime].
extension DateTimeExtensions on DateTime {
  /// Formats date as 'dd/MM/yyyy'.
  String toDateString() => DateFormat(StringConstants.dateFormat).format(this);

  /// Formats time as 'HH:mm'.
  String toTimeString() => DateFormat(StringConstants.timeFormat).format(this);

  /// Formats date and time as 'dd/MM/yyyy HH:mm'.
  String toDateTimeString() =>
      DateFormat(StringConstants.dateTimeFormat).format(this);

  /// Checks if date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Checks if date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Checks if date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Returns date at start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns date at end of day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Returns difference in days from now.
  int get daysFromNow => difference(DateTime.now()).inDays;

  /// Returns relative date string (Today, Tomorrow, Yesterday, or date).
  String toRelativeDateString() {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    if (isYesterday) return 'Yesterday';
    return toDateString();
  }

  /// Adds business days (excluding weekends).
  DateTime addBusinessDays(int days) {
    var result = this;
    var daysToAdd = days;

    while (daysToAdd > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        daysToAdd--;
      }
    }

    return result;
  }

  /// Checks if date is a weekend.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Checks if date is a weekday.
  bool get isWeekday => !isWeekend;

  /// Formats date with custom pattern.
  String format(String pattern) => DateFormat(pattern).format(this);
}

/// Extension methods for [BuildContext].
extension BuildContextExtensions on BuildContext {
  /// Returns the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Returns the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Returns the current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen size.
  Size get screenSize => mediaQuery.size;

  /// Returns the screen width.
  double get screenWidth => screenSize.width;

  /// Returns the screen height.
  double get screenHeight => screenSize.height;

  /// Returns the screen padding (safe area insets).
  EdgeInsets get screenPadding => mediaQuery.padding;

  /// Returns the bottom inset (for keyboard).
  double get bottomInset => mediaQuery.viewInsets.bottom;

  /// Checks if keyboard is visible.
  bool get isKeyboardVisible => bottomInset > 0;

  /// Checks if device is in portrait mode.
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Checks if device is in landscape mode.
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Checks if device is a mobile phone.
  bool get isMobile => screenWidth < 600;

  /// Checks if device is a tablet.
  bool get isTablet => screenWidth >= 600 && screenWidth < 960;

  /// Checks if device is a desktop.
  bool get isDesktop => screenWidth >= 960;

  /// Shows a [SnackBar] with the given message.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Shows an error [SnackBar].
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }

  /// Shows a success [SnackBar].
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Hides the keyboard.
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Requests focus for the next field.
  void nextFocus() {
    FocusScope.of(this).nextFocus();
  }

  /// Requests focus for the previous field.
  void previousFocus() {
    FocusScope.of(this).previousFocus();
  }

  /// Returns true if the current theme is dark.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Returns true if the current theme is light.
  bool get isLightMode => theme.brightness == Brightness.light;
}

/// Extension methods for [int].
extension IntExtensions on int {
  /// Formats integer as currency.
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(0)}';
  }

  /// Returns pluralized string based on count.
  String pluralize(String singular, String plural) {
    return this == 1 ? singular : plural;
  }

  /// Converts minutes to duration string (e.g., "1h 30m").
  String toDurationString() {
    final hours = this ~/ 60;
    final minutes = this % 60;

    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}

/// Extension methods for [double].
extension DoubleExtensions on double {
  /// Formats double as currency with 2 decimal places.
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Rounds to specified decimal places.
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }
}

/// Extension methods for [List].
extension ListExtensions<T> on List<T> {
  /// Returns the first element or null if list is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if list is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Groups list elements by a key selector.
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Returns a new list with distinct elements.
  List<T> distinct() => toSet().toList();

  /// Returns a new list with distinct elements by a key selector.
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((element) {
      final key = keySelector(element);
      if (seen.contains(key)) {
        return false;
      }
      seen.add(key);
      return true;
    }).toList();
  }
}

/// Extension methods for nullable types.
extension NullableExtensions<T> on T? {
  /// Returns the value or a default if null.
  T orDefault(T defaultValue) => this ?? defaultValue;

  /// Executes a function if value is not null.
  R? let<R>(R Function(T) transform) {
    final value = this;
    return value != null ? transform(value) : null;
  }
}
