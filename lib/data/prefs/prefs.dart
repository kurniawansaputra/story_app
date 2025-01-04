import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/responses/auth/auth_response.dart';

class Prefs {
  static const String _authDataKey = 'auth_data';

  Future<void> saveAuthData(AuthResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data.toJson());
    await prefs.setString(_authDataKey, jsonData);
  }

  Future<AuthResponse?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_authDataKey);
    if (data != null) {
      try {
        final jsonData = jsonDecode(data) as Map<String, dynamic>;
        return AuthResponse.fromJson(jsonData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authDataKey);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_authDataKey);
  }
}
