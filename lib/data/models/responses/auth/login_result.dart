import 'package:json_annotation/json_annotation.dart';
part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> map) =>
      _$LoginResultFromJson(map);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
