import 'dart:convert';

WithDrawalsProfit withDrawalsProfitFromJson(String str) =>
    WithDrawalsProfit.fromJson(json.decode(str));

String withDrawalsProfitToJson(WithDrawalsProfit data) => json.encode(data.toJson());

class WithDrawalsProfit {
  int? id;
  double withdrawFee;
  String? withdrawFeeHint;
  double? hTXExchangePrice;
  double? exchangeHKC;
  double? tokenExchangePrice;
  double amount;
  double amountSwap;
  double? amountToUSDT;
  int? walletId;
  String walletTokenAddres;
  int? customerId;
  int withDrawalSwapId;
  String? walletAmountProfits;
  List<AviableWithDrawalSwaps>? aviableWithDrawalSwaps;
  String? customerComments;

  WithDrawalsProfit({
    this.id,
    required this.withdrawFee,
    this.withdrawFeeHint,
    this.hTXExchangePrice,
    this.exchangeHKC,
    this.tokenExchangePrice,
    required this.amount,
    required this.amountSwap,
    required this.amountToUSDT,
    this.walletId,
    required this.walletTokenAddres,
    this.customerId,
    required this.withDrawalSwapId,
    this.walletAmountProfits,
    this.aviableWithDrawalSwaps,    
    this.customerComments
  });

  factory WithDrawalsProfit.fromJson(Map<String, dynamic> json) => WithDrawalsProfit(
    id: json["Id"],
    withdrawFee: json["WithdrawFee"],
    withdrawFeeHint: json["WithdrawFeeHint"],
    hTXExchangePrice: json["HTXExchangePrice"],
    exchangeHKC: json["ExchangeHKC"],
    tokenExchangePrice: json["TokenExchangePrice"],
    amount: json["Amount"],
    amountSwap: json["AmountSwap"],
    amountToUSDT: json["AmountToUSDT"],
    walletId: json["WalletId"],
    walletTokenAddres: json["WalletTokenAddres"],
    customerId: json["CustomerId"],
    withDrawalSwapId: json["WithDrawalSwapId"],
    walletAmountProfits:json["WalletAmountProfits"],
    customerComments:json["CustomerComments"],
    aviableWithDrawalSwaps:
            json["AviableWithDrawalSwaps"] == null
                ? []
                : List<AviableWithDrawalSwaps>.from(
                  json["AviableWithDrawalSwaps"]!.map(
                    (x) => AviableWithDrawalSwaps.fromJson(x),
                  ),
                ),    
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "WithdrawFeeHint": withdrawFeeHint,
    "HTXExchangePrice": hTXExchangePrice,
    "ExchangeHKC": exchangeHKC,
    "WithdrawFee":withdrawFee,
    "TokenExchangePrice": tokenExchangePrice,
    "Amount": amount,
    "AmountSwap": amountSwap,
    "AmountToUSDT": amountToUSDT,
    "WalletId": walletId,
    "WalletTokenAddres": walletTokenAddres,
    "CustomerId": customerId,
    "WithDrawalSwapId": withDrawalSwapId,
    "WalletAmountProfits": walletAmountProfits,
    "CustomerComments":customerComments,
    "AviableWithDrawalSwaps":
        aviableWithDrawalSwaps == null
            ? []
            : List<dynamic>.from(aviableWithDrawalSwaps!.map((x) => x.toJson())),    
  };  
}
class AviableWithDrawalSwaps {
  int id;
  String name;
  bool selected;

  AviableWithDrawalSwaps({
    required this.id,
    required this.name,
    required this.selected
  });

  factory AviableWithDrawalSwaps.fromJson(Map<String, dynamic> json) => AviableWithDrawalSwaps(
    id: json["TokenTypeId"],
    name: json["TokenTypeName"],
    selected: json["Selected"]   
  );

  Map<String, dynamic> toJson() => {
    "TokenTypeId": id,
    "TokenTypeName": name,
    "Selected": selected,  
  };
  @override
  String toString() => name;
}