import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  List<Item> items;
  int totalQuantity;
  String subTotal;
  bool displayCheckoutButton;
  bool displayShoppingCartButton;
  bool currentCustomerIsGuest;
  bool anonymousCheckoutAllowed;
  bool showProductImages;
  int thumbSize;
  bool displayMoveToWishlistButton;
  bool showBasePrice;

  Cart({
    required this.items,
    required this.totalQuantity,
    required this.subTotal,
    required this.displayCheckoutButton,
    required this.displayShoppingCartButton,
    required this.currentCustomerIsGuest,
    required this.anonymousCheckoutAllowed,
    required this.showProductImages,
    required this.thumbSize,
    required this.displayMoveToWishlistButton,
    required this.showBasePrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    totalQuantity: json["TotalQuantity"],
    subTotal: json["SubTotal"],
    displayCheckoutButton: json["DisplayCheckoutButton"],
    displayShoppingCartButton: json["DisplayShoppingCartButton"],
    currentCustomerIsGuest: json["CurrentCustomerIsGuest"],
    anonymousCheckoutAllowed: json["AnonymousCheckoutAllowed"],
    showProductImages: json["ShowProductImages"],
    thumbSize: json["ThumbSize"],
    displayMoveToWishlistButton: json["DisplayMoveToWishlistButton"],
    showBasePrice: json["ShowBasePrice"],
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "TotalQuantity": totalQuantity,
    "SubTotal": subTotal,
    "DisplayCheckoutButton": displayCheckoutButton,
    "DisplayShoppingCartButton": displayShoppingCartButton,
    "CurrentCustomerIsGuest": currentCustomerIsGuest,
    "AnonymousCheckoutAllowed": anonymousCheckoutAllowed,
    "ShowProductImages": showProductImages,
    "ThumbSize": thumbSize,
    "DisplayMoveToWishlistButton": displayMoveToWishlistButton,
    "ShowBasePrice": showBasePrice,
  };
}

class Item {
  int id;
  bool active;
  int productId;
  String productName;
  String shortDesc;
  String productSeName;
  String unitPrice;
  String minimumCustomerEnteredPrice;
  String maximumCustomerEnteredPrice;
  Image image;
  List<dynamic> bundleItems;
  DateTime createdOnUtc;

  Item({
    required this.id,
    required this.active,
    required this.productId,
    required this.productName,
    required this.shortDesc,
    required this.productSeName,
    required this.unitPrice,
    required this.minimumCustomerEnteredPrice,
    required this.maximumCustomerEnteredPrice,
    required this.image,
    required this.bundleItems,
    required this.createdOnUtc,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["Id"],
    active: json["Active"],
    productId: json["ProductId"],
    productName: json["ProductName"],
    shortDesc: json["ShortDesc"],
    productSeName: json["ProductSeName"],
    unitPrice: json["UnitPrice"],
    minimumCustomerEnteredPrice: json["MinimumCustomerEnteredPrice"],
    maximumCustomerEnteredPrice: json["MaximumCustomerEnteredPrice"],
    image: Image.fromJson(json["Image"]),
    bundleItems: List<dynamic>.from(json["BundleItems"].map((x) => x)),
    createdOnUtc: DateTime.parse(json["CreatedOnUtc"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Active": active,
    "ProductId": productId,
    "ProductName": productName,
    "ShortDesc": shortDesc,
    "ProductSeName": productSeName,
    "UnitPrice": unitPrice,
    "MinimumCustomerEnteredPrice": minimumCustomerEnteredPrice,
    "MaximumCustomerEnteredPrice": maximumCustomerEnteredPrice,
    "Image": image.toJson(),
    "BundleItems": List<dynamic>.from(bundleItems.map((x) => x)),
    "CreatedOnUtc": createdOnUtc.toIso8601String(),
  };
}

class Image {
  int id;
  FileClass file;
  String alt;
  String title;
  String path;
  String thumbUrl;
  int thumbSize;
  bool noFallback;
  bool avataFallback;
  dynamic host;
  bool lazyLoad;

  Image({
    required this.id,
    required this.file,
    required this.alt,
    required this.title,
    required this.path,
    required this.thumbUrl,
    required this.thumbSize,
    required this.noFallback,
    required this.avataFallback,
    required this.host,
    required this.lazyLoad,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["Id"],
    file: FileClass.fromJson(json["file"]),
    alt: json["Alt"],
    title: json["Title"],
    path: json["Path"],
    thumbUrl: json["ThumbUrl"],
    thumbSize: json["ThumbSize"],
    noFallback: json["NoFallback"],
    avataFallback: json["AvataFallback"],
    host: json["Host"],
    lazyLoad: json["LazyLoad"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "file": file.toJson(),
    "Alt": alt,
    "Title": title,
    "Path": path,
    "ThumbUrl": thumbUrl,
    "ThumbSize": thumbSize,
    "NoFallback": noFallback,
    "AvataFallback": avataFallback,
    "Host": host,
    "LazyLoad": lazyLoad,
  };
}

class FileClass {
  int folderId;
  String name;
  String extension;
  String mimeType;
  String mediaType;
  int size;
  int pixelSize;
  int width;
  int height;
  DateTime createdOnUtc;
  DateTime updatedOnUtc;
  bool isTransient;
  List<dynamic> tags;
  List<dynamic> tracks;
  List<dynamic> productMediaFiles;
  int id;

  FileClass({
    required this.folderId,
    required this.name,
    required this.extension,
    required this.mimeType,
    required this.mediaType,
    required this.size,
    required this.pixelSize,
    required this.width,
    required this.height,
    required this.createdOnUtc,
    required this.updatedOnUtc,
    required this.isTransient,
    required this.tags,
    required this.tracks,
    required this.productMediaFiles,
    required this.id,
  });

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
    folderId: json["FolderId"],
    name: json["Name"],
    extension: json["Extension"],
    mimeType: json["MimeType"],
    mediaType: json["MediaType"],
    size: json["Size"],
    pixelSize: json["PixelSize"],
    width: json["Width"],
    height: json["Height"],
    createdOnUtc: DateTime.parse(json["CreatedOnUtc"]),
    updatedOnUtc: DateTime.parse(json["UpdatedOnUtc"]),
    isTransient: json["IsTransient"],
    tags: List<dynamic>.from(json["Tags"].map((x) => x)),
    tracks: List<dynamic>.from(json["Tracks"].map((x) => x)),
    productMediaFiles: List<dynamic>.from(
      json["ProductMediaFiles"].map((x) => x),
    ),
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "FolderId": folderId,
    "Name": name,
    "Extension": extension,
    "MimeType": mimeType,
    "MediaType": mediaType,
    "Size": size,
    "PixelSize": pixelSize,
    "Width": width,
    "Height": height,
    "CreatedOnUtc": createdOnUtc.toIso8601String(),
    "UpdatedOnUtc": updatedOnUtc.toIso8601String(),
    "IsTransient": isTransient,
    "Tags": List<dynamic>.from(tags.map((x) => x)),
    "Tracks": List<dynamic>.from(tracks.map((x) => x)),
    "ProductMediaFiles": List<dynamic>.from(productMediaFiles.map((x) => x)),
    "Id": id,
  };
}
