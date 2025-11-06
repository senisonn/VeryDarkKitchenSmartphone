import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_reservation/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:restaurant_reservation/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:restaurant_reservation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/user.dart';
import 'package:restaurant_reservation/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Provides the FlutterSecureStorage instance.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
}

/// Provides the local data source for authentication.
@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(AuthLocalDataSourceRef ref) {
  return AuthLocalDataSourceImpl(ref.watch(secureStorageProvider));
}

/// Provides the remote data source for authentication.
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  // Get Dio instance from network module
  final dio = Dio(); // TODO: Replace with proper Dio provider
  return AuthRemoteDataSourceImpl(dio);
}

/// Provides the authentication repository.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

/// Provides the current authenticated user.
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    // Load user from cache on app start
    final result = await ref.watch(authRepositoryProvider).getCurrentUser();

    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
        );

    result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        final (user, _) = data;
        state = AsyncData(user);
      },
    );
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final result = await ref.read(authRepositoryProvider).register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );

    result.fold(
      (failure) => throw Exception(failure.message),
      (data) {
        final (user, _) = data;
        state = AsyncData(user);
      },
    );
  }

  /// Logout the current user.
  Future<void> logout() async {
    final result = await ref.read(authRepositoryProvider).logout();

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => state = const AsyncData(null),
    );
  }

  /// Update user profile.
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final result = await ref.read(authRepositoryProvider).updateProfile(
          id: currentUser.id,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );

    result.fold(
      (failure) => throw Exception(failure.message),
      (user) => state = AsyncData(user),
    );
  }

  /// Check if user is authenticated.
  bool get isAuthenticated => state.value != null;

  /// Check if user is admin.
  bool get isAdmin => state.value?.isAdmin ?? false;
}
