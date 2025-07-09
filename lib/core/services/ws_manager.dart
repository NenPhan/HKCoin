import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _controller = StreamController.broadcast();
  List<String> _urls = [];
  int _retryCount = 0;
  final int _maxRetries = 5;
  final Duration _retryDelay = Duration(seconds: 5);
  bool _isConnecting = false;

  // Danh sách các subscription cần tự động đăng ký lại sau khi reconnect
  final List<_TokenSubscription> _subscriptions = [];

  Future<void> connect(List<String> urls) async {
    if (_isConnecting) return;
    _isConnecting = true;

    _urls = urls;

    for (final url in urls) {
      try {
        _channel = WebSocketChannel.connect(Uri.parse(url));
        _listenToChannel(url);
        print('✅ Connected to $url');

        // Sau khi kết nối lại, đăng ký lại toàn bộ subscription
        _resubscribeAll();

        _isConnecting = false;
        return;
      } catch (e) {
        print('❌ Failed to connect to $url: $e');
        continue;
      }
    }

    print('⚠️ All WebSocket URLs failed. Will retry after delay.');
    _scheduleReconnect();
  }

  void _listenToChannel(String currentUrl) {
    _channel?.stream.listen(
      _controller.add,
      onError: (error) {
        print('❗ WebSocket error on $currentUrl: $error');
        _scheduleReconnect(failedUrl: currentUrl);
      },
      onDone: () {
        print('🔌 WebSocket closed on $currentUrl');
        _scheduleReconnect(failedUrl: currentUrl);
      },
      cancelOnError: true,
    );
  }

  void _scheduleReconnect({String? failedUrl}) {
    if (_retryCount >= _maxRetries) {
      print('⛔ Max reconnect attempts reached.');
      return;
    }

    _retryCount++;
    Future.delayed(_retryDelay, () {
      final remaining = _urls.where((url) => url != failedUrl).toList();
      print('🔁 Reconnecting... attempt $_retryCount');
      connect(remaining.isEmpty ? _urls : remaining);
    });
  }

  void subscribeToTokenTransfers(EthereumAddress contract, EthereumAddress address) {
    // Lưu lại để re-subscribe khi reconnect
    final subscription = _TokenSubscription(contract: contract, address: address);
    if (!_subscriptions.contains(subscription)) {
      _subscriptions.add(subscription);
    }

    final topic = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef';
    final params = {
      'jsonrpc': '2.0',
      'id': DateTime.now().millisecondsSinceEpoch,
      'method': 'eth_subscribe',
      'params': [
        'logs',
        {
          'address': contract.hex,
          'topics': [topic, null, '0x${address.hexNo0x.padLeft(64, '0')}']
        }
      ]
    };

    try {
      _channel?.sink.add(jsonEncode(params));
    } catch (e) {
      print('❌ Error subscribing to token transfer: $e');
    }
  }

  void _resubscribeAll() {
    print('🔄 Resubscribing to ${_subscriptions.length} token subscriptions');
    for (final sub in _subscriptions) {
      subscribeToTokenTransfers(sub.contract, sub.address);
    }
  }

  void listen(void Function(dynamic) handler) {
    _controller.stream.listen(handler);
  }

  String selectWsUrl(List<String> urls) {
    return urls[Random().nextInt(urls.length)];
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
    _subscriptions.clear();
  }
}

// Struct để lưu thông tin đăng ký theo dõi token
class _TokenSubscription {
  final EthereumAddress contract;
  final EthereumAddress address;

  _TokenSubscription({required this.contract, required this.address});

  @override
  bool operator ==(Object other) {
    return other is _TokenSubscription &&
        other.contract.hex.toLowerCase() == contract.hex.toLowerCase() &&
        other.address.hex.toLowerCase() == address.hex.toLowerCase();
  }

  @override
  int get hashCode => '${contract.hex}:${address.hex}'.hashCode;
}
