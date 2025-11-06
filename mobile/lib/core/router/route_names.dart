/// Route names for the application.
///
/// Centralizes all route paths for type-safe navigation.
class RouteNames {
  RouteNames._();

  // Root
  static const String root = '/';

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';

  // Menu Routes
  static const String menu = '/menu';
  static const String menuItem = '/menu/:id';

  // Reservation Routes
  static const String reservations = '/reservations';
  static const String newReservation = '/reservations/new';
  static const String reservationDetails = '/reservations/:id';
  static const String editReservation = '/reservations/:id/edit';

  // Back Office Routes
  static const String backOffice = '/back-office';
  static const String backOfficeReservations = '/back-office/reservations';
  static const String backOfficeReservationDetails =
      '/back-office/reservations/:id';

  // Utility Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String notFound = '/404';

  // Helper method to build menu item route
  static String menuItemRoute(String id) => '/menu/$id';

  // Helper method to build reservation details route
  static String reservationDetailsRoute(String id) => '/reservations/$id';

  // Helper method to build edit reservation route
  static String editReservationRoute(String id) => '/reservations/$id/edit';

  // Helper method to build back office reservation details route
  static String backOfficeReservationDetailsRoute(String id) =>
      '/back-office/reservations/$id';
}
