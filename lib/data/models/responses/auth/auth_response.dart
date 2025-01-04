import 'package:json_annotation/json_annotation.dart';

import 'login_result.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: "loginResult")
  final LoginResult loginResults;

  AuthResponse({
    required this.loginResults,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> map) =>
      _$AuthResponseFromJson(map);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
