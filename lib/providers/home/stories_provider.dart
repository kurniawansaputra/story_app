import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';

import '../../core/static/stories.dart';

class StoriesProvider extends ChangeNotifier {
  final ApiService _apiService;

  StoriesProvider(
    this._apiService,
  );

  StoriesResultState _resultState = StoriesNoneState();

  StoriesResultState get resultState => _resultState;

  Future<void> getStories({
    int? page,
    int? size,
    int? location,
  }) async {
    try {
      _resultState = StoriesLoadingState();
      notifyListeners();

      final result = await _apiService.getStories(
        page: page,
        size: size,
        location: location,
      );

      result.fold(
        (errorMessage) {
          _resultState = StoriesErrorState(errorMessage);
          notifyListeners();
        },
        (response) {
          _resultState = StoriesLoadedState(response.listStory ?? []);
          notifyListeners();
        },
      );
    } on Exception catch (e) {
      _resultState = StoriesErrorState(e.toString());
      notifyListeners();
    }
  }
}
