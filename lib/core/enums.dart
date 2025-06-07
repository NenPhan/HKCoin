// ignore: constant_identifier_names
enum HttpMethod { GET, POST, PUT, DELETE, PATCH }
enum CreateWalletType {None, Mnemonic, PrivateKey }
enum EthereumNetwork { Default, BEP20, TRON, ERC20}
enum Chain { None, HKC, USDT, HTX, BNB}
extension ChainExtension on Chain {
  String get name {
    switch (this) {
      case Chain.None: return 'None';
      case Chain.USDT: return 'USDT';
      case Chain.HKC: return 'HKC';
      case Chain.HTX: return 'HTX';
      case Chain.BNB: return 'BNB';
    }
  }
}
extension EthereumNetworkExtension on EthereumNetwork {
  String get name {
    switch (this) {
      case EthereumNetwork.Default: return 'Default';
      case EthereumNetwork.BEP20: return 'BEP20';
      case EthereumNetwork.TRON: return 'TRON';
      case EthereumNetwork.ERC20: return 'ERC20';      
    }
  }
}