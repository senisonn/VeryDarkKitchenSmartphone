import 'package:dio/dio.dart';
import 'package:restaurant_reservation/core/constants/api_constants.dart';
import 'package:restaurant_reservation/features/auth/data/models/auth_response_model.dart';
import 'package:restaurant_reservation/features/auth/data/models/user_model.dart';

/// Remote data source for authentication operations.
///
/// Handles all API calls related to authentication.
abstract class AuthRemoteDataSource {
  /// Login with email and password.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Register a new user.
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  });

  /// Logout current user.
  Future<void> logout();

  /// Refresh access token.
  Future<AuthResponseModel> refreshToken(String refreshToken);

  /// Get current user profile.
  Future<UserModel> getProfile();

  /// Update user profile.
  Future<UserModel> updateProfile({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
  });
}

/// Implementation of [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      },
    );

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<void> logout() async {
    await _dio.post<void>(ApiConstants.logout);
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiConstants.profile);

    return UserModel.fromJson(response.data!);
  }

  @override
  Future<UserModel> updateProfile({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phone != null) data['phone'] = phone;

    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.profile,
      data: data,
    );

    return UserModel.fromJson(response.data!);
  }
}
