import 'package:json_annotation/json_annotation.dart';

import 'story.dart';

part 'story_detail_response.g.dart';

@JsonSerializable()
class StoryDetailResponse {
  final bool? error;
  final String? message;
  @JsonKey(name: "story")
  final Story? story;

  StoryDetailResponse({
    this.error,
    this.message,
    this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}
