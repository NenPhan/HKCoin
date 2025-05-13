import 'dart:convert';

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country data) => json.encode(data.toJson());

class Country {
  String name;
  bool? allowsBilling;
  bool? allowsShipping;
  String? twoLetterIsoCode;
  String? threeLetterIsoCode;
  int? numericIsoCode;
  bool? subjectToVat;
  bool? published;
  int? displayOrder;
  bool? displayCookieManager;
  bool? limitedToStores;
  String? addressFormat;
  int? diallingCode;
  dynamic defaultCurrencyId;
  int? id;

  Country({
    this.name = "",
    this.allowsBilling,
    this.allowsShipping,
    this.twoLetterIsoCode,
    this.threeLetterIsoCode,
    this.numericIsoCode,
    this.subjectToVat,
    this.published,
    this.displayOrder,
    this.displayCookieManager,
    this.limitedToStores,
    this.addressFormat,
    this.diallingCode,
    this.defaultCurrencyId,
    this.id,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["Name"],
    allowsBilling: json["AllowsBilling"],
    allowsShipping: json["AllowsShipping"],
    twoLetterIsoCode: json["TwoLetterIsoCode"],
    threeLetterIsoCode: json["ThreeLetterIsoCode"],
    numericIsoCode: json["NumericIsoCode"],
    subjectToVat: json["SubjectToVat"],
    published: json["Published"],
    displayOrder: json["DisplayOrder"],
    displayCookieManager: json["DisplayCookieManager"],
    limitedToStores: json["LimitedToStores"],
    addressFormat: json["AddressFormat"],
    diallingCode: json["DiallingCode"],
    defaultCurrencyId: json["DefaultCurrencyId"],
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "AllowsBilling": allowsBilling,
    "AllowsShipping": allowsShipping,
    "TwoLetterIsoCode": twoLetterIsoCode,
    "ThreeLetterIsoCode": threeLetterIsoCode,
    "NumericIsoCode": numericIsoCode,
    "SubjectToVat": subjectToVat,
    "Published": published,
    "DisplayOrder": displayOrder,
    "DisplayCookieManager": displayCookieManager,
    "LimitedToStores": limitedToStores,
    "AddressFormat": addressFormat,
    "DiallingCode": diallingCode,
    "DefaultCurrencyId": defaultCurrencyId,
    "Id": id,
  };

  @override
  String toString() => name;
}
