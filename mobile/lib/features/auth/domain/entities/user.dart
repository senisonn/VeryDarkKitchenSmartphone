import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user.
///
/// This is a domain model that represents the core user data
/// independent of any external data source.
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.role = UserRole.customer,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final UserRole role;

  /// Returns the full name of the user.
  String get fullName => '$firstName $lastName';

  /// Returns true if the user is an admin.
  bool get isAdmin => role == UserRole.admin;

  /// Returns true if the user is a customer.
  bool get isCustomer => role == UserRole.customer;

  /// Creates a copy of this user with the given fields replaced.
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, phone, role];
}

/// User role enumeration.
enum UserRole {
  customer('customer'),
  admin('admin');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.customer,
    );
  }
}
