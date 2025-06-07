import 'dart:convert';

CustomerWalletToken walletFromJson(String str) =>
    CustomerWalletToken.fromJson(json.decode(str));

String walletToJson(CustomerWalletToken data) => json.encode(data.toJson());
class CustomerWalletToken {
  final int? id;
  final String? contractAddress;
  final String? walletAddress;
  final String? symbol;
  final int? decimals;  
  final int? ethereumNetworkId;
  CustomerWalletToken({
    this.id,
    this.contractAddress,
    this.walletAddress,
    this.symbol,
    this.decimals,
    this.ethereumNetworkId 
  });
  factory CustomerWalletToken.fromJson(Map<String, dynamic> json) => CustomerWalletToken(
    id: json["Id"],
    contractAddress: json["ContractAddress"],
    walletAddress: json["WalletAddress"],
    symbol: json["Symbol"],
    decimals: json["Decimals"],    
    ethereumNetworkId: json["EthereumNetworkId"]   
  );
  Map<String, dynamic> toJson() => {
    "Id": id,    
    "ContractAddress": contractAddress,
    "WalletAddress": walletAddress,
    "Symbol": symbol,
    "Decimals": decimals,    
    "EthereumNetworkId": ethereumNetworkId,    
  };  
}