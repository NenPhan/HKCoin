import 'dart:convert';

import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/extensions/enum_type_extension.dart';

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
  int countryId;
  dynamic sponsorCode;
  String affiliateLink;
  Settings settings;
  int? genderId;
  GenderType? gender;

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
    this.genderId,
    this.gender,
    required this.customerNumber,
    required this.birthDate,
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
    phone: json["Phone"] ?? "",
    active: json["Active"],
    firstName: json["FirstName"] ?? "",
    lastName: json["LastName"] ?? "",
    fullName: json["FullName"] ?? "",
    customerNumber: json["CustomerNumber"],
    birthDate:
        json['BirthDate'] != null ? DateTime.parse(json['BirthDate']) : null,
    genderId: json["GenderId"],
    gender: GenderTypeX.mapGenderFromInt(json["GenderId"]),
    countryId: json["CountryId"],
    sponsorCode: json["SponsorCode"],
    affiliateLink: json["AffiliateLink"] ?? "",
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
    "BirthDate": birthDate?.toIso8601String(),
    "GenderId": genderId,
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
    "GenderId": genderId,
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
