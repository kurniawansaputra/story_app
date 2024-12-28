import '../../data/models/responses/story_detail_response_model.dart';

sealed class StoryDetailResultState {}

class StoryDetailNoneState extends StoryDetailResultState {}

class StoryDetailLoadingState extends StoryDetailResultState {}

class StoryDetailErrorState extends StoryDetailResultState {
  final String error;

  StoryDetailErrorState(this.error);
}

class StoryDetailLoadedState extends StoryDetailResultState {
  final StoryDetailResponseModel data;

  StoryDetailLoadedState(this.data);
}
