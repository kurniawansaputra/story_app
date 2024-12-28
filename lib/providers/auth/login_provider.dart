import 'package:flutter/material.dart';

import '../../core/static/login.dart';
import '../../data/prefs/prefs.dart';
import '../../data/api/api_service.dart';
import '../../data/models/requests/login_request_model.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService _apiService;
  final Prefs _prefs;

  LoginProvider(
    this._apiService,
    this._prefs,
  );

  LoginResultState _resultState = LoginNoneState();
  LoginResultState get resultState => _resultState;

  Future<void> login(LoginRequestModel loginRequest) async {
    try {
      _resultState = LoginLoadingState();
      notifyListeners();

      final result = await _apiService.login(loginRequest);

      result.fold(
        (errorMessage) {
          _resultState = LoginErrorState(errorMessage);
          notifyListeners();
        },
        (authResponse) {
          _prefs.saveAuthData(authResponse);
          _resultState = LoginLoadedState(authResponse);
          notifyListeners();
        },
      );
    } on Exception catch (e) {
      _resultState = LoginErrorState(e.toString());
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _prefs.removeAuthData();
    _resultState = LoginNoneState();
    notifyListeners();
  }
}
