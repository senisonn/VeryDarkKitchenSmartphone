import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:restaurant_reservation/core/constants/api_constants.dart';
import 'package:restaurant_reservation/core/network/auth_interceptor.dart';
import 'package:restaurant_reservation/core/network/error_interceptor.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';

/// HTTP client for making API requests.
///
/// Configures Dio with interceptors for auth, logging, and error handling.
class ApiClient {
  ApiClient({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  final FlutterSecureStorage _secureStorage;
  late final Dio _dio;

  /// Base options for Dio.
  BaseOptions get _baseOptions => BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
          ApiConstants.acceptHeader: ApiConstants.applicationJson,
        },
        validateStatus: (status) {
          // Accept all status codes and handle in interceptor
          return status != null && status < 500;
        },
      );

  /// Sets up interceptors for auth, logging, and error handling.
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Auth interceptor (must be first)
      AuthInterceptor(secureStorage: _secureStorage, dio: _dio),

      // Pretty logger (development only)
      if (!const bool.fromEnvironment('dart.vm.product'))
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),

      // Error interceptor (must be last)
      ErrorInterceptor(),
    ]);
  }

  /// Public getter for Dio instance.
  Dio get dio => _dio;

  /// GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      AppLogger.logApiRequest('GET', path);
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.logApiResponse(response.statusCode ?? 0, path, data: response.data);
      return response;
    } catch (e) {
      AppLogger.logApiError(path, e);
      rethrow;
    }
  }

  /// POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      AppLogger.logApiRequest('POST', path, data: data as Map<String, dynamic>?);
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.logApiResponse(response.statusCode ?? 0, path, data: response.data);
      return response;
    } catch (e) {
      AppLogger.logApiError(path, e);
      rethrow;
    }
  }

  /// PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      AppLogger.logApiRequest('PUT', path, data: data as Map<String, dynamic>?);
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.logApiResponse(response.statusCode ?? 0, path, data: response.data);
      return response;
    } catch (e) {
      AppLogger.logApiError(path, e);
      rethrow;
    }
  }

  /// PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      AppLogger.logApiRequest('PATCH', path, data: data as Map<String, dynamic>?);
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      AppLogger.logApiResponse(response.statusCode ?? 0, path, data: response.data);
      return response;
    } catch (e) {
      AppLogger.logApiError(path, e);
      rethrow;
    }
  }

  /// DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      AppLogger.logApiRequest('DELETE', path);
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      AppLogger.logApiResponse(response.statusCode ?? 0, path);
      return response;
    } catch (e) {
      AppLogger.logApiError(path, e);
      rethrow;
    }
  }

  /// Downloads a file.
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } catch (e) {
      AppLogger.logApiError(urlPath, e);
      rethrow;
    }
  }
}
