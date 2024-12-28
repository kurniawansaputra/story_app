import 'package:story_app/data/models/responses/auth_response_model.dart';

sealed class LoginResultState {}

class LoginNoneState extends LoginResultState {}

class LoginLoadingState extends LoginResultState {}

class LoginErrorState extends LoginResultState {
  final String error;

  LoginErrorState(this.error);
}

class LoginLoadedState extends LoginResultState {
  final AuthResponseModel data;

  LoginLoadedState(this.data);
}
