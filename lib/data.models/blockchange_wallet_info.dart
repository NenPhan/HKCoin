import 'dart:convert';

import 'package:hkcoin/core/enums.dart';

BlockchangeWalletInfo myWalletFromJson(String str) =>
    BlockchangeWalletInfo.fromJson(json.decode(str));

String blockchangeWalletInfoToJson(BlockchangeWalletInfo data) => json.encode(data.toJson());
class BlockchangeWalletInfo {
  final int? id;
  final String? name;
  final String? walletAddress;
  String? walletAddressFormat;
  final int? networkId;
  double? totalBalance;
  double? balanceUSD;
  final String? encryptedMnemonic;  
  final String? encryptionSalt;  
  final int? createWalletTypeId; 
  List<WalletsModel>? walletAddressModel;
  BlockchangeWalletInfo({
    this.id,
    this.name,
    this.walletAddress,
    this.walletAddressFormat,
    this.networkId,
    this.totalBalance,
    this.balanceUSD,
    this.encryptedMnemonic,
    this.encryptionSalt,
    this.createWalletTypeId,   
    this.walletAddressModel 
  });
  factory BlockchangeWalletInfo.fromJson(Map<String, dynamic> json) => BlockchangeWalletInfo(
    id: json["Id"],
    name: json["Name"],
    walletAddress: json["WalletAddress"],
    networkId: json["NetworkId"],
    totalBalance: json["TotalBalance"],
    encryptedMnemonic: json["EncryptedMnemonic"],
    encryptionSalt: json["EncryptionSalt"],
    createWalletTypeId: json["CreateWalletTypeId"],
     walletAddressModel:
            json["WalletsModel"] == null
                ? null
                : (json["WalletsModel"] as List)
                    .map((e) => WalletsModel.fromJson(e))
                    .toList(),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "WalletAddress": walletAddress,
    "NetworkId": networkId,
    "TotalBalance": totalBalance,
    "EncryptedMnemonic": encryptedMnemonic,
    "EncryptionSalt": encryptionSalt,
    "CreateWalletTypeId": createWalletTypeId,
    "WalletsModel": walletAddressModel?.map((e) => e.toJson()).toList() ?? [],
  };  
}

class WalletsModel {
  final String walletAddress;
  final String contractAddress; 
  final EthereumNetwork? ethereumNetwork;
  final Chain chain;
  final String? privateKey;
  final String? publicKey;
  double? totalBalance;
  double? totalBalanceUSD;
  final String? symbol;
  final int? decimals;

  WalletsModel({
    required this.walletAddress,
    required this.contractAddress,
    required this.ethereumNetwork,
    required this.chain,
    this.privateKey,
    this.publicKey,
    this.totalBalance,
    this.totalBalanceUSD,
    this.symbol,
    this.decimals
  });
  factory WalletsModel.fromJson(Map<String, dynamic> json) => WalletsModel(
    walletAddress: json["WalletAddress"],
    contractAddress: json["ContractAddress"],
    ethereumNetwork: EthereumNetwork.values.firstWhere(
      (e) => e.index == json["EthereumNetwork"] as int,
      orElse: () => EthereumNetwork.BEP20,
    ),    
    chain: Chain.values.firstWhere(
      (e) => e.index == json["Chain"] as int,
      orElse: () => Chain.HKC,
    ),
    privateKey: json["PrivateKey"],
    publicKey: json["PublicKey"],
    symbol: json["Symbol"]??"",
    decimals: json["Decimals"],
  );
  Map<String, dynamic> toJson() => {
    "WalletAddress": walletAddress,
    "ContractAddress": contractAddress,
    "EthereumNetwork": ethereumNetwork?.index,//
    "Chain": chain.index,//Token
    "PrivateKey": privateKey,
    "PublicKey": publicKey,    
    "Symbol": symbol??"",
    "Decimals": decimals    
  };
}
