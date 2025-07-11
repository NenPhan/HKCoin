import 'dart:convert';

TokenSetting tokenSettingFromJson(String str) =>
    TokenSetting.fromJson(json.decode(str));

String tokenSettingToJson(TokenSetting data) => json.encode(data.toJson());
class TokenSetting {  
  final String bscScanApiKey;
  final String contractAddressSend;
  final String contractFunction;
  final double? minBNB;  
  final String? privateKey;
  final String? publicKey;
  final int? createWalletType; 
  final bool? selected;
  final List<String> wsUrls;
  final List<Token>? tokens; // Thêm trường tokens nếu cần
  TokenSetting({    
    required this.bscScanApiKey,
    required this.contractAddressSend,
    required this.contractFunction,
    this.minBNB,
    this.privateKey,
    this.publicKey,
    this.createWalletType,   
    this.selected,
    required this.wsUrls,
    this.tokens, 
  });
  factory TokenSetting.fromJson(Map<String, dynamic> json) => TokenSetting(    
    bscScanApiKey: json["BscScanApiKey"]??"0xd6A1f22c90fd729794b1f7E528b143c0882cf23C",
    contractAddressSend: json["ContractAddressSend"],
    contractFunction: json["ContractFunction"],
    minBNB: json["MinBNB"]??0.00001,
    wsUrls: (json["WsUrls"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        tokens: json["TokenJson"] == null
            ? null
            : (json["TokenJson"] is List<dynamic>)
                ? (json["TokenJson"] as List<dynamic>)
                    .map((e) => Token.fromJson(
                        e is String ? jsonDecode(e) : e as Map<String, dynamic>))
                    .toList()
                : null,
  );
  Map<String, dynamic> toJson() => {    
    "BscScanApiKey": bscScanApiKey,
    "ContractAddressSend": contractAddressSend,
    "ContractFunction": contractFunction,
    "MinBNB": minBNB,
    "WsUrls": wsUrls,
    if (tokens != null)
      "TokenJson": tokens!.map((e) => e.toJson()).toList(),
  };  
}

class Token {
  final String name;
  final String address;
  final int decimals;

  Token({
    required this.name,
    required this.address,
    required this.decimals,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        name: json["Name"] as String,
        address: json["Address"] as String,
        decimals: json["Decimals"] as int,
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Address": address,
        "Decimals": decimals,
      };
}