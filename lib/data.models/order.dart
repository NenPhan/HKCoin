// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:hkcoin/core/time_converter.dart';

OrderPagination orderPaginationFromJson(String str) =>
    OrderPagination.fromJson(json.decode(str));

String orderPaginationToJson(OrderPagination data) =>
    json.encode(data.toJson());

class OrderPagination {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  List<Order>? orders;

  OrderPagination({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
    this.orders,
  });

  factory OrderPagination.fromJson(Map<String, dynamic> json) =>
      OrderPagination(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        orders:
            json["Data"] == null || json["Data"]["Orders"] == null
                ? null
                : (json["Data"]["Orders"] as List)
                    .map((e) => Order.fromJson(e))
                    .toList(),
      );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalPages": totalPages,
    "TotalRecords": totalRecords,
    "Data": {"Orders": orders?.map((e) => e.toJson()).toList() ?? []},
  };
}

class Order {
  int? id;
  String? orderGuid;
  String? orderNumber;
  String? orderTotal;
  String? orderStatus;
  DateTime? createdOn;
  String? productName;
  String? productDesc;

  Order({
    this.id,
    this.orderGuid,
    this.orderNumber,
    this.orderTotal,
    this.orderStatus,
    this.createdOn,
    this.productName,
    this.productDesc,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["Id"],
    orderGuid: json["OrderGuid"],
    orderNumber: json["OrderNumber"],
    orderTotal: json["OrderTotal"],
    orderStatus: json["OrderStatus"],
    createdOn:
        json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]).convertToUserTime(),
    productName: json["ProductName"],
    productDesc: json["ProductDesc"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "OrderGuid": orderGuid,
    "OrderNumber": orderNumber,
    "OrderTotal": orderTotal,
    "OrderStatus": orderStatus,
    "CreatedOn": createdOn?.toIso8601String(),
    "ProductName": productName,
    "ProductDesc": productDesc,
  };
}
