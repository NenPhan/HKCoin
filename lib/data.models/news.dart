import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  int id;
  String name;
  String shortDescription;
  String imageUrl;
  DateTime createdOn;

  News({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.createdOn,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["Id"],
    name: json["Name"],
    shortDescription: json["ShortDescription"],
    imageUrl: json["ImageUrl"],
    createdOn: DateTime.parse(json["CreatedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ShortDescription": shortDescription,
    "ImageUrl": imageUrl,
    "CreatedOn": createdOn.toIso8601String(),
  };
}
