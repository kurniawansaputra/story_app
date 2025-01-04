import 'package:json_annotation/json_annotation.dart';

part 'list_story.g.dart';

@JsonSerializable()
class ListStory {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  ListStory({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  /// Factory method for creating an instance from a JSON map.
  factory ListStory.fromJson(Map<String, dynamic> json) =>
      _$ListStoryFromJson(json);

  /// Method to convert an instance into a JSON map.
  Map<String, dynamic> toJson() => _$ListStoryToJson(this);
}
