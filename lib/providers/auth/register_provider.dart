import 'package:flutter/material.dart';

import '../../core/static/register.dart';
import '../../data/api/api_service.dart';
import '../../data/models/requests/register_request_model.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService _apiService;

  RegisterProvider(
    this._apiService,
  );

  RegisterResultState _resultState = RegisterNoneState();
  RegisterResultState get resultState => _resultState;

  Future<void> register(RegisterRequestModel registerRequest) async {
    try {
      _resultState = RegisterLoadingState();
      notifyListeners();

      final result = await _apiService.register(registerRequest);

      result.fold(
        (errorMessage) {
          _resultState = RegisterErrorState(errorMessage);
          notifyListeners();
        },
        (response) {
          _resultState = RegisterLoadedState(response);
          notifyListeners();
        },
      );
    } on Exception catch (e) {
      _resultState = RegisterErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _resultState = RegisterNoneState();
    notifyListeners();
  }
}
