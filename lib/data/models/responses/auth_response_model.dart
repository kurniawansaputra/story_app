import 'dart:convert';

class AuthResponseModel {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  AuthResponseModel({
    this.error,
    this.message,
    this.loginResult,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        error: json["error"],
        message: json["message"],
        loginResult: json["loginResult"] == null
            ? null
            : LoginResult.fromMap(json["loginResult"]),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "loginResult": loginResult?.toMap(),
      };
}

class LoginResult {
  final String? userId;
  final String? name;
  final String? token;

  LoginResult({
    this.userId,
    this.name,
    this.token,
  });

  factory LoginResult.fromJson(String str) =>
      LoginResult.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResult.fromMap(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "name": name,
        "token": token,
      };
}
