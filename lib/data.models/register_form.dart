// To parse this JSON data, do
//
//     final registerForm = registerFormFromJson(jsonString);

import 'dart:convert';

RegisterForm registerFormFromJson(String str) => RegisterForm.fromJson(json.decode(str));

String registerFormToJson(RegisterForm data) => json.encode(data.toJson());

class RegisterForm {
    String firstName;
    String lastName;
    String email;
    String phone;
    String password;
    String referralCode;

    RegisterForm({
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phone,
        required this.password,
        required this.referralCode,
    });

    factory RegisterForm.fromJson(Map<String, dynamic> json) => RegisterForm(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phone: json["Phone"],
        password: json["Password"],
        referralCode: json["ReferralCode"],
    );

    Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "Phone": phone,
        "Password": password,
        "ReferralCode": referralCode,
    };
}
