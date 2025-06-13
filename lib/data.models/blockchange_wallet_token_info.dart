import 'dart:convert';

import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/extensions/extensions.dart';

BlockchangeWalletTokenInfo myWalletFromJson(String str) =>
    BlockchangeWalletTokenInfo.fromJson(json.decode(str));

String blockchangeWalletTokenInfoToJson(BlockchangeWalletTokenInfo data) => json.encode(data.toJson());
class BlockchangeWalletTokenInfo {
  final int? id;
  final String? walletName;
  final String? symbol;
  final int decimals;
  final String? contractAddress;
  final String? walletAddress;
  final int? tokenTypeId;
  double? totalBalance;
  double? balanceUSD;
  final String? mnemonicOrPrivateKey;  
  final String? privateKey;
  final String? publicKey;
  final String? encryptionSalt;  
  final int? createWalletType;
  final EthereumNetwork? ethereumNetwork;
  final int? ethereumNetworkId;
  final Chain? chain;
  final String? iconUrl;
  
  BlockchangeWalletTokenInfo({
    this.id,
    this.walletName,
    this.symbol,
    required this.decimals,
    this.contractAddress,
    this.walletAddress,
    this.tokenTypeId,
    this.totalBalance,
    this.balanceUSD,
    this.mnemonicOrPrivateKey,
    this.privateKey,
    this.publicKey,
    this.encryptionSalt,  
    this.createWalletType,
    this.ethereumNetwork,
    this.ethereumNetworkId,
    this.chain,
    this.iconUrl
  });
  factory BlockchangeWalletTokenInfo.fromJson(Map<String, dynamic> json) => BlockchangeWalletTokenInfo(
    id: json["Id"],
    walletName: json["WalletName"],
    symbol: json["Symbol"],
    decimals: json["Decimals"],
    contractAddress:json["ContractAddress"],
    walletAddress: json["WalletAddress"],
    tokenTypeId: json["TokenTypeId"],
    totalBalance: json["TotalBalance"],
    mnemonicOrPrivateKey: json["MnemonicOrPrivateKey"],
    privateKey: json["PrivateKey"],
    publicKey: json["PublicKey"],
    encryptionSalt: json["EncryptionSalt"],
    createWalletType: json["CreateWalletType"],    
    ethereumNetwork: json["EthereumNetwork"].toString().toEthereumNetwork(), 
    ethereumNetworkId: json["EthereumNetworkId"],  
    chain: json["Chain"].toString().toChain(),  
    iconUrl: json["IconUrl"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "WalletName": walletName,
    "Symbol": symbol,
    "Decimals":decimals,
    "ContractAddress":contractAddress,
    "WalletAddress": walletAddress,
    "TokenTypeId": tokenTypeId,
    "TotalBalance": totalBalance,
    "MnemonicOrPrivateKey": mnemonicOrPrivateKey,
    "PrivateKey": privateKey,
    "PublicKey": publicKey,    
    "EncryptionSalt": encryptionSalt,
    "CreateWalletType": createWalletType,
    "EthereumNetwork":ethereumNetwork,  
    "EthereumNetworkId":ethereumNetworkId,
    "Chain":chain,
    "IconUrl":iconUrl
  };   
}