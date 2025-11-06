/// API configuration constants for the restaurant reservation app.
///
/// Contains all API endpoints, base URLs, and configuration values.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API (Development)
  static const String baseUrlDev = 'https://api-dev.restaurant.com';

  /// Base URL for the API (Production)
  static const String baseUrlProd = 'https://api.restaurant.com';

  /// Current base URL based on environment
  static const String baseUrl = baseUrlDev;

  /// API version
  static const String apiVersion = 'v1';

  /// Connection timeout in milliseconds
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout in milliseconds
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Menu Endpoints
  static const String menu = '/menu';
  static const String menuCategories = '/menu/categories';
  static String menuItem(String id) => '/menu/$id';

  // Reservation Endpoints
  static const String reservations = '/reservations';
  static String reservation(String id) => '/reservations/$id';
  static const String myReservations = '/reservations/my';
  static const String availableSlots = '/reservations/available-slots';
  static String cancelReservation(String id) => '/reservations/$id/cancel';
  static String validateReservation(String id) => '/reservations/$id/validate';
  static String refuseReservation(String id) => '/reservations/$id/refuse';

  // Back Office Endpoints
  static const String allReservations = '/back-office/reservations';
  static const String reservationStats = '/back-office/stats';
  static String reservationDetails(String id) =>
      '/back-office/reservations/$id';

  // Headers
  static const String authHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String applicationJson = 'application/json';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';
}
