import 'dart:convert';

WalletInfo walletInfoFromJson(String str) =>
    WalletInfo.fromJson(json.decode(str));

String walletInfoToJson(WalletInfo data) => json.encode(data.toJson());

class WalletInfo {
  String walletMain;
  String walletCoupon;
  String walletShopping;
  String orderCount;
  String profitsShopping;

  WalletInfo({
    required this.walletMain,
    required this.walletCoupon,
    required this.walletShopping,
    required this.orderCount,
    required this.profitsShopping,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
    walletMain: json["WalletMain"],
    walletCoupon: json["WalletCoupon"],
    walletShopping: json["WalletShopping"],
    orderCount: json["OrderCount"],
    profitsShopping: json["ProfitsShopping"],
  );

  Map<String, dynamic> toJson() => {
    "WalletMain": walletMain,
    "WalletCoupon": walletCoupon,
    "WalletShopping": walletShopping,
    "OrderCount": orderCount,
    "ProfitsShopping": profitsShopping,
  };
}
