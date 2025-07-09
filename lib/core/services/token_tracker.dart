import 'dart:async';
import 'dart:convert';

import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/data.models/blockchain_transaction.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/token_transfer.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class TokenTracker {
  final _tracked = <String, Set<String>>{};
  final _controller = StreamController<TokenTransfer>.broadcast();

  void trackToken(EthereumAddress token, EthereumAddress user) {
    final contract = token.hex;
    final address = user.hex;
    _tracked.putIfAbsent(contract, () => {}).add(address);
  }

  void handleEvent(dynamic data) {
    final map = jsonDecode(data);
    if (map['params'] != null && map['params']['result'] != null) {
      final result = map['params']['result'];
      final contract = result['address'] as String;
      final topics = result['topics'] as List<dynamic>;
      final transactionHash = result['transactionHash'] as String;
      final blockNumber = result['blockNumber'] as String;
      if (topics.length < 3) return;
      final from = EthereumAddress.fromHex('0x${topics[1].substring(26)}');
      final to = EthereumAddress.fromHex('0x${topics[2].substring(26)}');
      final value = BigInt.parse(result['data'].substring(2), radix: 16);

      if (_tracked[contract]?.contains(to.hex) ?? false) {
        _controller.add(TokenTransfer(
          contract: EthereumAddress.fromHex(contract),
          from: from,
          to: to,
          amount: value,
          transactionHash: transactionHash,
          blockNumber:blockNumber
        ));
      }
    }
  }

  Future<BigInt> getTokenBalance(Web3Client client, EthereumAddress user, EthereumAddress contract) async {
    const tokenAbi = '''
      [
        {
          "constant": true,
          "inputs": [{"name": "owner", "type": "address"}],
          "name": "balanceOf",
          "outputs": [{"name": "balance", "type": "uint256"}],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "decimals",
          "outputs": [{"name": "", "type": "uint8"}],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        }
      ]''';
      final deployedContract = DeployedContract(
        ContractAbi.fromJson(tokenAbi, 'BEP20'),
        contract  
      );
      final balance = await client.call(
        contract: deployedContract,
        function: deployedContract.function('balanceOf'),
        params: [user],
      );   
    return balance.first as BigInt;
  }
  Future<List<BlockChainTransaction>> getTransactionHistory({required Client client,     
    required BlockchangeWalletTokenInfo wallet,
    required String bscScanApiKey,
    int page = 1,
    int offset = 10,
  }) async {
    try {
      var url = 'https://api.bscscan.com/api?module=account&action=tokentx&apikey=$bscScanApiKey'
          '&contractAddress=${wallet.contractAddress}'
          '&address=${wallet.walletAddress}&sort=desc&page=$page&offset=$offset';
      if (wallet.chain == Chain.BNB) {
        url = 'https://api.bscscan.com/api?module=account&action=txlist&apikey=$bscScanApiKey'
            '&address=${wallet.walletAddress}&sort=desc&page=$page&offset=$offset';
      }

      final response = await client.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['status'] == '0') {
        throw Exception('Lỗi API BSCScan: ${data['message']}');
      }      
      if (data['status'] == '1') {
        return (data['result'] as List)
            .where((tx) => BigInt.parse(tx['value'] ?? '0') > BigInt.zero)
            .map((tx) => BlockChainTransaction.fromJson(tx))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Không thể lấy lịch sử giao dịch: $e');
    }
  }

  Stream<TokenTransfer> get transferStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}