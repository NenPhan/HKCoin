import 'package:web3dart/web3dart.dart';

class TokenTransfer {
  final EthereumAddress contract;
  final EthereumAddress from;
  final EthereumAddress to;
  final BigInt amount;
  final String transactionHash;
  final String blockNumber;

  TokenTransfer({required this.contract, required this.from, required this.to, required this.amount, required this.transactionHash, required this.blockNumber});
}
