import 'dart:convert';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  int? countryId;
  String? name;
  String? abbreviation;
  bool? published;
  int? displayOrder;
  dynamic description;
  dynamic bottomDescription;
  dynamic metaKeywords;
  dynamic metaDescription;
  dynamic metaTitle;
  String? latitude;
  String? longitude;
  int? id;

  Province({
    this.countryId,
    this.name,
    this.abbreviation,
    this.published,
    this.displayOrder,
    this.description,
    this.bottomDescription,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.latitude,
    this.longitude,
    this.id,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    countryId: json["CountryId"],
    name: json["Name"],
    abbreviation: json["Abbreviation"],
    published: json["Published"],
    displayOrder: json["DisplayOrder"],
    description: json["Description"],
    bottomDescription: json["BottomDescription"],
    metaKeywords: json["MetaKeywords"],
    metaDescription: json["MetaDescription"],
    metaTitle: json["MetaTitle"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "CountryId": countryId,
    "Name": name,
    "Abbreviation": abbreviation,
    "Published": published,
    "DisplayOrder": displayOrder,
    "Description": description,
    "BottomDescription": bottomDescription,
    "MetaKeywords": metaKeywords,
    "MetaDescription": metaDescription,
    "MetaTitle": metaTitle,
    "Latitude": latitude,
    "Longitude": longitude,
    "Id": id,
  };
}
