import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  int? id;
  String? firstName;
  bool? firstNameEnabled;
  String? lastName;
  bool? lastNameEnabled;
  String? email;
  bool? emailEnabled;
  bool? emailRequired;
  String? company;
  bool? companyEnabled;
  bool? companyRequired;
  int? countryId;
  String? countryName;
  bool? countryEnabled;
  bool? countryRequired;
  int? stateProvinceId;
  bool? stateProvinceEnabled;
  bool? stateProvinceRequired;
  String? stateProvinceName;
  String? city;
  bool? cityEnabled;
  bool? cityRequired;
  String? address1;
  bool? streetAddressEnabled;
  bool? streetAddressRequired;
  String? phoneNumber;
  bool? phoneEnabled;
  bool? phoneRequired;
  DateTime? createdOn;
  bool? defaultAddressesEnabled;
  List<dynamic>? availableStates;
  String? formattedAddress;
  String? userMapApi;
  bool? districtEnabled;
  bool? wardEnabled;
  bool? streetEnabled;
  bool? isSelected;
  bool? isDefault;
  bool? firstNameRequired;
  bool? lastNameRequired;
  bool? isDefaultBillingAddress;

  Address({
    this.id,
    this.firstName,
    this.firstNameEnabled,
    this.lastName,
    this.lastNameEnabled,
    this.email,
    this.emailEnabled,
    this.emailRequired,
    this.company,
    this.companyEnabled,
    this.companyRequired,
    this.countryId,
    this.countryName,
    this.countryEnabled,
    this.countryRequired,
    this.stateProvinceId,
    this.stateProvinceEnabled,
    this.stateProvinceRequired,
    this.stateProvinceName,
    this.city,
    this.cityEnabled,
    this.cityRequired,
    this.address1,
    this.streetAddressEnabled,
    this.streetAddressRequired,
    this.phoneNumber,
    this.phoneEnabled,
    this.phoneRequired,
    this.createdOn,
    this.defaultAddressesEnabled,
    this.availableStates,
    this.formattedAddress,
    this.userMapApi,
    this.districtEnabled,
    this.wardEnabled,
    this.streetEnabled,
    this.isSelected,
    this.isDefault,
    this.firstNameRequired,
    this.lastNameRequired,
    this.isDefaultBillingAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["Id"],
    firstName: json["FirstName"],
    firstNameEnabled: json["FirstNameEnabled"],
    lastName: json["LastName"],
    lastNameEnabled: json["LastNameEnabled"],
    email: json["Email"],
    emailEnabled: json["EmailEnabled"],
    emailRequired: json["EmailRequired"],
    company: json["Company"],
    companyEnabled: json["CompanyEnabled"],
    companyRequired: json["CompanyRequired"],
    countryId: json["CountryId"],
    countryName: json["CountryName"],
    countryEnabled: json["CountryEnabled"],
    countryRequired: json["CountryRequired"],
    stateProvinceId: json["StateProvinceId"],
    stateProvinceEnabled: json["StateProvinceEnabled"],
    stateProvinceRequired: json["StateProvinceRequired"],
    stateProvinceName: json["StateProvinceName"],
    city: json["City"],
    cityEnabled: json["CityEnabled"],
    cityRequired: json["CityRequired"],
    address1: json["Address1"],
    streetAddressEnabled: json["StreetAddressEnabled"],
    streetAddressRequired: json["StreetAddressRequired"],
    phoneNumber: json["PhoneNumber"],
    phoneEnabled: json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"],
    createdOn:
        json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    defaultAddressesEnabled: json["DefaultAddressesEnabled"],
    availableStates:
        json["AvailableStates"] == null
            ? []
            : List<dynamic>.from(json["AvailableStates"]!.map((x) => x)),
    formattedAddress: json["FormattedAddress"],
    userMapApi: json["UserMapAPI"],
    districtEnabled: json["DistrictEnabled"],
    wardEnabled: json["WardEnabled"],
    streetEnabled: json["StreetEnabled"],
    isSelected: json["IsSelected"],
    isDefault: json["IsDefault"],
    firstNameRequired: json["FirstNameRequired"],
    lastNameRequired: json["LastNameRequired"],
    isDefaultBillingAddress: json["IsDefaultBillingAddress"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FirstName": firstName,
    "FirstNameEnabled": firstNameEnabled,
    "LastName": lastName,
    "LastNameEnabled": lastNameEnabled,
    "Email": email,
    "EmailEnabled": emailEnabled,
    "EmailRequired": emailRequired,
    "Company": company,
    "CompanyEnabled": companyEnabled,
    "CompanyRequired": companyRequired,
    "CountryId": countryId,
    "CountryName": countryName,
    "CountryEnabled": countryEnabled,
    "CountryRequired": countryRequired,
    "StateProvinceId": stateProvinceId,
    "StateProvinceEnabled": stateProvinceEnabled,
    "StateProvinceRequired": stateProvinceRequired,
    "StateProvinceName": stateProvinceName,
    "City": city,
    "CityEnabled": cityEnabled,
    "CityRequired": cityRequired,
    "Address1": address1,
    "StreetAddressEnabled": streetAddressEnabled,
    "StreetAddressRequired": streetAddressRequired,
    "PhoneNumber": phoneNumber,
    "PhoneEnabled": phoneEnabled,
    "PhoneRequired": phoneRequired,
    "CreatedOn": createdOn?.toIso8601String(),
    "DefaultAddressesEnabled": defaultAddressesEnabled,
    "AvailableStates":
        availableStates == null
            ? []
            : List<dynamic>.from(availableStates!.map((x) => x)),
    "FormattedAddress": formattedAddress,
    "UserMapAPI": userMapApi,
    "DistrictEnabled": districtEnabled,
    "WardEnabled": wardEnabled,
    "StreetEnabled": streetEnabled,
    "IsSelected": isSelected,
    "IsDefault": isDefault,
    "FirstNameRequired": firstNameRequired,
    "LastNameRequired": lastNameRequired,
    "IsDefaultBillingAddress": isDefaultBillingAddress,
  };
}
