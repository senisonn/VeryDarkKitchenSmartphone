import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_reservation/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

/// Data model for User entity.
///
/// Handles JSON serialization/deserialization for API communication.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.role = 'customer',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  final String role;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Converts this model to a domain entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: UserRole.fromString(role),
    );
  }

  /// Creates a model from a domain entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      role: user.role.value,
    );
  }
}
