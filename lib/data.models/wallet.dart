import 'dart:convert';

import 'package:hkcoin/core/enums.dart';

BlockchangeWallet walletFromJson(String str) =>
    BlockchangeWallet.fromJson(json.decode(str));

String walletToJson(BlockchangeWallet data) => json.encode(data.toJson());
class BlockchangeWallet {
  int? id;
  final String? name;
  double? balance;
  final String? mnemonicOrPrivateKey;  
  final int? createWalletType; 
  final bool? selected;
  List<WalletAddress>? walletAddress;
  BlockchangeWallet({
    this.id,
    this.name,
    this.balance,
    this.mnemonicOrPrivateKey,
    this.createWalletType,   
    this.selected,
    this.walletAddress     
  });
  factory BlockchangeWallet.fromJson(Map<String, dynamic> json) => BlockchangeWallet(
    id: json["Id"],
    name: json["Name"],
    balance: json["Balance"],
    mnemonicOrPrivateKey: json["MnemonicOrPrivateKey"],
    createWalletType: json["CreateWalletType"],
    selected: json["Selected"],
     walletAddress:
            json["Wallets"] == null
                ? null
                : (json["Wallets"] as List)
                    .map((e) => WalletAddress.fromJson(e))
                    .toList(),
  );
  Map<String, dynamic> toJson() => {
    "Id": id,    
    "MnemonicOrPrivateKey": mnemonicOrPrivateKey,
    "CreateWalletType": createWalletType,
    "Selected": selected,
    "Wallets": walletAddress?.map((e) => e.toJson()).toList() ?? [],
  };  
}

class WalletAddress {
  final String address;
  final String contractAddress; 
  final String? privateKey;
  final String? publicKey;
  final Chain chain;
  final String? mnemonic;
  final int networkChain;
  double? totalBalance;
  String? symbol;
  int? decimals;

  WalletAddress({
    required this.address,
    required this.contractAddress,
    this.privateKey,
    this.publicKey,
    required this.chain,
    required this.networkChain,
    this.mnemonic,    
    this.totalBalance,
    this.symbol,
    this.decimals
  });
  factory WalletAddress.fromJson(Map<String, dynamic> json) => WalletAddress(
    address: json["WalletAddress"],
    contractAddress: json["ContractAddress"],
     chain: Chain.values.firstWhere(
      (e) => e.index == json["Chain"] as int,
      orElse: () => Chain.HKC,
    ),
    networkChain:json["EthereumNetwork"]??"",   
    symbol: json["Symbol"],
    decimals: json["Decimals"]
  );
  Map<String, dynamic> toJson() => {
    "WalletAddress": address,
    "ContractAddress": contractAddress,
    "PrivateKey": privateKey,
    "PublicKey": publicKey,
    "Chain": chain.index,//TokenTypeId
    "EthereumNetwork": networkChain,//EthereumNetworkId  
    "Decimals": decimals,
    "Symbol":symbol  
  };
}
