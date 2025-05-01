import 'dart:convert';

ChangePasswordParam changePasswordFromJson(String str) =>
    ChangePasswordParam.fromJson(json.decode(str));

String changePasswordToJson(ChangePasswordParam data) =>
    json.encode(data.toJson());

class ChangePasswordParam {
  String oldPassword;
  String newPassword;
  String confirmNewPassword;

  ChangePasswordParam({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory ChangePasswordParam.fromJson(Map<String, dynamic> json) =>
      ChangePasswordParam(
        oldPassword: json["OldPassword"],
        newPassword: json["NewPassword"],
        confirmNewPassword: json["ConfirmNewPassword"],
      );

  Map<String, dynamic> toJson() => {
    "OldPassword": oldPassword,
    "NewPassword": newPassword,
    "ConfirmNewPassword": confirmNewPassword,
  };
}
