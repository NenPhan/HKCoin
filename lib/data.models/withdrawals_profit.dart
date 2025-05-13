import 'dart:convert';

WithDrawalsProfit withDrawalsProfitFromJson(String str) =>
    WithDrawalsProfit.fromJson(json.decode(str));

String withDrawalsProfitToJson(WithDrawalsProfit data) => json.encode(data.toJson());

class WithDrawalsProfit {
  int id;
  double withdrawFee;
  String withdrawFeeHint;
  double? hTXExchangePrice;
  double? exchangeHKC;
  double? tokenExchangePrice;
  double amount;
  double amountSwap;
  double? amountToUSDT;
  int walletId;
  String walletTokenAddres;
  int customerId;
  int withDrawalSwapId;
  String? walletAmountProfits;
  List<AviableWithDrawalSwaps> aviableWithDrawalSwaps;

  WithDrawalsProfit({
    required this.id,
    required this.withdrawFee,
    required this.withdrawFeeHint,
    this.hTXExchangePrice,
    this.exchangeHKC,
    this.tokenExchangePrice,
    required this.amount,
    required this.amountSwap,
    required this.amountToUSDT,
    required this.walletId,
    required this.walletTokenAddres,
    required this.customerId,
    required this.withDrawalSwapId,
    this.walletAmountProfits,
    required this.aviableWithDrawalSwaps    
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
    "TokenExchangePrice": tokenExchangePrice,
    "Amount": amount,
    "AmountSwap": amountSwap,
    "AmountToUSDT": amountToUSDT,
    "WalletId": walletId,
    "WalletTokenAddres": walletTokenAddres,
    "CustomerId": customerId,
    "WithDrawalSwapId": withDrawalSwapId,
    "WalletAmountProfits": walletAmountProfits,
    "AviableWithDrawalSwaps":
        aviableWithDrawalSwaps == null
            ? []
            : List<dynamic>.from(aviableWithDrawalSwaps!.map((x) => x.toJson())),    
  };  
}
class AviableWithDrawalSwaps {
  int tokenTypeId;
  String tokenTypeName;
  bool selected;

  AviableWithDrawalSwaps({
    required this.tokenTypeId,
    required this.tokenTypeName,
    required this.selected
  });

  factory AviableWithDrawalSwaps.fromJson(Map<String, dynamic> json) => AviableWithDrawalSwaps(
    tokenTypeId: json["TokenTypeId"],
    tokenTypeName: json["TokenTypeName"],
    selected: json["Selected"]   
  );

  Map<String, dynamic> toJson() => {
    "TokenTypeId": tokenTypeId,
    "TokenTypeName": tokenTypeName,
    "Selected": selected,  
  };
}