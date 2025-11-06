/// Application-wide constants.
///
/// Contains app configuration, business rules, and default values.
class AppConstants {
  AppConstants._();

  /// Application name
  static const String appName = 'Restaurant Reservation';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Maximum number of guests per reservation
  static const int maxGuests = 20;

  /// Minimum number of guests per reservation
  static const int minGuests = 1;

  /// Default number of guests
  static const int defaultGuests = 2;

  /// Reservation slot duration in minutes
  static const int slotDurationMinutes = 30;

  /// Minimum advance booking time in hours
  static const int minAdvanceBookingHours = 2;

  /// Maximum advance booking time in days
  static const int maxAdvanceBookingDays = 90;

  /// Restaurant opening hour
  static const int openingHour = 11;

  /// Restaurant closing hour
  static const int closingHour = 23;

  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// Debounce duration for search
  static const Duration debounceDuration = Duration(milliseconds: 500);

  /// Pagination
  static const int defaultPageSize = 20;

  /// Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(minutes: 30);
  static const Duration longCacheDuration = Duration(hours: 24);

  /// Regex patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$';

  /// Reservation statuses
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusRefused = 'refused';
  static const String statusCompleted = 'completed';

  /// User roles
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
  static const String roleHost = 'host';

  /// Error messages timeout
  static const Duration errorDisplayDuration = Duration(seconds: 3);

  /// Success messages timeout
  static const Duration successDisplayDuration = Duration(seconds: 2);
}
