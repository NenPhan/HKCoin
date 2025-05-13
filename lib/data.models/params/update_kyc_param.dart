import 'dart:convert';

UpdateKycParam updateKycParamFromJson(String str) =>
    UpdateKycParam.fromJson(json.decode(str));

String updateKycParamToJson(UpdateKycParam data) => json.encode(data.toJson());

class UpdateKycParam {
  String firstName;
  String lastName;
  String phone;
  String identificationCardNumber;
  int? identificationCardTypeId;
  int? countryId;

  UpdateKycParam({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.identificationCardNumber,
    required this.identificationCardTypeId,
    required this.countryId,
  });

  factory UpdateKycParam.fromJson(Map<String, dynamic> json) => UpdateKycParam(
    firstName: json["FirstName"],
    lastName: json["LastName"],
    phone: json["Phone"],
    identificationCardNumber: json["IdentificationCardNumber"],
    identificationCardTypeId: json["IdentificationCardTypeId"],
    countryId: json["CountryId"],
  );

  Map<String, dynamic> toJson() => {
    "FirstName": firstName,
    "LastName": lastName,
    "Phone": phone,
    "IdentificationCardNumber": identificationCardNumber,
    "IdentificationCardTypeId": identificationCardTypeId,
    "CountryId": countryId,
  };
}
