import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_reservation/core/constants/api_constants.dart';
import 'package:restaurant_reservation/features/auth/data/models/user_model.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/auth_tokens.dart';

/// Local data source for authentication data.
///
/// Handles storage and retrieval of auth tokens and user data
/// using secure storage and shared preferences.
abstract class AuthLocalDataSource {
  /// Save auth tokens to secure storage.
  Future<void> saveTokens(AuthTokens tokens);

  /// Get auth tokens from secure storage.
  Future<AuthTokens?> getTokens();

  /// Clear auth tokens from storage.
  Future<void> clearTokens();

  /// Save user data to storage.
  Future<void> saveUser(UserModel user);

  /// Get user data from storage.
  Future<UserModel?> getUser();

  /// Clear user data from storage.
  Future<void> clearUser();

  /// Clear all auth-related data.
  Future<void> clearAll();
}

/// Implementation of [AuthLocalDataSource].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _secureStorage.write(
        key: ApiConstants.accessTokenKey,
        value: tokens.accessToken,
      ),
      _secureStorage.write(
        key: ApiConstants.refreshTokenKey,
        value: tokens.refreshToken,
      ),
    ]);
  }

  @override
  Future<AuthTokens?> getTokens() async {
    final results = await Future.wait([
      _secureStorage.read(key: ApiConstants.accessTokenKey),
      _secureStorage.read(key: ApiConstants.refreshTokenKey),
    ]);

    final accessToken = results[0];
    final refreshToken = results[1];

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: ApiConstants.accessTokenKey),
      _secureStorage.delete(key: ApiConstants.refreshTokenKey),
    ]);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.write(
      key: ApiConstants.userKey,
      value: userJson,
    );
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await _secureStorage.read(key: ApiConstants.userKey);

    if (userJson == null) {
      return null;
    }

    try {
      final json = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      // If parsing fails, clear corrupted data
      await clearUser();
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _secureStorage.delete(key: ApiConstants.userKey);
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      clearTokens(),
      clearUser(),
    ]);
  }
}
