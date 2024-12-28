import 'dart:convert';

class StoryDetailResponseModel {
  final bool? error;
  final String? message;
  final Story? story;

  StoryDetailResponseModel({
    this.error,
    this.message,
    this.story,
  });

  factory StoryDetailResponseModel.fromJson(String str) =>
      StoryDetailResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StoryDetailResponseModel.fromMap(Map<String, dynamic> json) =>
      StoryDetailResponseModel(
        error: json["error"],
        message: json["message"],
        story: json["story"] == null ? null : Story.fromMap(json["story"]),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "story": story?.toMap(),
      };
}

class Story {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final dynamic lat;
  final dynamic lon;

  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(String str) => Story.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Story.fromMap(Map<String, dynamic> json) => Story(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt?.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
