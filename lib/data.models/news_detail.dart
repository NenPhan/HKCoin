import 'dart:convert';

import 'package:hkcoin/core/time_converter.dart';

NewsDetail newsFromJson(String str) => NewsDetail.fromJson(json.decode(str));

String newsToJson(NewsDetail data) => json.encode(data.toJson());

class NewsDetail {
  int id;
  String name;
  String shortDescription;
  String fullDescription;  
  DateTime createdOn;
  ImageContent? imageContent;
  int? views;

  NewsDetail({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,    
    required this.createdOn,
    this.imageContent,
    this.views
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) => NewsDetail(
    id: json["Id"],
    name: json["Name"],
    shortDescription: json["ShortDescription"],
    fullDescription: json["FullDescription"],    
    createdOn: DateTime.parse(json["CreatedOnUtc"]).convertToUserTime(),    
    imageContent: ImageContent.fromJson(json["ImageContent"]),
    views: json["View"]??0
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ShortDescription": shortDescription,    
    "CreatedOn": createdOn.toIso8601String(),
  };
}
class ImageContent {  
  String? alt;
  String? title;
  String? path;
  String? thumbUrl;
  ImageContent({this.alt, this.title, this.path, this.thumbUrl});
  factory ImageContent.fromJson(Map<String, dynamic> json) => ImageContent(    
    alt: json["Alt"],
    title: json["Title"],
    path: json["Path"],
    thumbUrl: json["ThumbUrl"]
  );
}
