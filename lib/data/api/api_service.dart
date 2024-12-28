import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../models/requests/login_request_model.dart';
import '../models/requests/register_request_model.dart';
import '../models/responses/auth_response_model.dart';
import '../models/responses/story_detail_response_model.dart';
import '../models/responses/story_response_model.dart';
import '../prefs/prefs.dart';

class ApiService {
  Future<Either<String, AuthResponseModel>> login(
      LoginRequestModel loginRequestModel) async {
    try {
      final url = Uri.parse('${Variables.baseUrl}/login');
      final header = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      final body = jsonEncode(loginRequestModel.toJson());

      final response = await http.post(
        url,
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromJson(response.body));
      } else {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorJson['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  Future<Either<String, AuthResponseModel>> register(
      RegisterRequestModel registerRequestModel) async {
    try {
      final url = Uri.parse('${Variables.baseUrl}/register');
      final header = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      final body = jsonEncode(registerRequestModel.toJson());

      final response = await http.post(
        url,
        headers: header,
        body: body,
      );

      if (response.statusCode == 201) {
        return Right(AuthResponseModel.fromJson(response.body));
      } else {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorJson['message'] ?? 'Unknown error occurred';
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  Future<Either<String, StoryResponseModel>> getStories({
    int? page,
    int? size,
    int? location,
  }) async {
    try {
      final authData = await Prefs().getAuthData();

      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (size != null) 'size': size.toString(),
        if (location != null) 'location': location.toString(),
      };

      final url = Uri.parse('${Variables.baseUrl}/stories')
          .replace(queryParameters: queryParameters);

      final header = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData?.loginResult?.token}',
      };

      final response = await http.get(
        url,
        headers: header,
      );

      if (response.statusCode == 200) {
        return Right(StoryResponseModel.fromJson((response.body)));
      } else {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorJson['message'] ?? 'Unknown error occurred';
        return Left(errorMessage is String ? errorMessage : 'Unknown error');
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  Future<Either<String, StoryDetailResponseModel>> getStoryDetail(
      String id) async {
    try {
      final authData = await Prefs().getAuthData();

      final url = Uri.parse('${Variables.baseUrl}/stories/$id');

      final header = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData?.loginResult?.token}',
      };

      final response = await http.get(
        url,
        headers: header,
      );

      if (response.statusCode == 200) {
        return Right(StoryDetailResponseModel.fromJson((response.body)));
      } else {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorJson['message'] ?? 'Unknown error occurred';
        return Left(errorMessage is String ? errorMessage : 'Unknown error');
      }
    } catch (e) {
      return Left('Exception: $e');
    }
  }
}