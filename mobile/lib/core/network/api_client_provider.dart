import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_reservation/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

/// Provides [FlutterSecureStorage] instance.
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
}

/// Provides [ApiClient] instance.
///
/// This is the main HTTP client used throughout the app.
@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
}
