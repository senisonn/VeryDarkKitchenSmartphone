import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_reservation/core/constants/api_constants.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';

/// Interceptor to handle authentication tokens.
///
/// Automatically adds auth token to requests and handles token refresh.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  final FlutterSecureStorage secureStorage;
  final Dio dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/register endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from secure storage
    final accessToken = await secureStorage.read(
      key: ApiConstants.accessTokenKey,
    );

    if (accessToken != null) {
      options.headers[ApiConstants.authHeader] = 'Bearer $accessToken';
      AppLogger.debug('Added auth token to request: ${options.path}');
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      AppLogger.warning('Received 401, attempting token refresh');

      // Try to refresh token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry the original request
        try {
          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // Refresh failed, clear tokens and reject
        await _clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Checks if the endpoint is an auth endpoint that doesn't need token.
  bool _isAuthEndpoint(String path) {
    return path == ApiConstants.login ||
        path == ApiConstants.register ||
        path == ApiConstants.refreshToken;
  }

  /// Attempts to refresh the access token.
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.read(
        key: ApiConstants.refreshTokenKey,
      );

      if (refreshToken == null) {
        AppLogger.warning('No refresh token available');
        return false;
      }

      // Make refresh request without interceptor
      final response = await dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            ApiConstants.authHeader: 'Bearer $refreshToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data!['access_token'] as String?;
        final newRefreshToken = response.data!['refresh_token'] as String?;

        if (newAccessToken != null) {
          await secureStorage.write(
            key: ApiConstants.accessTokenKey,
            value: newAccessToken,
          );

          if (newRefreshToken != null) {
            await secureStorage.write(
              key: ApiConstants.refreshTokenKey,
              value: newRefreshToken,
            );
          }

          AppLogger.info('Token refreshed successfully');
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogger.error('Token refresh failed', error: e);
      return false;
    }
  }

  /// Retries the original request with new token.
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final accessToken = await secureStorage.read(
      key: ApiConstants.accessTokenKey,
    );

    if (accessToken != null) {
      requestOptions.headers[ApiConstants.authHeader] = 'Bearer $accessToken';
    }

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Clears stored tokens.
  Future<void> _clearTokens() async {
    await Future.wait([
      secureStorage.delete(key: ApiConstants.accessTokenKey),
      secureStorage.delete(key: ApiConstants.refreshTokenKey),
    ]);
    AppLogger.info('Tokens cleared');
  }
}
