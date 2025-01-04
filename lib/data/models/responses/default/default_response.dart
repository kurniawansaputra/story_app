import 'package:json_annotation/json_annotation.dart';

part 'default_response.g.dart';

@JsonSerializable()
class DefaultResponse {
  final bool? error;
  final String? message;

  DefaultResponse({
    this.error,
    this.message,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultResponseToJson(this);
}
