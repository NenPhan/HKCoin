import 'dart:convert';

KycStatus kycStatusFromJson(String str) => KycStatus.fromJson(json.decode(str));

String kycStatusToJson(KycStatus data) => json.encode(data.toJson());

class KycStatus {
  bool? success;
  String? message;
  String? nextStep;
  ValidationResults? validationResults;

  KycStatus({
    this.success,
    this.message,
    this.nextStep,
    this.validationResults,
  });

  factory KycStatus.fromJson(Map<String, dynamic> json) => KycStatus(
    success: json["Success"],
    message: json["Message"],
    nextStep: json["NextStep"],
    validationResults:
        json["ValidationResults"] == null
            ? null
            : ValidationResults.fromJson(json["ValidationResults"]),
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "Message": message,
    "NextStep": nextStep,
    "ValidationResults": validationResults?.toJson(),
  };
}

class ValidationResults {
  ValidationResults();

  factory ValidationResults.fromJson(Map<String, dynamic> json) =>
      ValidationResults();

  Map<String, dynamic> toJson() => {};
}
