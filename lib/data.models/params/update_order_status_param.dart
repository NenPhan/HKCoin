import 'dart:convert';

import 'package:hkcoin/core/enums.dart';

UpdateOrderStatusParam addAddressParamFromJson(String str) =>
    UpdateOrderStatusParam.fromJson(json.decode(str));

String addAddressParamToJson(UpdateOrderStatusParam data) =>
    json.encode(data.toJson());

class UpdateOrderStatusParam {
  int? id;
  String? orderGuid;
  String? walletAddress;
  String? transactionHash;
  String? blockNumber;
  String? from;
  String? to;
  double? amount;
  String? chain;
  String? network;

  UpdateOrderStatusParam({
    this.id,
    this.orderGuid,
    this.walletAddress,
    this.transactionHash,
    this.blockNumber,
    this.from,
    this.to,
    this.amount,
    this.chain,
    this.network,
  });

  factory UpdateOrderStatusParam.fromJson(Map<String, dynamic> json) =>
      UpdateOrderStatusParam(
        id: json["Id"],
        orderGuid: json["OrderGuid"],
        walletAddress: json["WalletAddress"],
        transactionHash: json["TransactionHash"],
        blockNumber: json["BlockNumber"],
        from: json["From"],
        to: json["To"],
        amount: json["Amount"],
        chain: json["Chain"],
        network: json["Network"]
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "OrderGuid":orderGuid,
    "WalletAddress": walletAddress,
    "TransactionHash": transactionHash ?? "",
    "BlockNumber": blockNumber ?? "",
    "From": from,
    "To": to,
    "Amount": amount,
    "Chain": chain,
    "Network": network
  };
}
