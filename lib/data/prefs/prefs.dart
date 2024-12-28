import 'package:shared_preferences/shared_preferences.dart';

import '../models/responses/auth_response_model.dart';

class Prefs {
  Future<void> saveAuthData(AuthResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', data.toJson());
  }

  Future<AuthResponseModel?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }
}
