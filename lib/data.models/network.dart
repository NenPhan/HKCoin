import 'package:hkcoin/core/time_converter.dart';

class Network {
  int? id;
  int? chainId;
  String? name;
  String? rpcUrl;
  int? displayOrder;
  bool? networkDefault;  

  Network({
    this.id,
    this.chainId,
    this.name,
    this.rpcUrl,
    this.displayOrder,
    this.networkDefault,    
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
    id: json["Id"],
    chainId: json["ChainId"],
    name: json["Name"],
    rpcUrl: json["RpcUrl"],
    displayOrder: json["DisplayOrder"],
    networkDefault: json["NetworkDefault"],    
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ChainId": chainId,
    "Name": name,
    "RpcUrl": rpcUrl,
    "DisplayOrder": displayOrder,
    "NetworkDefault": networkDefault,    
  };
}