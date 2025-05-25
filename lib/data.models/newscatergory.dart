import 'dart:convert';

NewsCategory newsFromJson(String str) => NewsCategory.fromJson(json.decode(str));
class NewsCategory {
  final int id;
  final String name;
  final String? description;
  bool isExpanded;
  bool isLoading;
  List<NewsCategory> subCategories;

  NewsCategory({
    required this.id,
    required this.name,
    this.description, 
    this.subCategories = const [],
    this.isExpanded = false,
    this.isLoading = false,
  });
  factory NewsCategory.fromJson(Map<String, dynamic> json) => NewsCategory(
    id: json["Id"],
    name: json["Name"],
    description: json["Description"]??"",
    subCategories: json["SubCategories"] != null 
        ? List<NewsCategory>.from(json["SubCategories"].map((x) => NewsCategory.fromJson(x)))
        : [],
  );
}