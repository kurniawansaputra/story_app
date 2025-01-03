import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../data/api/api_service.dart';
import '../../data/models/responses/default_response_model.dart';

class ImageUploadProvider extends ChangeNotifier {
  final ApiService apiService;
  bool isUploading = false;
  String message = "";
  DefaultResponseModel? defaultResponse;

  ImageUploadProvider(this.apiService);

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      defaultResponse = null;
      isUploading = true;
      notifyListeners();

      final Either<String, DefaultResponseModel> result =
          await apiService.addNewStory(bytes, fileName, description);

      result.fold(
        (errorMessage) {
          message = errorMessage;
        },
        (response) {
          defaultResponse = response;
          message = defaultResponse?.message ?? "Success";
        },
      );

      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
