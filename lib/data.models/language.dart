import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  String? name;
  String? languageCulture;
  String? uniqueSeoCode;
  String? flagImageFileName;
  bool? rtl;
  bool? limitedToStores;
  bool? published;
  int? displayOrder;
  int? id;

  Language({
    this.name,
    this.languageCulture,
    this.uniqueSeoCode,
    this.flagImageFileName,
    this.rtl,
    this.limitedToStores,
    this.published,
    this.displayOrder,
    this.id,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    name: json["Name"],
    languageCulture: json["LanguageCulture"],
    uniqueSeoCode: json["UniqueSeoCode"],
    flagImageFileName: json["FlagImageFileName"],
    rtl: json["Rtl"],
    limitedToStores: json["LimitedToStores"],
    published: json["Published"],
    displayOrder: json["DisplayOrder"],
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "LanguageCulture": languageCulture,
    "UniqueSeoCode": uniqueSeoCode,
    "FlagImageFileName": flagImageFileName,
    "Rtl": rtl,
    "LimitedToStores": limitedToStores,
    "Published": published,
    "DisplayOrder": displayOrder,
    "Id": id,
  };
}
