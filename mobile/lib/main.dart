import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_reservation/app.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';

/// Application entry point.
///
/// Initializes the app and sets up error handling.
void main() {
  // Catch and log any errors during initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Set up error handlers
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.fatal(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Run the app wrapped in ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: RestaurantApp(),
    ),
  );

  AppLogger.info('Restaurant Reservation App started');
}
