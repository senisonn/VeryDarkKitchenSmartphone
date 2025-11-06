/// String constants for UI text.
///
/// Centralizes all user-facing strings for easy localization.
class StringConstants {
  StringConstants._();

  // General
  static const String appName = 'Restaurant Reservation';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';

  // Authentication
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phone = 'Phone';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String profile = 'Profile';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Please enter a valid phone number';
  static const String guestsRequired = 'Number of guests is required';
  static const String dateRequired = 'Please select a date';
  static const String timeRequired = 'Please select a time';

  // Menu
  static const String menu = 'Menu';
  static const String menuTitle = 'Our Menu';
  static const String categories = 'Categories';
  static const String allCategories = 'All';
  static const String viewDetails = 'View Details';
  static const String noMenuItems = 'No menu items available';

  // Reservations
  static const String reservations = 'Reservations';
  static const String myReservations = 'My Reservations';
  static const String newReservation = 'New Reservation';
  static const String makeReservation = 'Make a Reservation';
  static const String editReservation = 'Edit Reservation';
  static const String cancelReservation = 'Cancel Reservation';
  static const String reservationDetails = 'Reservation Details';
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time';
  static const String numberOfGuests = 'Number of Guests';
  static const String guests = 'Guests';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String specialRequests = 'Special Requests';
  static const String reservationConfirmed = 'Reservation Confirmed!';
  static const String reservationCancelled = 'Reservation Cancelled';
  static const String noReservations = 'No reservations found';
  static const String noAvailableSlots = 'No available time slots';
  static const String availableSlots = 'Available Time Slots';

  // Reservation Status
  static const String statusPending = 'Pending';
  static const String statusConfirmed = 'Confirmed';
  static const String statusCancelled = 'Cancelled';
  static const String statusRefused = 'Refused';
  static const String statusCompleted = 'Completed';

  // Back Office
  static const String backOffice = 'Back Office';
  static const String dashboard = 'Dashboard';
  static const String allReservations = 'All Reservations';
  static const String validate = 'Validate';
  static const String refuse = 'Refuse';
  static const String filterByStatus = 'Filter by Status';
  static const String filterByDate = 'Filter by Date';
  static const String searchReservations = 'Search Reservations';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String notFoundError = 'Resource not found.';
  static const String validationError = 'Please check your input.';
  static const String loginError = 'Invalid email or password.';
  static const String registerError = 'Registration failed. Please try again.';
  static const String reservationError =
      'Failed to create reservation. Please try again.';
  static const String cancelError =
      'Failed to cancel reservation. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully!';
  static const String reservationSuccess = 'Reservation created successfully!';
  static const String cancelSuccess = 'Reservation cancelled successfully!';
  static const String updateSuccess = 'Updated successfully!';
  static const String validationSuccess = 'Reservation validated!';
  static const String refusalSuccess = 'Reservation refused!';

  // Dialog Titles
  static const String confirmCancellation = 'Confirm Cancellation';
  static const String confirmValidation = 'Confirm Validation';
  static const String confirmRefusal = 'Confirm Refusal';

  // Dialog Messages
  static const String cancelReservationMessage =
      'Are you sure you want to cancel this reservation?';
  static const String validateReservationMessage =
      'Are you sure you want to validate this reservation?';
  static const String refuseReservationMessage =
      'Are you sure you want to refuse this reservation?';

  // Empty States
  static const String noData = 'No data available';
  static const String emptyList = 'List is empty';
  static const String noResults = 'No results found';

  // Time Formats
  static const String timeFormat = 'HH:mm';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}
