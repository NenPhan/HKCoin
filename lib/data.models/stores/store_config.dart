import 'dart:convert';

StoreConfig storeFromJson(String str) => StoreConfig.fromJson(json.decode(str));

class StoreConfig {
  String? name;
  String? logoUrl;
  String? iconLogoUrl;
  String? baseUrl;
  String? contentDeliveryNetwork;

  StoreConfig({
    this.name,
    this.logoUrl,
    this.iconLogoUrl,
    this.baseUrl,
    this.contentDeliveryNetwork,
  });

  factory StoreConfig.fromJson(Map<String, dynamic> json) => StoreConfig(
    name: json["Name"],
    baseUrl: json["BaseUrl"],
    logoUrl: json["LogoUrl"],
    iconLogoUrl: json["IconLogoUrl"],
    contentDeliveryNetwork: json["ContentDeliveryNetwork"],
  );
  Map<String, dynamic> toJson() => {
    "Name": name,
    "LogoUrl": logoUrl,
    "IconLogoUrl": iconLogoUrl,
    "BaseUrl": baseUrl,
    "ContentDeliveryNetwork": contentDeliveryNetwork,
  };
}
