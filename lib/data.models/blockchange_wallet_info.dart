import 'dart:convert';

import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/time_converter.dart';

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
  final String? privateKey;
  final String? publicKey;
  final String? encryptionSalt;  
  final int? createWalletTypeId; 
  final String? createWalletType;
  final DateTime? createdOnUtc;
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
    this.privateKey,
    this.publicKey,
    this.encryptionSalt,
    this.createWalletTypeId,   
    this.createWalletType,
    this.createdOnUtc,
    this.walletAddressModel 
  });
  factory BlockchangeWalletInfo.fromJson(Map<String, dynamic> json) => BlockchangeWalletInfo(
    id: json["Id"],
    name: json["Name"],
    walletAddress: json["WalletAddress"],
    networkId: json["NetworkId"],
    totalBalance: json["TotalBalance"],
    encryptedMnemonic: json["EncryptedMnemonic"],
    privateKey: json["PrivateKey"],
    publicKey: json["PublicKey"],
    encryptionSalt: json["EncryptionSalt"],
    createWalletTypeId: json["CreateWalletTypeId"],
    createWalletType: json["CreateWalletType"],
    createdOnUtc: DateTime.parse(json["CreatedOnUtc"]).convertToUserTime(),
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
    "PrivateKey": privateKey,
    "PublicKey": publicKey,    
    "EncryptionSalt": encryptionSalt,
    "CreateWalletTypeId": createWalletTypeId,
    "CreateWalletType": createWalletType,
    "CreatedOnUtc":createdOnUtc,
    "WalletsModel": walletAddressModel?.map((e) => e.toJson()).toList() ?? [],
  };  
  BlockchangeWalletInfo copyWith({
    String? mnemonicOrPrivateKey,
    String? privateKey,
    String? publicKey,    
  }) {
    return BlockchangeWalletInfo(
      encryptedMnemonic: mnemonicOrPrivateKey ?? this.encryptedMnemonic,
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,            
    );  
  }
}

class WalletsModel {
  final String walletAddress;
  final String contractAddress; 
  final EthereumNetwork? ethereumNetwork;
  final Chain chain;
  double? totalBalance;
  double? totalBalanceUSD;
  final String? symbol;
  final int? decimals;

  WalletsModel({
    required this.walletAddress,
    required this.contractAddress,
    required this.ethereumNetwork,
    required this.chain,
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
    symbol: json["Symbol"]??"",
    decimals: json["Decimals"],
  );
  Map<String, dynamic> toJson() => {
    "WalletAddress": walletAddress,
    "ContractAddress": contractAddress,
    "EthereumNetwork": ethereumNetwork?.index,//
    "Chain": chain.index,//Token
    "Symbol": symbol??"",
    "Decimals": decimals    
  };
}
