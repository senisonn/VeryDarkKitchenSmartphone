import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Uses sealed class pattern for exhaustive handling.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Please check your connection.']);
}

/// Failure due to server errors (5xx).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again later.']);

  factory ServerFailure.withStatusCode(int statusCode) {
    return ServerFailure('Server error: $statusCode');
  }
}

/// Failure due to client errors (4xx).
class ClientFailure extends Failure {
  const ClientFailure([super.message = 'Request failed. Please check your input.']);

  factory ClientFailure.withStatusCode(int statusCode, {String? detail}) {
    return ClientFailure(
      detail ?? 'Client error: $statusCode',
    );
  }
}

/// Failure due to authentication/authorization issues.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please login again.']);
}

/// Failure due to invalid credentials.
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([super.message = 'Invalid email or password.']);
}

/// Failure due to expired token.
class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure([super.message = 'Session expired. Please login again.']);
}

/// Failure due to validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Please check your input.']);

  factory ValidationFailure.withErrors(Map<String, List<String>> errors) {
    final errorMessages = errors.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('\n');
    return ValidationFailure(errorMessages);
  }
}

/// Failure when resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

/// Failure due to timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout. Please try again.']);
}

/// Failure due to data parsing errors.
class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to process data.']);
}

/// Failure due to storage/cache errors.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to access local storage.']);
}

/// Failure due to permission issues.
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}

/// Failure when operation is cancelled by user.
class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Operation cancelled.']);
}

/// Generic unexpected failure.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);

  factory UnexpectedFailure.fromException(Exception exception) {
    return UnexpectedFailure(exception.toString());
  }

  factory UnexpectedFailure.fromError(Error error) {
    return UnexpectedFailure(error.toString());
  }
}

/// Converts exceptions to appropriate Failure types.
class FailureConverter {
  FailureConverter._();

  /// Converts any exception/error to a Failure.
  static Failure fromException(dynamic exception) {
    if (exception is Failure) {
      return exception;
    }

    // Handle specific exception types
    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('NetworkException')) {
      return const NetworkFailure();
    }

    if (exception.toString().contains('TimeoutException')) {
      return const TimeoutFailure();
    }

    if (exception.toString().contains('FormatException')) {
      return const ParseFailure();
    }

    // Default to unexpected failure
    if (exception is Exception) {
      return UnexpectedFailure.fromException(exception);
    }

    if (exception is Error) {
      return UnexpectedFailure.fromError(exception);
    }

    return UnexpectedFailure(exception.toString());
  }

  /// Converts HTTP status code to appropriate Failure.
  static Failure fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return ClientFailure(message ?? 'Bad request');
      case 401:
        return const AuthFailure();
      case 403:
        return const PermissionFailure();
      case 404:
        return const NotFoundFailure();
      case 422:
        return ValidationFailure(message ?? 'Validation error');
      case >= 500 && < 600:
        return ServerFailure(message ?? 'Server error');
      default:
        return UnexpectedFailure(
          message ?? 'HTTP error: $statusCode',
        );
    }
  }
}
