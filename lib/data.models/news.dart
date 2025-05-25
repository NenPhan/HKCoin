import 'dart:convert';

NewsPagination newsPaginationFromJson(String str) =>
    NewsPagination.fromJson(json.decode(str));
class NewsPagination {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  bool? hasNextPage;
  List<News>? news;

  NewsPagination({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,    
    this.hasNextPage,
    this.news,
  });

  factory NewsPagination.fromJson(Map<String, dynamic> json) =>
      NewsPagination(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        hasNextPage: (json["PageNumber"] ?? 1) < (json["TotalPages"] ?? 1),
        news:
            json["Data"] == null
                ? null
                : (json["Data"] as List)
                    .map((e) => News.fromJson(e))
                    .toList(),
      ); 
}
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
