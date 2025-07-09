import 'dart:async';

import 'package:web3dart/web3dart.dart';

class BalanceTracker {
 // final _controller = StreamController<BigInt>.broadcast();

  // void update(BigInt balance) => _controller.add(balance);

  // Stream<BigInt> get stream => _controller.stream;

  // void dispose() => _controller.close();

  final Map<String, StreamController<BigInt>> _controllers = {};

  void update(EthereumAddress address, BigInt balance) {
    final key = address.hex.toLowerCase();
    _controllers.putIfAbsent(key, () => StreamController<BigInt>.broadcast());
    _controllers[key]!.add(balance);
  }
  Stream<BigInt> watch(EthereumAddress address) {
    final key = address.hex.toLowerCase();
    return _controllers.putIfAbsent(key, () => StreamController<BigInt>.broadcast()).stream;
  }

  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
