import 'package:restaurant_reservation/features/auth/domain/entities/auth_tokens.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/user.dart';
import 'package:restaurant_reservation/shared/models/result.dart';

/// Abstract repository for authentication operations.
///
/// Defines the contract for authentication data access.
/// Implementations should handle API calls, token storage, etc.
abstract class AuthRepository {
  /// Login with email and password.
  ///
  /// Returns [User] and [AuthTokens] on success, [Failure] on error.
  Future<Result<(User, AuthTokens)>> login({
    required String email,
    required String password,
  });

  /// Register a new user account.
  ///
  /// Returns [User] and [AuthTokens] on success, [Failure] on error.
  Future<Result<(User, AuthTokens)>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  });

  /// Logout the current user.
  ///
  /// Clears tokens and user data from storage.
  Future<Result<void>> logout();

  /// Get the currently authenticated user.
  ///
  /// Returns cached user data if available.
  Future<Result<User?>> getCurrentUser();

  /// Get current auth tokens.
  ///
  /// Returns cached tokens if available.
  Future<Result<AuthTokens?>> getAuthTokens();

  /// Refresh the access token using refresh token.
  ///
  /// Returns new [AuthTokens] on success, [Failure] on error.
  Future<Result<AuthTokens>> refreshAccessToken();

  /// Check if user is authenticated.
  ///
  /// Returns true if valid tokens exist.
  Future<bool> isAuthenticated();

  /// Update user profile.
  Future<Result<User>> updateProfile({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
  });
}
