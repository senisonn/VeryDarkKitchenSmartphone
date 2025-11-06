import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_reservation/features/auth/data/models/user_model.dart';

part 'auth_response_model.g.dart';

/// Data model for authentication response.
///
/// Contains user data and authentication tokens from API.
@JsonSerializable()
class AuthResponseModel {
  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  final UserModel user;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
