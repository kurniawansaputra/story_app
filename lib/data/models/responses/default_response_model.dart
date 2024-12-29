import 'dart:convert';

class DefaultResponseModel {
  final bool? error;
  final String? message;

  DefaultResponseModel({
    this.error,
    this.message,
  });

  factory DefaultResponseModel.fromJson(String str) =>
      DefaultResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DefaultResponseModel.fromMap(Map<String, dynamic> json) =>
      DefaultResponseModel(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
      };
}
