import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  int id;
  String name;
  String shortDescription;
  Price price;
  ProductImage image;

  Product({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["Id"],
    name: json["Name"],
    shortDescription: json["ShortDescription"],
    price: Price.fromJson(json["Price"]),
    image: ProductImage.fromJson(json["Image"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ShortDescription": shortDescription,
    "Price": price.toJson(),
    "Image": image.toJson(),
  };
}

class ProductImage {
  int id;
  FileClass file;
  String alt;
  String title;
  String path;
  String thumbUrl;
  int thumbSize;
  bool noFallback;
  bool avataFallback;
  String host;
  bool lazyLoad;

  ProductImage({
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

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
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

class Price {
  String finalPrice;
  Saving saving;
  bool isBasePriceEnabled;
  bool hasCalculation;
  bool callForPrice;
  bool customerEntersPrice;
  bool showRetailPriceSaving;
  bool hasDiscount;
  double minimumCustomerEnteredPrice;
  double maximumCustomerEnteredPrice;

  Price({
    required this.finalPrice,
    required this.saving,
    required this.isBasePriceEnabled,
    required this.hasCalculation,
    required this.callForPrice,
    required this.customerEntersPrice,
    required this.showRetailPriceSaving,
    required this.hasDiscount,
    required this.minimumCustomerEnteredPrice,
    required this.maximumCustomerEnteredPrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    finalPrice: json["FinalPrice"],
    saving: Saving.fromJson(json["Saving"]),
    isBasePriceEnabled: json["IsBasePriceEnabled"],
    hasCalculation: json["HasCalculation"],
    callForPrice: json["CallForPrice"],
    customerEntersPrice: json["CustomerEntersPrice"],
    showRetailPriceSaving: json["ShowRetailPriceSaving"],
    hasDiscount: json["HasDiscount"],
    minimumCustomerEnteredPrice: json["MinimumCustomerEnteredPrice"],
    maximumCustomerEnteredPrice: json["MaximumCustomerEnteredPrice"],
  );

  Map<String, dynamic> toJson() => {
    "FinalPrice": finalPrice,
    "Saving": saving.toJson(),
    "IsBasePriceEnabled": isBasePriceEnabled,
    "HasCalculation": hasCalculation,
    "CallForPrice": callForPrice,
    "CustomerEntersPrice": customerEntersPrice,
    "ShowRetailPriceSaving": showRetailPriceSaving,
    "HasDiscount": hasDiscount,
    "MinimumCustomerEnteredPrice": minimumCustomerEnteredPrice,
    "MaximumCustomerEnteredPrice": maximumCustomerEnteredPrice,
  };
}

class Saving {
  bool hasSaving;
  String savingPrice;
  double savingPercent;

  Saving({
    required this.hasSaving,
    required this.savingPrice,
    required this.savingPercent,
  });

  factory Saving.fromJson(Map<String, dynamic> json) => Saving(
    hasSaving: json["HasSaving"],
    savingPrice: json["SavingPrice"],
    savingPercent: json["SavingPercent"],
  );

  Map<String, dynamic> toJson() => {
    "HasSaving": hasSaving,
    "SavingPrice": savingPrice,
    "SavingPercent": savingPercent,
  };
}
