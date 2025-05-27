import 'dart:convert';

Store storeFromJson(String str) => Store.fromJson(json.decode(str));

class Store {
  String? name;
  String? logoUrl;
  String? baseUrl;
  String? contentDeliveryNetwork;

  Store({this.name, this.logoUrl, this.baseUrl,
    this.contentDeliveryNetwork});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    name: json["Name"],
    baseUrl: json["BaseUrl"],
    logoUrl: json["LogoUrl"],
    contentDeliveryNetwork: json["ContentDeliveryNetwork"]
  );
}
