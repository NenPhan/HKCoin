// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:hkcoin/core/extensions/extensions.dart';

CustomerDownlines orderPaginationFromJson(String str) =>
    CustomerDownlines.fromJson(json.decode(str));

String orderPaginationToJson(CustomerDownlines data) =>
    json.encode(data.toJson());

class CustomerDownlines {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  bool? hasNextPage;
  List<CustomerDownLineInfo>? customerDownLineInfo;

  CustomerDownlines({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,    
    this.hasNextPage,
    this.customerDownLineInfo,
  });

  factory CustomerDownlines.fromJson(Map<String, dynamic> json) =>
      CustomerDownlines(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        hasNextPage: (json["PageNumber"] ?? 1) < (json["TotalPages"] ?? 1),
        customerDownLineInfo:
            json["Data"] == null
                ? null
                : (json["Data"] as List)
                    .map((e) => CustomerDownLineInfo.fromJson(e))
                    .toList(),
      );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalPages": totalPages,
    "TotalRecords": totalRecords,
    "Data": customerDownLineInfo?.map((e) => e.toJson()).toList() ?? [],
  };
}

class CustomerDownLineInfo {
  int? id;
  int? customerId;  
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? fullName;

  CustomerDownLineInfo({
    this.id,
    this.customerId,    
    this.firstName, 
    this.lastName,
    this.email,
    this.phone,
    this.fullName
  });
  factory CustomerDownLineInfo.fromJson(Map<String, dynamic> json) {
  // Lấy các phần của tên từ JSON
  final parts = [
    json["FirstName"],
    json["LastName"],
  ];

  // Tạo FullName bằng cách lọc các phần không rỗng và join
  final fullName = parts
      .where((part) => part != null && part.toString().isNotEmpty)
      .join(' ')
      .nullIfEmpty;

    return CustomerDownLineInfo(
      id: json["Id"] ?? 0,
      firstName: json["FirstName"] ?? "",
      lastName: json["LastName"] ?? "",
      email: json["Email"],
      phone: json["Phone"],
      fullName: fullName, // Thêm trường fullName vào constructor
    );
  }
  Map<String, dynamic> toJson() => {
    "Id": id,
    "FirstName": firstName,    
    "LastName": lastName,
    "Email": email,
    "Phone": phone
  };
}
