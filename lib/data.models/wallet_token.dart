import 'dart:convert';

WalletToken walletTokenFromJson(String str) =>
    WalletToken.fromJson(json.decode(str));

String walletTokenToJson(WalletToken data) => json.encode(data.toJson());

class WalletToken {
  String? token;
  String? balance;
  int? decimals;
  String? walletToken;
  String? walletQrCode;

  WalletToken({
    this.token,
    this.balance,
    this.decimals,
    this.walletToken,
    this.walletQrCode,
  });

  factory WalletToken.fromJson(Map<String, dynamic> json) => WalletToken(
    token: json["Token"],
    balance: json["Balance"],
    decimals: json["Decimals"],
    walletToken: json["WalletToken"],
    walletQrCode: json["WalletQRCode"],
  );

  Map<String, dynamic> toJson() => {
    "Token": token,
    "Balance": balance,
    "Decimals": decimals,
    "WalletToken": walletToken,
    "WalletQRCode": walletQrCode,
  };
}
