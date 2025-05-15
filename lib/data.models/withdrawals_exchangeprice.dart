import 'dart:convert';

ExchangePrice exchangePriceFromJson(String str) =>
    ExchangePrice.fromJson(json.decode(str));

String exchangePriceToJson(ExchangePrice data) => json.encode(data.toJson());

class ExchangePrice {  
  double price;  
  String? walletTokenAddres;
  String? priceString;
 
  ExchangePrice({
    required this.price,
    required this.walletTokenAddres,
    required this.priceString,     
  });

  factory ExchangePrice.fromJson(Map<String, dynamic> json) => ExchangePrice(
    price: json["Price"],
    walletTokenAddres: json["WalletTokenAddres"],
    priceString: json["PriceString"],
   
  );

  Map<String, dynamic> toJson() => {
    "Price": price,
    "walletTokenAddres": walletTokenAddres,
    "PriceString": priceString,    
  };  
}