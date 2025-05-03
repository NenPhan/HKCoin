import 'dart:convert';

Slide slideFromJson(String str) => Slide.fromJson(json.decode(str));

String slideToJson(Slide data) => json.encode(data.toJson());

class Slide {
  int? id;
  String? name;
  int? displayOrder;
  bool? showText;
  SlideImage? image;

  Slide({this.id, this.name, this.displayOrder, this.showText, this.image});

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
    id: json["Id"],
    name: json["Name"],
    displayOrder: json["DisplayOrder"],
    showText: json["ShowText"],
    image: json["Image"] == null ? null : SlideImage.fromJson(json["Image"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "DisplayOrder": displayOrder,
    "ShowText": showText,
    "Image": image?.toJson(),
  };
}

class SlideImage {
  int? id;
  FileClass? file;
  String? alt;
  String? title;
  String? path;
  String? thumbUrl;
  int? thumbSize;
  bool? noFallback;
  bool? avataFallback;
  String? host;
  bool? lazyLoad;

  SlideImage({
    this.id,
    this.file,
    this.alt,
    this.title,
    this.path,
    this.thumbUrl,
    this.thumbSize,
    this.noFallback,
    this.avataFallback,
    this.host,
    this.lazyLoad,
  });

  factory SlideImage.fromJson(Map<String, dynamic> json) => SlideImage(
    id: json["Id"],
    file: json["file"] == null ? null : FileClass.fromJson(json["file"]),
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
    "file": file?.toJson(),
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
  int? folderId;
  String? name;
  String? extension;
  String? mimeType;
  String? mediaType;
  int? size;
  int? pixelSize;
  int? width;
  int? height;
  DateTime? createdOnUtc;
  DateTime? updatedOnUtc;
  bool? isTransient;
  List<dynamic>? tags;
  List<dynamic>? tracks;
  List<dynamic>? productMediaFiles;
  int? id;

  FileClass({
    this.folderId,
    this.name,
    this.extension,
    this.mimeType,
    this.mediaType,
    this.size,
    this.pixelSize,
    this.width,
    this.height,
    this.createdOnUtc,
    this.updatedOnUtc,
    this.isTransient,
    this.tags,
    this.tracks,
    this.productMediaFiles,
    this.id,
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
    createdOnUtc:
        json["CreatedOnUtc"] == null
            ? null
            : DateTime.parse(json["CreatedOnUtc"]),
    updatedOnUtc:
        json["UpdatedOnUtc"] == null
            ? null
            : DateTime.parse(json["UpdatedOnUtc"]),
    isTransient: json["IsTransient"],
    tags:
        json["Tags"] == null
            ? []
            : List<dynamic>.from(json["Tags"]!.map((x) => x)),
    tracks:
        json["Tracks"] == null
            ? []
            : List<dynamic>.from(json["Tracks"]!.map((x) => x)),
    productMediaFiles:
        json["ProductMediaFiles"] == null
            ? []
            : List<dynamic>.from(json["ProductMediaFiles"]!.map((x) => x)),
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
    "CreatedOnUtc": createdOnUtc?.toIso8601String(),
    "UpdatedOnUtc": updatedOnUtc?.toIso8601String(),
    "IsTransient": isTransient,
    "Tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "Tracks": tracks == null ? [] : List<dynamic>.from(tracks!.map((x) => x)),
    "ProductMediaFiles":
        productMediaFiles == null
            ? []
            : List<dynamic>.from(productMediaFiles!.map((x) => x)),
    "Id": id,
  };
}
