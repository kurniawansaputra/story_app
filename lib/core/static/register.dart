import '../../data/models/responses/default/default_response.dart';

sealed class RegisterResultState {}

class RegisterNoneState extends RegisterResultState {}

class RegisterLoadingState extends RegisterResultState {}

class RegisterErrorState extends RegisterResultState {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterLoadedState extends RegisterResultState {
  final DefaultResponse data;

  RegisterLoadedState(this.data);
}
