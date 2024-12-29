import '../../data/models/responses/default_response_model.dart';

sealed class ImageUploadResultState {}

class ImageUploadNoneState extends ImageUploadResultState {}

class ImageUploadLoadingState extends ImageUploadResultState {}

class ImageUploadErrorState extends ImageUploadResultState {
  final String error;

  ImageUploadErrorState(this.error);
}

class ImageUploadLoadedState extends ImageUploadResultState {
  final DefaultResponseModel data;

  ImageUploadLoadedState(this.data);
}
