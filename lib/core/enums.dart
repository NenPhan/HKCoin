// ignore_for_file: constant_identifier_names

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

enum CreateWalletType { None, Mnemonic, PrivateKey }

enum EthereumNetwork { Default, BEP20, TRON, ERC20 }
enum PasswordRecoveryResultState{Success,Error}

enum Chain { None, HKC, USDT, HTX, BNB }
enum OrderStatus {
  pending(10),
  processing(20),
  complete(30),
  cancelled(40),
  withdrawal(50);
  final int value;
  const OrderStatus(this.value);
}


extension ChainExtension on Chain {
  String get name {
    switch (this) {
      case Chain.None:
        return 'None';
      case Chain.USDT:
        return 'USDT';
      case Chain.HKC:
        return 'HKC';
      case Chain.HTX:
        return 'HTX';
      case Chain.BNB:
        return 'BNB';
    }
  }
}

extension EthereumNetworkExtension on EthereumNetwork {
  String get name {
    switch (this) {
      case EthereumNetwork.Default:
        return 'Default';
      case EthereumNetwork.BEP20:
        return 'BEP20';
      case EthereumNetwork.TRON:
        return 'TRON';
      case EthereumNetwork.ERC20:
        return 'ERC20';
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
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.complete:
        return 'Complete';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.withdrawal:
        return 'Withdrawal';
    }
  } 
}

extension IntToOrderStatus on int {
  OrderStatus toOrderStatus() {
    switch (this) {
      case 10:
        return OrderStatus.pending;
      case 20:
        return OrderStatus.processing;
      case 30:
        return OrderStatus.complete;
      case 40:
        return OrderStatus.cancelled;
      case 50:
        return OrderStatus.withdrawal;
      default:
        throw ArgumentError('Invalid OrderStatus value: $this');
    }
  }
}
extension StringToPasswordRecoveryResultState on String {
  PasswordRecoveryResultState toPasswordRecoveryResultState() {
    switch (toLowerCase()) {
      case 'success':
        return PasswordRecoveryResultState.Success;
      case 'error':
        return PasswordRecoveryResultState.Error;     
      default:
        return PasswordRecoveryResultState.Success; // Hoặc throw Exception nếu muốn bắt lỗi
    }
  }
}
extension StringToPasswordRecoveryResultStateExtension on PasswordRecoveryResultState {
  String get name {
    switch (this) {
      case PasswordRecoveryResultState.Success:
        return 'Success';
      case PasswordRecoveryResultState.Error:
        return 'Error';    
    }
  }
}
extension BooleanToOrderStatus on int {
  PasswordRecoveryResultState toValuePasswordRecoveryResultState() {
    switch (this) {
      case 0:
        return PasswordRecoveryResultState.Success;
      case 1:
        return PasswordRecoveryResultState.Error;
      default:
        throw ArgumentError('Invalid OrderStatus value: $this');
    }
  }
}