import 'dart:convert';

AddAddressParam addAddressParamFromJson(String str) =>
    AddAddressParam.fromJson(json.decode(str));

String addAddressParamToJson(AddAddressParam data) =>
    json.encode(data.toJson());

class AddAddressParam {
  String? firstName;
  String? lastName;
  String? email;
  String? company;
  int? countryId;
  int? stateProvinceId;
  String? city;
  String? address1;
  String? phoneNumber;
  bool? isDefaultBillingAddress;

  AddAddressParam({
    this.firstName,
    this.lastName,
    this.email,
    this.company,
    this.countryId,
    this.stateProvinceId,
    this.city,
    this.address1,
    this.phoneNumber,
    this.isDefaultBillingAddress,
  });

  factory AddAddressParam.fromJson(Map<String, dynamic> json) =>
      AddAddressParam(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        company: json["Company"],
        countryId: json["CountryId"],
        stateProvinceId: json["StateProvinceId"],
        city: json["City"],
        address1: json["Address1"],
        phoneNumber: json["PhoneNumber"],
        isDefaultBillingAddress: json["IsDefaultBillingAddress"],
      );

  Map<String, dynamic> toJson() => {
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email ?? "",
    "Company": company ?? "",
    "CountryId": countryId,
    "StateProvinceId": stateProvinceId,
    "City": city,
    "Address1": address1,
    "PhoneNumber": phoneNumber,
    "IsDefaultBillingAddress": isDefaultBillingAddress,
  };
}
