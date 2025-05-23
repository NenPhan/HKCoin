import 'dart:convert';

AddWalletToken addWalletTokenFromJson(String str) =>
    AddWalletToken.fromJson(json.decode(str));

String addWalletTokenToJson(AddWalletToken data) => json.encode(data.toJson());

class AddWalletToken {
  int? id;
  int chainNetworkId;
  String? tokenAddress;
  List<AviableChainNetwork>? aviableChainNetwork;

  AddWalletToken({
    this.id,
    required this.chainNetworkId,
    this.tokenAddress,
    this.aviableChainNetwork,    
  });

  factory AddWalletToken.fromJson(Map<String, dynamic> json) => AddWalletToken(
    id: json["Id"],
    chainNetworkId: json["ChainNetworkId"],
    tokenAddress:json["TokenAddress"]??"",
    aviableChainNetwork:
            json["AviableChainNetwork"] == null
                ? []
                : List<AviableChainNetwork>.from(
                  json["AviableChainNetwork"]!.map(
                    (x) => AviableChainNetwork.fromJson(x),
                  ),
                ),    
  );

  Map<String, dynamic> toJson() => {
    "Id": id,   
    "ChainNetworkId": chainNetworkId,
    "TokenAddress": tokenAddress,
    "AviableChainNetwork":
        aviableChainNetwork == null
            ? []
            : List<dynamic>.from(aviableChainNetwork!.map((x) => x.toJson())),    
  };  
}
class AviableChainNetwork {
  int id;
  String name;
  bool selected;

  AviableChainNetwork({
    required this.id,
    required this.name,
    required this.selected
  });

  factory AviableChainNetwork.fromJson(Map<String, dynamic> json) => AviableChainNetwork(
    id:int.parse(json["Value"]),
    name: json["Text"],
    selected: json["Selected"]   
  );

  Map<String, dynamic> toJson() => {
    "Value": id,
    "Text": name,
    "Selected": selected,  
  };
  @override
  String toString() => name;
}