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
extension StringToEthereumNetwork on String {
  EthereumNetwork toEthereumNetwork() {
    switch (toLowerCase()) {
      case 'bep20':
        return EthereumNetwork.BEP20;
      case 'tron':
        return EthereumNetwork.TRON;
      case 'erc20':
        return EthereumNetwork.ERC20;      
      default:
        return EthereumNetwork.Default; // Hoặc throw Exception nếu muốn bắt lỗi
    }
  }
}
extension StringToChain on String {
  Chain toChain() {
    switch (toLowerCase()) {
      case 'usdt':
        return Chain.USDT;
      case 'hkc':
        return Chain.HKC;
      case 'htx':
        return Chain.HTX;    
      case 'bnb':
        return Chain.BNB;     
      default:
        return Chain.None; // Hoặc throw Exception nếu muốn bắt lỗi
    }
  }
}