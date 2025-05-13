import 'dart:convert';

KycInfo kycInfoFromJson(String str) => KycInfo.fromJson(json.decode(str));

String kycInfoToJson(KycInfo data) => json.encode(data.toJson());

class KycInfo {
  int? id;
  bool? firstNameRequired;
  String? firstName;
  bool? lastNameRequired;
  String? lastName;
  String? identificationCardNumber;
  int? identificationCardTypeId;
  bool? phoneEnabled;
  bool? phoneRequired;
  String? phone;
  bool? identificationRequired;
  DateTime? createdOn;
  bool? countryEnabled;
  int? countryId;
  bool? stateProvinceEnabled;
  int? stateProvinceId;
  bool? stateProvinceRequired;
  bool? verifyKyc;
  String? ipAddress;
  List<IdentificationCardType>? identificationCardTypes;

  KycInfo({
    this.id,
    this.firstNameRequired,
    this.firstName,
    this.lastNameRequired,
    this.lastName,
    this.identificationCardNumber,
    this.identificationCardTypeId,
    this.phoneEnabled,
    this.phoneRequired,
    this.phone,
    this.identificationRequired,
    this.createdOn,
    this.countryEnabled,
    this.countryId,
    this.stateProvinceEnabled,
    this.stateProvinceId,
    this.stateProvinceRequired,
    this.verifyKyc,
    this.ipAddress,
    this.identificationCardTypes,
  });

  factory KycInfo.fromJson(Map<String, dynamic> json) => KycInfo(
    id: json["Id"],
    firstNameRequired: json["FirstNameRequired"],
    firstName: json["FirstName"],
    lastNameRequired: json["LastNameRequired"],
    lastName: json["LastName"],
    identificationCardNumber: json["IdentificationCardNumber"],
    identificationCardTypeId: json["IdentificationCardTypeId"],
    phoneEnabled: json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"],
    phone: json["Phone"],
    identificationRequired: json["IdentificationRequired"],
    createdOn:
        json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    countryEnabled: json["CountryEnabled"],
    countryId: json["CountryId"],
    stateProvinceEnabled: json["StateProvinceEnabled"],
    stateProvinceId: json["StateProvinceId"],
    stateProvinceRequired: json["StateProvinceRequired"],
    verifyKyc: json["VerifyKyc"],
    ipAddress: json["IPAddress"],
    identificationCardTypes:
        json["IdentificationCardTypes"] == null
            ? []
            : List<IdentificationCardType>.from(
              json["IdentificationCardTypes"]!.map(
                (x) => IdentificationCardType.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FirstNameRequired": firstNameRequired,
    "FirstName": firstName,
    "LastNameRequired": lastNameRequired,
    "LastName": lastName,
    "IdentificationCardNumber": identificationCardNumber,
    "IdentificationCardTypeId": identificationCardTypeId,
    "PhoneEnabled": phoneEnabled,
    "PhoneRequired": phoneRequired,
    "Phone": phone,
    "IdentificationRequired": identificationRequired,
    "CreatedOn": createdOn?.toIso8601String(),
    "CountryEnabled": countryEnabled,
    "CountryId": countryId,
    "StateProvinceEnabled": stateProvinceEnabled,
    "StateProvinceId": stateProvinceId,
    "StateProvinceRequired": stateProvinceRequired,
    "VerifyKyc": verifyKyc,
    "IPAddress": ipAddress,
    "IdentificationCardTypes":
        identificationCardTypes == null
            ? []
            : List<dynamic>.from(
              identificationCardTypes!.map((x) => x.toJson()),
            ),
  };
}

class IdentificationCardType {
  String? name;
  int? id;
  bool? selected;

  IdentificationCardType({this.name, this.id, this.selected});

  factory IdentificationCardType.fromJson(Map<String, dynamic> json) =>
      IdentificationCardType(
        name: json["IdentificationCardTypeName"],
        id: json["IdentificationCardTypeId"],
        selected: json["Selected"],
      );

  Map<String, dynamic> toJson() => {
    "IdentificationCardTypeName": name,
    "IdentificationCardTypeId": id,
    "Selected": selected,
  };

  @override
  String toString() => name ?? "";
}
