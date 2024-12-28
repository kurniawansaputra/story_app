import 'dart:convert';

class StoryResponseModel {
  final bool? error;
  final String? message;
  final List<ListStory>? listStory;

  StoryResponseModel({
    this.error,
    this.message,
    this.listStory,
  });

  factory StoryResponseModel.fromJson(String str) =>
      StoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StoryResponseModel.fromMap(Map<String, dynamic> json) =>
      StoryResponseModel(
        error: json["error"],
        message: json["message"],
        listStory: json["listStory"] == null
            ? []
            : List<ListStory>.from(
                json["listStory"]!.map((x) => ListStory.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "listStory": listStory == null
            ? []
            : List<dynamic>.from(listStory!.map((x) => x.toMap())),
      };
}

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

  factory ListStory.fromJson(String str) => ListStory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListStory.fromMap(Map<String, dynamic> json) => ListStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
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
