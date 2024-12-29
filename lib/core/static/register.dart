import '../../data/models/responses/default_response_model.dart';

sealed class RegisterResultState {}

class RegisterNoneState extends RegisterResultState {}

class RegisterLoadingState extends RegisterResultState {}

class RegisterErrorState extends RegisterResultState {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterLoadedState extends RegisterResultState {
  final DefaultResponseModel data;

  RegisterLoadedState(this.data);
}
