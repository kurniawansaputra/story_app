import '../../data/models/responses/auth/auth_response.dart';

sealed class LoginResultState {}

class LoginNoneState extends LoginResultState {}

class LoginLoadingState extends LoginResultState {}

class LoginErrorState extends LoginResultState {
  final String error;

  LoginErrorState(this.error);
}

class LoginLoadedState extends LoginResultState {
  final AuthResponse data;

  LoginLoadedState(this.data);
}
