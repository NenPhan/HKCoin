import 'dart:async';
import 'package:hkcoin/core/services/balance_tracker.dart';
import 'package:hkcoin/core/services/token_tracker.dart';
import 'package:hkcoin/core/services/ws_manager.dart';
import 'package:hkcoin/data.models/blockchain_transaction.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/token_transfer.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class BlockchainService {
  final List<String> _wsUrls;
  final String _bscScanApiKey;
  final Client _httpClient = Client();
  final Web3Client _web3Client;
  final Map<String, Timer> _balanceTimers = {};

  final _wsManager = WebSocketManager();
  final _balanceTracker = BalanceTracker();
  final _tokenTracker = TokenTracker();

  BlockchainService({required List<String> wsUrls, required String bscScanApiKey, required Web3Client web3Client})
      : _wsUrls = wsUrls,
        _bscScanApiKey = bscScanApiKey,
        _web3Client = web3Client {
    _initClient();
  }

  void _initClient() {
    final wsUrl = _wsManager.selectWsUrl(_wsUrls);
    //_web3Client = Web3Client(wsUrl, _httpClient);
  }

  Future<void> init() async {
    await _wsManager.connect(_wsUrls);
    _wsManager.listen((data) => _tokenTracker.handleEvent(data));
  }
  void startTrackingBalance(EthereumAddress address, {Duration interval = const Duration(seconds: 15)}) {
    final key = address.hex.toLowerCase();
    _balanceTimers[key]?.cancel(); // Stop previous timer if exists
    _balanceTimers[key] = Timer.periodic(interval, (_) async {
      try {
        final balance = await _web3Client.getBalance(address);
        _balanceTracker.update(address, balance.getInWei);
      } catch (_) {}
    });
  }

  Future<EtherAmount> getBalance(EthereumAddress address) async {
    return await _web3Client.getBalance(address);
  }

  Future<BigInt> getTokenBalance(EthereumAddress address, EthereumAddress tokenContract, {int decimals = 18}) async {
    return await _tokenTracker.getTokenBalance(_web3Client, address, tokenContract);
  }
  
  Future<List<BlockChainTransaction>> getTransactionHistory({
    required BlockchangeWalletTokenInfo wallet,
    int page = 1,
    int offset = 10,
  }) async {
    return await _tokenTracker.getTransactionHistory(
      client: _httpClient,
      wallet: wallet,
      bscScanApiKey: _bscScanApiKey,
      page: page,
      offset: offset,
    );
  }

  void trackToken(EthereumAddress tokenContract, EthereumAddress userAddress) {
    _tokenTracker.trackToken(tokenContract, userAddress);
    _wsManager.subscribeToTokenTransfers(tokenContract, userAddress);
  }
  Stream<BigInt> watchBalance(EthereumAddress address) {
    return _balanceTracker.watch(address);
  }
  //Stream<BigInt> watchBalance() => _balanceTracker.stream;

  Stream<TokenTransfer> watchTokenTransfers() => _tokenTracker.transferStream;
  void stopTrackingBalance(EthereumAddress address) {
    final key = address.hex.toLowerCase();
    _balanceTimers[key]?.cancel();
    _balanceTimers.remove(key);
  }
  void dispose() {
    _httpClient.close();
    _web3Client.dispose();
    _wsManager.dispose();
    _balanceTracker.dispose();
    _tokenTracker.dispose();
  }
}
