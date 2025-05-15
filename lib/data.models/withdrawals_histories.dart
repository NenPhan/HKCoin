// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:hkcoin/core/time_converter.dart';

WithDrawalHistoriesPagination orderPaginationFromJson(String str) =>
    WithDrawalHistoriesPagination.fromJson(json.decode(str));

String orderPaginationToJson(WithDrawalHistoriesPagination data) =>
    json.encode(data.toJson());

class WithDrawalHistoriesPagination {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  bool? hasNextPage;
  List<WithDrawalHistories>? withDrawalHistories;

  WithDrawalHistoriesPagination({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,    
    this.hasNextPage,
    this.withDrawalHistories,
  });

  factory WithDrawalHistoriesPagination.fromJson(Map<String, dynamic> json) =>
      WithDrawalHistoriesPagination(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        hasNextPage: (json["PageNumber"] ?? 1) < (json["TotalPages"] ?? 1),
        withDrawalHistories:
            json["Data"] == null
                ? null
                : (json["Data"] as List)
                    .map((e) => WithDrawalHistories.fromJson(e))
                    .toList(),
      );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalPages": totalPages,
    "TotalRecords": totalRecords,
    "Data": withDrawalHistories?.map((e) => e.toJson()).toList() ?? [],
  };
}

class WithDrawalHistories {
  int? id;
  int? customerId;  
  String? amount;
  DateTime? createdOnUtc;  
  String? reason;
  String? customerComments;
  String? amountSwap;
  String? withDrawalSwap;
  String? status;
  int? requestStatusId;
  String? withdrawalPrincipal;

  WithDrawalHistories({
    this.id,
    this.customerId,    
    this.amount,
    this.createdOnUtc,    
    this.reason,
    this.customerComments,
    this.withDrawalSwap,  
    this.amountSwap,
    this.status,
    this.requestStatusId,
    this.withdrawalPrincipal    
  });

  factory WithDrawalHistories.fromJson(Map<String, dynamic> json) => WithDrawalHistories(
    id: json["Id"]??0,
    customerId: json["CustomerId"],    
    amount: json["Amount"],
    createdOnUtc:DateTime.parse(json["CreatedOnUtc"]).convertToUserTime(),      
    reason: json["Reason"],
    customerComments: json["CustomerComments"],
    withDrawalSwap:json["WithDrawalSwap"],
    amountSwap:json["AmountSwap"],
    status:json["Status"],
    requestStatusId:json["RequestStatusId"],
    withdrawalPrincipal:json["WithdrawalPrincipal"]    
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "CustomerId": customerId,    
    "Amount": amount,
    "CreatedOnUtc": createdOnUtc?.toIso8601String(),    
    "Reason": reason,
    "Message": customerComments,
    "WithDrawalSwap": withDrawalSwap,
    "AmountSwap": amountSwap,
    "Status": status,
    "StatusId": requestStatusId,
  };
}
