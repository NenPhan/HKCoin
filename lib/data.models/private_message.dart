import 'dart:convert';
import 'package:hkcoin/core/time_converter.dart';

PrivateMessagePagination orderPaginationFromJson(String str) =>
    PrivateMessagePagination.fromJson(json.decode(str));

String orderPaginationToJson(PrivateMessagePagination data) =>
    json.encode(data.toJson());

class PrivateMessagePagination {
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  int? totalRecords;
  bool? hasNextPage;
  List<PrivateMessage>? privateMessages;

  PrivateMessagePagination({
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,    
    this.hasNextPage,
    this.privateMessages,
  });

  factory PrivateMessagePagination.fromJson(Map<String, dynamic> json) =>
      PrivateMessagePagination(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalPages: json["TotalPages"],
        totalRecords: json["TotalRecords"],
        hasNextPage: (json["PageNumber"] ?? 1) < (json["TotalPages"] ?? 1),
        privateMessages:
            json["Data"] == null
                ? null
                : (json["Data"] as List)
                    .map((e) => PrivateMessage.fromJson(e))
                    .toList(),
      );

  Map<String, dynamic> toJson() => {
    "PageNumber": pageNumber,
    "PageSize": pageSize,
    "TotalPages": totalPages,
    "TotalRecords": totalRecords,
    "Data": privateMessages?.map((e) => e.toJson()).toList() ?? [],
  };
}

class PrivateMessage {
  int? id;
  int? customerId;
  String? subject;
  String? body;
  DateTime? createdOnUtc;
  int? entityId;
  String? entityName;
  bool? isRead;
  bool? isHighlights;

  PrivateMessage({
    this.id,
    this.subject,
    this.body,
    this.createdOnUtc,
    this.entityId,
    this.entityName,
    this.isRead,
    this.isHighlights,  
  });

  factory PrivateMessage.fromJson(Map<String, dynamic> json) => PrivateMessage(
    id: json["Id"]??0,
    subject: json["Subject"],
    body: json["Body"],
    entityId: json["EntityId"],    
    entityName: json["EntityName"],
    isRead: json["IsRead"],
    isHighlights:json["IsHighlights"],
    createdOnUtc:DateTime.parse(json["CreatedOnUtc"]).convertToUserTime(),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Subject": subject,
    "Body": body,
    "EntityId":entityId,
    "EntityName": entityName,
    "IsRead": isRead,
    "IsHighlights": isHighlights,
    "CreatedOnUtc": createdOnUtc?.toIso8601String(),
  };
}
