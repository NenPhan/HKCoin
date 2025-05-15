import 'dart:convert';

WithDrawalsInvestment withDrawalsInvestmentFromJson(String str) =>
    WithDrawalsInvestment.fromJson(json.decode(str));

String withDrawalsInvestmentToJson(WithDrawalsInvestment data) => json.encode(data.toJson());

class WithDrawalsInvestment {
  int? id;
  String? cryptoExtensionName;
  double withdrawFee;
  String? withdrawFeeStr;
  String? withdrawFeeHint;
  double? exchangeHKC;
  String walletTokenAddres;
  String? walletAmount;
  double? walletAmountValue;
  int? withdrawalPrincipalId;
  int? packageId;
  List<AviablePackages>? aviablePackages;
  String? customerComments;
  double? amountSwapToHKC;
  double? packageAmount;

  WithDrawalsInvestment({
    this.id,
    this.cryptoExtensionName,
    required this.withdrawFee,
    this.withdrawFeeStr,
    this.withdrawFeeHint,
    this.walletAmount,
    this.exchangeHKC,
    this.walletAmountValue,
    this.withdrawalPrincipalId,
    required this.walletTokenAddres,
    this.packageId,  
    this.aviablePackages,    
    this.amountSwapToHKC,
    this.customerComments,
    this.packageAmount
  });

  factory WithDrawalsInvestment.fromJson(Map<String, dynamic> json) => WithDrawalsInvestment(
    id: json["Id"],
    cryptoExtensionName:json["CryptoExtensionName"],
    withdrawFee: json["WithdrawFee"],
    withdrawFeeStr: json["WithdrawFeeStr"],
    withdrawFeeHint: json["WithdrawFeeHint"],
    walletAmount: json["WalletAmount"],
    exchangeHKC: json["ExchangeHKC"],
    walletAmountValue: json["WalletAmountValue"],
    withdrawalPrincipalId: json["WithdrawalPrincipalId"],
    walletTokenAddres: json["WalletTokenAddres"],
    packageId: json["PackageId"],  
    customerComments:json["CustomerComments"],
    aviablePackages:
            json["AviablePackages"] == null
                ? []
                : List<AviablePackages>.from(
                  json["AviablePackages"]!.map(
                    (x) => AviablePackages.fromJson(x),
                  ),
                ),    
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "WalletTokenAddres": walletTokenAddres,
    "ExchangeHKC": exchangeHKC,
    "WithdrawFee":withdrawFee,
    "PackageId": packageId,
    "PackageAmount":packageAmount,
    "WithdrawalPrincipalId": 1,
    "AmountSwapToHKC":amountSwapToHKC,
    "CustomerComments":customerComments   
  };  
}
class AviablePackages {
  int id;
  String name;
  bool selected;

  AviablePackages({
    required this.id,
    required this.name,
    required this.selected
  });

  factory AviablePackages.fromJson(Map<String, dynamic> json) => AviablePackages(
    id: json["PackageId"],
    name: json["PackageName"],
    selected: json["Selected"]   
  );

  Map<String, dynamic> toJson() => {
    "PackageId": id,
    "PackageName": name,
    "Selected": selected,  
  };
  @override
  String toString() => name;
}