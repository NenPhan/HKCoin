import 'dart:convert';

import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/time_converter.dart';
import 'package:hkcoin/data.models/address.dart';

CheckoutData checkoutDataFromJson(String str) =>
    CheckoutData.fromJson(json.decode(str));

String checkoutDataToJson(CheckoutData data) => json.encode(data.toJson());

class CheckoutData {
  String? termsOfService;
  Address? existingAddresses;
  List<dynamic>? warnings;
  CheckoutDataPaymentMethod? paymentMethod;

  CheckoutData({
    this.termsOfService,
    this.existingAddresses,
    this.warnings,
    this.paymentMethod,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
    termsOfService: json["TermsOfService"],
    existingAddresses:
        json["ExistingAddresses"] == null
            ? null
            : Address.fromJson(json["ExistingAddresses"]),
    warnings:
        json["Warnings"] == null
            ? []
            : List<dynamic>.from(json["Warnings"]!.map((x) => x)),
    paymentMethod:
        json["PaymentMethod"] == null
            ? null
            : CheckoutDataPaymentMethod.fromJson(json["PaymentMethod"]),
  );

  Map<String, dynamic> toJson() => {
    "TermsOfService": termsOfService,
    "ExistingAddresses": existingAddresses?.toJson(),
    "Warnings":
        warnings == null ? [] : List<dynamic>.from(warnings!.map((x) => x)),
    "PaymentMethod": paymentMethod?.toJson(),
  };
}

class CheckoutDataPaymentMethod {
  List<PaymentMethodElement>? paymentMethods;
  bool? displayPaymentMethodIcons;
  String? actionName;
  bool? isConfirmPage;
  List<dynamic>? warnings;

  CheckoutDataPaymentMethod({
    this.paymentMethods,
    this.displayPaymentMethodIcons,
    this.actionName,
    this.isConfirmPage,
    this.warnings,
  });

  factory CheckoutDataPaymentMethod.fromJson(Map<String, dynamic> json) =>
      CheckoutDataPaymentMethod(
        paymentMethods:
            json["PaymentMethods"] == null
                ? []
                : List<PaymentMethodElement>.from(
                  json["PaymentMethods"]!.map(
                    (x) => PaymentMethodElement.fromJson(x),
                  ),
                ),
        displayPaymentMethodIcons: json["DisplayPaymentMethodIcons"],
        actionName: json["ActionName"],
        isConfirmPage: json["IsConfirmPage"],
        warnings:
            json["Warnings"] == null
                ? []
                : List<dynamic>.from(json["Warnings"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "PaymentMethods":
        paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    "DisplayPaymentMethodIcons": displayPaymentMethodIcons,
    "ActionName": actionName,
    "IsConfirmPage": isConfirmPage,
    "Warnings":
        warnings == null ? [] : List<dynamic>.from(warnings!.map((x) => x)),
  };
}

class PaymentMethodElement {
  String? paymentMethodSystemName;
  String? name;
  String? fullDescription;
  String? brandUrl;
  String? fee;
  bool? selected;
  bool? requiresInteraction;
  InfoWidget? infoWidget;

  PaymentMethodElement({
    this.paymentMethodSystemName,
    this.name,
    this.fullDescription,
    this.brandUrl,
    this.fee,
    this.selected,
    this.requiresInteraction,
    this.infoWidget,
  });

  factory PaymentMethodElement.fromJson(Map<String, dynamic> json) =>
      PaymentMethodElement(
        paymentMethodSystemName: json["PaymentMethodSystemName"],
        name: json["Name"],
        fullDescription: json["FullDescription"],
        brandUrl: json["BrandUrl"],
        fee: json["Fee"],
        selected: json["Selected"],
        requiresInteraction: json["RequiresInteraction"],
        infoWidget:
            json["InfoWidget"] == null
                ? null
                : InfoWidget.fromJson(json["InfoWidget"]),
      );

  Map<String, dynamic> toJson() => {
    "PaymentMethodSystemName": paymentMethodSystemName,
    "Name": name,
    "FullDescription": fullDescription,
    "BrandUrl": brandUrl,
    "Fee": fee,
    "Selected": selected,
    "RequiresInteraction": requiresInteraction,
    "InfoWidget": infoWidget?.toJson(),
  };
}

class InfoWidget {
  String? componentType;
  int? order;
  bool? prepend;

  InfoWidget({this.componentType, this.order, this.prepend});

  factory InfoWidget.fromJson(Map<String, dynamic> json) => InfoWidget(
    componentType: json["ComponentType"],
    order: json["Order"],
    prepend: json["Prepend"],
  );

  Map<String, dynamic> toJson() => {
    "ComponentType": componentType,
    "Order": order,
    "Prepend": prepend,
  };
}

class CheckoutCompleteData {
  String? message;
  String? notifiesAlert;
  List<dynamic>? warnings;
  OrderComplate order;
  InfoPayment? infoPayment;
  CheckoutCompleteData({
    this.message,
    this.notifiesAlert,
    this.warnings,
    required this.order,
    this.infoPayment,
  });
  factory CheckoutCompleteData.fromJson(Map<String, dynamic> json) =>
      CheckoutCompleteData(
        message: json["Message"],
        notifiesAlert: json["NotifiesAlert"],
        order: OrderComplate.fromJson(json["Order"]),
        infoPayment: InfoPayment.fromJson(json["InfoPayment"]),
      );
}

class OrderComplate {  
  String? orderGuid;
  String? orderNumber;
  String? orderTotal;
  String? orderStatus;
  DateTime? createdOn;
  String? orderWalletTotalStr;
  double? orderWalletTotal;
  double? orderSubtotalInclTax;
  String? coinExtension;
  int? paymentStatusId;
  int? orderStatusId;
  OrderStatus? status;
  OrderComplate({    
    this.orderGuid,
    this.orderNumber,
    this.orderTotal,
    this.orderSubtotalInclTax,
    this.orderStatus,
    this.createdOn,
    this.orderWalletTotalStr,
    this.orderWalletTotal,
    this.coinExtension,
    this.orderStatusId,
    this.paymentStatusId,
    this.status
  });
  factory OrderComplate.fromJson(Map<String, dynamic> json) => OrderComplate(
    orderGuid: json["OrderGuid"],
    orderNumber: json["OrderNumber"],
    orderTotal: json["OrderTotal"],
    orderStatus: json["OrderStatus"],
    orderStatusId: json["OrderStatusId"],
    paymentStatusId: json["PaymentStatusId"],
    status: (json["OrderStatusId"] as int).toOrderStatus(),
    orderWalletTotalStr: json["OrderWalletTotalStr"],
    orderWalletTotal: json["OrderWalletTotal"],
    orderSubtotalInclTax: json["OrderSubtotalInclTax"],
    coinExtension: json["CoinExtension"],
    createdOn:
        json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]).convertToUserTime(),
  );
}

class InfoPayment {
  String? walletAddress;
  String? qRCodePayment;
  InfoPayment({this.walletAddress, this.qRCodePayment});
  factory InfoPayment.fromJson(Map<String, dynamic> json) => InfoPayment(
    walletAddress: json["WalletAddress"],
    qRCodePayment: json["QRCodePayment"],
  );
}
