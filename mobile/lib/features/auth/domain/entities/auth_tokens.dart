import 'package:equatable/equatable.dart';

/// Authentication tokens entity.
///
/// Contains access token and refresh token for API authentication.
class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  /// Returns true if both tokens are present.
  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty;

  /// Creates a copy of this tokens with the given fields replaced.
  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
