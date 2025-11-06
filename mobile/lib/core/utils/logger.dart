import 'package:logger/logger.dart';

/// Application logger utility.
///
/// Provides consistent logging throughout the app.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: _getLogLevel(),
  );

  /// Gets the log level based on build mode.
  static Level _getLogLevel() {
    // In production, set to Level.warning or Level.error
    // In development, set to Level.debug or Level.trace
    const isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction ? Level.warning : Level.debug;
  }

  /// Logs a debug message.
  ///
  /// Use for detailed information that is useful during development.
  static void debug(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  ///
  /// Use for general informational messages.
  static void info(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  ///
  /// Use for potentially harmful situations.
  static void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  ///
  /// Use for error events that might still allow the app to continue running.
  static void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal error message.
  ///
  /// Use for very severe error events that will presumably lead the app to abort.
  static void fatal(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a trace message.
  ///
  /// Use for very fine-grained informational events.
  static void trace(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Logs API request details.
  static void logApiRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) {
    info(
      '''
API Request:
  Method: $method
  Endpoint: $endpoint
  ${data != null ? 'Data: $data' : ''}
  ${headers != null ? 'Headers: $headers' : ''}
''',
    );
  }

  /// Logs API response details.
  static void logApiResponse(
    int statusCode,
    String endpoint, {
    dynamic data,
  }) {
    info(
      '''
API Response:
  Status: $statusCode
  Endpoint: $endpoint
  ${data != null ? 'Data: $data' : ''}
''',
    );
  }

  /// Logs API error details.
  static void logApiError(
    String endpoint,
    dynamic error, {
    StackTrace? stackTrace,
  }) {
    AppLogger.error(
      '''
API Error:
  Endpoint: $endpoint
  Error: $error
''',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs navigation events.
  static void logNavigation(String from, String to) {
    debug('Navigation: $from -> $to');
  }

  /// Logs authentication events.
  static void logAuth(String event, {String? userId}) {
    info('Auth Event: $event${userId != null ? ' (User: $userId)' : ''}');
  }

  /// Logs business logic events.
  static void logBusiness(String event, {Map<String, dynamic>? details}) {
    info(
      '''
Business Event: $event
  ${details != null ? 'Details: $details' : ''}
''',
    );
  }
}
