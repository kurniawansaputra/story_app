import 'package:json_annotation/json_annotation.dart';

import 'list_story.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  final bool? error;
  final String? message;
  final List<ListStory>? listStory;

  StoryResponse({
    this.error,
    this.message,
    this.listStory,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
