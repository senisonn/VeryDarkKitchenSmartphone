import 'package:dio/dio.dart';
import 'package:restaurant_reservation/core/utils/logger.dart';
import 'package:restaurant_reservation/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:restaurant_reservation/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/auth_tokens.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/user.dart';
import 'package:restaurant_reservation/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_reservation/shared/models/failure.dart';
import 'package:restaurant_reservation/shared/models/result.dart';

/// Implementation of [AuthRepository].
///
/// Coordinates between remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<(User, AuthTokens)>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      final user = response.user.toEntity();
      final tokens = AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Cache user and tokens locally
      await Future.wait([
        _localDataSource.saveUser(response.user),
        _localDataSource.saveTokens(tokens),
      ]);

      AppLogger.info('User logged in successfully: ${user.email}');

      return ResultHelper.success((user, tokens));
    } on DioException catch (e) {
      AppLogger.error('Login failed', error: e);
      return ResultHelper.failure(_handleDioError(e));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during login', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(
        UnexpectedFailure('Login failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<(User, AuthTokens)>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      final user = response.user.toEntity();
      final tokens = AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Cache user and tokens locally
      await Future.wait([
        _localDataSource.saveUser(response.user),
        _localDataSource.saveTokens(tokens),
      ]);

      AppLogger.info('User registered successfully: ${user.email}');

      return ResultHelper.success((user, tokens));
    } on DioException catch (e) {
      AppLogger.error('Registration failed', error: e);
      return ResultHelper.failure(_handleDioError(e));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during registration', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(
        UnexpectedFailure('Registration failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Try to logout on server (best effort - don't fail if it errors)
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        AppLogger.warning('Server logout failed (continuing anyway)', error: e);
      }

      // Clear local data
      await _localDataSource.clearAll();

      AppLogger.info('User logged out successfully');

      return ResultHelper.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error during logout', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(
        UnexpectedFailure('Logout failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final userModel = await _localDataSource.getUser();

      if (userModel == null) {
        return ResultHelper.success(null);
      }

      return ResultHelper.success(userModel.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current user', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<AuthTokens?>> getAuthTokens() async {
    try {
      final tokens = await _localDataSource.getTokens();
      return ResultHelper.success(tokens);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting auth tokens', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(const CacheFailure());
    }
  }

  @override
  Future<Result<AuthTokens>> refreshAccessToken() async {
    try {
      final currentTokens = await _localDataSource.getTokens();

      if (currentTokens == null) {
        return ResultHelper.failure(const TokenExpiredFailure());
      }

      final response = await _remoteDataSource.refreshToken(
        currentTokens.refreshToken,
      );

      final newTokens = AuthTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      await _localDataSource.saveTokens(newTokens);

      AppLogger.info('Access token refreshed successfully');

      return ResultHelper.success(newTokens);
    } on DioException catch (e) {
      AppLogger.error('Token refresh failed', error: e);
      // Clear tokens on refresh failure
      await _localDataSource.clearAll();
      return ResultHelper.failure(_handleDioError(e));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during token refresh', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(
        UnexpectedFailure('Token refresh failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final tokens = await _localDataSource.getTokens();
      return tokens != null && tokens.isValid;
    } catch (e) {
      AppLogger.error('Error checking authentication status', error: e);
      return false;
    }
  }

  @override
  Future<Result<User>> updateProfile({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final updatedUserModel = await _remoteDataSource.updateProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      // Update local cache
      await _localDataSource.saveUser(updatedUserModel);

      final user = updatedUserModel.toEntity();

      AppLogger.info('User profile updated successfully: ${user.id}');

      return ResultHelper.success(user);
    } on DioException catch (e) {
      AppLogger.error('Profile update failed', error: e);
      return ResultHelper.failure(_handleDioError(e));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during profile update', error: e, stackTrace: stackTrace);
      return ResultHelper.failure(
        UnexpectedFailure('Profile update failed: ${e.toString()}'),
      );
    }
  }

  /// Converts DioException to appropriate Failure type.
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          return _handleStatusCode(statusCode, error.response?.data);
        }
        return const ServerFailure();

      case DioExceptionType.cancel:
        return const CancelledFailure();

      case DioExceptionType.badCertificate:
        return const NetworkFailure('SSL certificate error');

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return const NetworkFailure();
        }
        return UnexpectedFailure(error.message ?? 'Unknown error');
    }
  }

  /// Handles HTTP status codes and converts to appropriate failures.
  Failure _handleStatusCode(int statusCode, dynamic data) {
    // Try to extract error message from response
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }

    switch (statusCode) {
      case 400:
        return ClientFailure(message ?? 'Invalid request');
      case 401:
        return InvalidCredentialsFailure(
          message ?? 'Invalid email or password',
        );
      case 403:
        return const PermissionFailure();
      case 404:
        return NotFoundFailure(message ?? 'Resource not found');
      case 422:
        return ValidationFailure(message ?? 'Validation error');
      case >= 500:
        return ServerFailure(message ?? 'Server error');
      default:
        return UnexpectedFailure(message ?? 'HTTP error: $statusCode');
    }
  }
}
