import 'dart:io';

import 'package:dio/dio.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';
import 'package:restaurant_reservation/shared/models/failure.dart';

/// Interceptor to handle errors and convert them to Failures.
///
/// Provides consistent error handling across all API calls.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.message}',
      error: err,
      stackTrace: err.stackTrace,
    );

    final failure = _handleError(err);

    // Create a new DioException with the failure message
    final exception = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      message: failure.message,
    );

    handler.next(exception);
  }

  /// Converts DioException to appropriate Failure.
  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const CancelledFailure();

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return const NetworkFailure('Connection error occurred');

      case DioExceptionType.badCertificate:
        return const ServerFailure('SSL certificate error');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return UnexpectedFailure(
          error.message ?? 'An unexpected error occurred',
        );
    }
  }

  /// Handles HTTP response errors based on status code.
  Failure _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerFailure('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Try to extract error message from response
    String? errorMessage;
    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }

    switch (statusCode) {
      case 400:
        return ClientFailure(
          errorMessage ?? 'Bad request. Please check your input.',
        );

      case 401:
        return const AuthFailure(
          'Authentication failed. Please login again.',
        );

      case 403:
        return const PermissionFailure(
          'You do not have permission to perform this action.',
        );

      case 404:
        return NotFoundFailure(
          errorMessage ?? 'The requested resource was not found.',
        );

      case 409:
        return ClientFailure(
          errorMessage ?? 'Conflict. The resource already exists.',
        );

      case 422:
        // Validation errors
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>?;
          if (errors != null) {
            final validationErrors = errors.map(
              (key, value) => MapEntry(
                key,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              ),
            );
            return ValidationFailure.withErrors(validationErrors);
          }
        }
        return ValidationFailure(
          errorMessage ?? 'Validation failed. Please check your input.',
        );

      case 429:
        return const ClientFailure(
          'Too many requests. Please try again later.',
        );

      case 500:
        return ServerFailure(
          errorMessage ?? 'Internal server error. Please try again later.',
        );

      case 502:
        return const ServerFailure('Bad gateway. Please try again later.');

      case 503:
        return const ServerFailure(
          'Service unavailable. Please try again later.',
        );

      case 504:
        return const ServerFailure('Gateway timeout. Please try again later.');

      default:
        if (statusCode >= 500) {
          return ServerFailure.withStatusCode(statusCode);
        } else if (statusCode >= 400) {
          return ClientFailure.withStatusCode(
            statusCode,
            detail: errorMessage,
          );
        }
        return UnexpectedFailure(
          errorMessage ?? 'An unexpected error occurred (Status: $statusCode)',
        );
    }
  }
}
