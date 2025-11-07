class AuthResponse {
  final String token;
  final String role;
  final int userId;
  final String username;

  AuthResponse({
    required this.token,
    required this.role,
    required this.userId,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      role: json['role'],
      userId: json['userId'],
      username: json['username'],
    );
  }
}

class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String role;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.email,
    this.role = 'USER',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'role': role,
    };
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
