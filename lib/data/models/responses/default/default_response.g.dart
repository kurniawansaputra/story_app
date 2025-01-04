// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultResponse _$DefaultResponseFromJson(Map<String, dynamic> json) =>
    DefaultResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DefaultResponseToJson(DefaultResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
    };
