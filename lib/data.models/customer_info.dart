import 'dart:convert';

CustomerInfo customerInfoFromJson(String str) =>
    CustomerInfo.fromJson(json.decode(str));

String customerInfoToJson(CustomerInfo data) => json.encode(data.toJson());

class CustomerInfo {
  int id;
  String customerGuid;
  String username;
  String email;
  String? phone;
  bool active;
  String? firstName;
  String? lastName;
  String? fullName;
  String customerNumber;
  dynamic birthDate;
  dynamic gender;
  int countryId;
  dynamic sponsorCode;
  String affiliateLink;
  Settings settings;

  CustomerInfo({
    required this.id,
    required this.customerGuid,
    required this.username,
    required this.email,
    this.phone,
    required this.active,
    this.firstName,
    this.lastName,
    this.fullName,
    required this.customerNumber,
    required this.birthDate,
    required this.gender,
    required this.countryId,
    required this.sponsorCode,
    required this.affiliateLink,
    required this.settings,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
    id: json["Id"],
    customerGuid: json["CustomerGuid"],
    username: json["Username"],
    email: json["Email"],
    phone: json["Phone"]??"",
    active: json["Active"],
    firstName: json["FirstName"]??"",
    lastName: json["LastName"]??"",
    fullName: json["FullName"]??"",
    customerNumber: json["CustomerNumber"],
    birthDate: json["BirthDate"],
    gender: json["Gender"],
    countryId: json["CountryId"],
    sponsorCode: json["SponsorCode"],
    affiliateLink: json["AffiliateLink"]??"",
    settings: Settings.fromJson(json["Settings"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "CustomerGuid": customerGuid,
    "Username": username,
    "Email": email,
    "Phone": phone,
    "Active": active,
    "FirstName": firstName,
    "LastName": lastName,
    "FullName": fullName,
    "CustomerNumber": customerNumber,
    "BirthDate": birthDate,
    "Gender": gender,
    "CountryId": countryId,
    "SponsorCode": sponsorCode,
    "AffiliateLink": affiliateLink,
    "Settings": settings.toJson(),
  };
  Map<String, dynamic> toUpdateJson() => {
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "Phone": phone,
  };
}

class Settings {
  bool allowUsersToChangeUsernames;
  bool customerNumberEnabled;
  bool phoneEnabled;
  bool phoneRequired;

  Settings({
    required this.allowUsersToChangeUsernames,
    required this.customerNumberEnabled,
    required this.phoneEnabled,
    required this.phoneRequired,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    allowUsersToChangeUsernames: json["AllowUsersToChangeUsernames"],
    customerNumberEnabled: json["CustomerNumberEnabled"],
    phoneEnabled: json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"],
  );

  Map<String, dynamic> toJson() => {
    "AllowUsersToChangeUsernames": allowUsersToChangeUsernames,
    "CustomerNumberEnabled": customerNumberEnabled,
    "PhoneEnabled": phoneEnabled,
    "PhoneRequired": phoneRequired,
  };
}
