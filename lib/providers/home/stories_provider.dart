import 'package:flutter/material.dart';

import '../../core/static/stories.dart';
import '../../data/api/api_service.dart';
import '../../data/models/responses/stories/list_story.dart';

class StoriesProvider extends ChangeNotifier {
  final ApiService _apiService;

  StoriesProvider(this._apiService);

  StoriesResultState storiesState = StoriesNoneState();
  String storiesMessage = "";
  bool storiesError = false;

  List<ListStory> stories = [];

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> getStories({int? location}) async {
    try {
      if (pageItems == 1) {
        storiesState = StoriesLoadingState();
        notifyListeners();
      }

      final result = await _apiService.getStories(
        page: pageItems!,
        size: sizeItems,
        location: location,
      );

      result.fold(
        (errorMessage) {
          storiesMessage = errorMessage;
          storiesError = true;
          storiesState = StoriesErrorState(errorMessage);
        },
        (response) {
          final newStories = response.listStory ?? [];
          stories.addAll(newStories);

          if (newStories.length < sizeItems) {
            pageItems = null;
          } else {
            pageItems = pageItems! + 1;
          }

          storiesMessage = "Success";
          storiesError = false;
          storiesState = StoriesLoadedState(stories);
        },
      );

      notifyListeners();
    } catch (e) {
      storiesMessage = e.toString();
      storiesError = true;
      storiesState = StoriesErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetStories() {
    stories = [];
    pageItems = 1;
    storiesState = StoriesNoneState();
    notifyListeners();
  }
}
