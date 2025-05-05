class Language {
  int? id;
  String? isoCode;
  String? cultureCode;
  String? flagImageFileName;
  String? name;
  String? shortName;
  String? localizedName;
  String? localizedShortName;
  bool? isDefault;

  Language({
    this.id,
    this.isoCode,
    this.cultureCode,
    this.flagImageFileName,
    this.name,
    this.shortName,
    this.localizedName,
    this.localizedShortName,
    this.isDefault,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["Id"],
    isoCode: json["ISOCode"],
    cultureCode: json["CultureCode"],
    flagImageFileName: json["FlagImageFileName"],
    name: json["Name"],
    shortName: json["ShortName"],
    localizedName: json["LocalizedName"],
    localizedShortName: json["LocalizedShortName"],
    isDefault: json["IsDefault"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ISOCode": isoCode,
    "CultureCode": cultureCode,
    "FlagImageFileName": flagImageFileName,
    "Name": name,
    "ShortName": shortName,
    "LocalizedName": localizedName,
    "LocalizedShortName": localizedShortName,
    "IsDefault": isDefault,
  };
}

class SetLanguage {
  String? name;
  String? languageCulture;
  String? uniqueSeoCode;
  String? flagImageFileName;
  bool? rtl;
  bool? limitedToStores;
  bool? published;
  int? displayOrder;
  int? id;

  SetLanguage({
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

  factory SetLanguage.fromJson(Map<String, dynamic> json) => SetLanguage(
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
