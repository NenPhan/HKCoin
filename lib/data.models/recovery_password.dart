// To parse this JSON data, do
//
//     final registerForm = registerFormFromJson(jsonString);

import 'dart:convert';

import 'package:hkcoin/core/enums.dart';

RecoveryPassword registerFormFromJson(String str) => RecoveryPassword.fromJson(json.decode(str));

String recoveryPasswordToJson(RecoveryPassword data) => json.encode(data.toJson());

class RecoveryPassword {
    String email;
    String? resultMessage;
    PasswordRecoveryResultState? resultState;

    RecoveryPassword({
        required this.email,
        this.resultMessage,
        this.resultState
    });

    factory RecoveryPassword.fromJson(Map<String, dynamic> json) => RecoveryPassword(       
        email: json["Email"],
        resultMessage: json["ResultMessage"],
        resultState: json["ResultState"].toString().toPasswordRecoveryResultState(),
    );

    Map<String, dynamic> toJson() => {
        "Email": email,
        "ResultMessage": resultMessage,
        "ResultState": resultState,
    };
}
