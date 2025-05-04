import 'dart:convert';

OrderTotal orderTotalFromJson(String str) =>
    OrderTotal.fromJson(json.decode(str));

String orderTotalToJson(OrderTotal data) => json.encode(data.toJson());

class OrderTotal {
  int? id;
  bool? isEditable;
  int? totalQuantity;
  String? subTotal;
  bool? allowRemovingSubTotalDiscount;
  String? orderTotalDiscount;
  bool? allowRemovingOrderTotalDiscount;
  String? orderTotal;
  bool? useWallet;
  bool? useWalletCoupon;
  String? walletCouponAmount;

  OrderTotal({
    this.id,
    this.isEditable,
    this.totalQuantity,
    this.subTotal,
    this.allowRemovingSubTotalDiscount,
    this.orderTotalDiscount,
    this.allowRemovingOrderTotalDiscount,
    this.orderTotal,
    this.useWallet,
    this.useWalletCoupon,
    this.walletCouponAmount,
  });

  factory OrderTotal.fromJson(Map<String, dynamic> json) => OrderTotal(
    id: json["Id"],
    isEditable: json["IsEditable"],
    totalQuantity: json["TotalQuantity"],
    subTotal: json["SubTotal"],
    allowRemovingSubTotalDiscount: json["AllowRemovingSubTotalDiscount"],
    orderTotalDiscount: json["OrderTotalDiscount"],
    allowRemovingOrderTotalDiscount: json["AllowRemovingOrderTotalDiscount"],
    orderTotal: json["OrderTotal"],
    useWallet: json["UseWallet"],
    useWalletCoupon: json["UseWalletCoupon"],
    walletCouponAmount: json["WalletCouponAmount"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "IsEditable": isEditable,
    "TotalQuantity": totalQuantity,
    "SubTotal": subTotal,
    "AllowRemovingSubTotalDiscount": allowRemovingSubTotalDiscount,
    "OrderTotalDiscount": orderTotalDiscount,
    "AllowRemovingOrderTotalDiscount": allowRemovingOrderTotalDiscount,
    "OrderTotal": orderTotal,
    "UseWallet": useWallet,
    "UseWalletCoupon": useWalletCoupon,
    "WalletCouponAmount": walletCouponAmount,
  };
}
