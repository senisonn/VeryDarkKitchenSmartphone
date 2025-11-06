import 'package:restaurant_reservation/core/constants/app_constants.dart';
import 'package:restaurant_reservation/core/constants/string_constants.dart';

/// Input validation utilities.
///
/// Provides validation functions for forms and user input.
class Validators {
  Validators._();

  /// Validates email address format.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emailRequired;
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return StringConstants.emailInvalid;
    }

    return null;
  }

  /// Validates password strength.
  ///
  /// Password must be at least 8 characters long and contain
  /// at least one letter and one number.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.passwordRequired;
    }

    if (value.length < 8) {
      return StringConstants.passwordTooShort;
    }

    final passwordRegex = RegExp(AppConstants.passwordPattern);
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }

    return null;
  }

  /// Validates password confirmation matches.
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return StringConstants.passwordRequired;
    }

    if (value != password) {
      return StringConstants.passwordsDoNotMatch;
    }

    return null;
  }

  /// Validates required text field.
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates phone number format.
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.phoneRequired;
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return StringConstants.phoneInvalid;
    }

    return null;
  }

  /// Validates minimum length.
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < length) {
      return '${fieldName ?? 'This field'} must be at least $length characters';
    }

    return null;
  }

  /// Validates maximum length.
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return '${fieldName ?? 'This field'} must not exceed $length characters';
    }

    return null;
  }

  /// Validates number of guests.
  static String? guests(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.guestsRequired;
    }

    final guests = int.tryParse(value);
    if (guests == null) {
      return 'Please enter a valid number';
    }

    if (guests < AppConstants.minGuests) {
      return 'Minimum ${AppConstants.minGuests} guest required';
    }

    if (guests > AppConstants.maxGuests) {
      return 'Maximum ${AppConstants.maxGuests} guests allowed';
    }

    return null;
  }

  /// Validates numeric input.
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a number';
    }

    return null;
  }

  /// Validates URL format.
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Combines multiple validators.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
