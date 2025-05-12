// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:hkcoin/core/time_converter.dart';

WalletHistoriesPagination orderPaginationFromJson(String str) =>
    WalletHistoriesPagination.fromJson(json.decode(str));

String orderPaginationToJson(WalletHistoriesPagination data) =>
    json.encode(data.toJson());

class WalletHistoriesPagination {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  List<WalletHistories>? walletHistories;

  WalletHistoriesPagination({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.walletHistories,
  });

  factory WalletHistoriesPagination.fromJson(Map<String, dynamic> json) =>
      WalletHistoriesPagination(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        walletHistories:
            json["Data"] == null
                ? null
                : (json["Data"] as List)
                    .map((e) => WalletHistories.fromJson(e))
                    .toList(),
      );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalPages": totalPages,
    "TotalRecords": totalRecords,
    "Data": walletHistories?.map((e) => e.toJson()).toList() ?? [],
  };
}

class WalletHistories {
  int? id;
  int? customerId;
  String? code;
  String? amount;
  DateTime? createdOnUtc;
  String? reasonStr;
  String? reason;
  String? message;
  String? loaiTaiKhoan;
  String? walletType;
  String? status;
  int? statusId;

  WalletHistories({
    this.id,
    this.customerId,
    this.code,
    this.amount,
    this.createdOnUtc,
    this.reasonStr,
    this.reason,
    this.message,
    this.walletType,  
    this.loaiTaiKhoan,
    this.status,
    this.statusId
  });

  factory WalletHistories.fromJson(Map<String, dynamic> json) => WalletHistories(
    id: json["Id"]??0,
    customerId: json["CustomerId"],
    code: json["Code"],
    amount: json["Amount"],
    createdOnUtc:DateTime.parse(json["CreatedOnUtc"]).convertToUserTime(),
    reasonStr: json["ReasonStr"],    
    reason: json["Reason"],
    message: json["Message"],
    walletType:json["WalletType"],
    loaiTaiKhoan:json["LoaiTaiKhoan"],
    status:json["Status"],
    statusId:json["StatusId"]
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "CustomerId": customerId,
    "Code": code,
    "Amount": amount,
    "CreatedOnUtc": createdOnUtc?.toIso8601String(),
    "ReasonStr":reasonStr,
    "Reason": reason,
    "Message": message,
    "WalletType": walletType,
    "LoaiTaiKhoan": loaiTaiKhoan,
    "Status": status,
    "StatusId": statusId,
  };
}
