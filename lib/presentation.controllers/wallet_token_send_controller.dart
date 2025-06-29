import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/extensions/extensions.dart';
import 'package:hkcoin/core/extensions/web3extensions.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/presentation.pages/wallet_token_send_page.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletTokenSendingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  int walletId = 0;
  final listNetwork = <Network>[].obs;
  final wallets = <BlockchangeWallet>[].obs;
  var selectedNetwork = Rxn<Network>();
  var mnemonicWords = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingWallets = false.obs;
  BlockchangeWalletTokenInfo? walletsInfo;
  final TextEditingController walletRecipientController = TextEditingController();
  final TextEditingController walletAmountController = TextEditingController();
  final RxBool isLoadingSubmit = false.obs;
  final RxDouble gasFee = 0.0.obs;
  final RxDouble maxGasFee = 0.0.obs;
  final RxString maxGasFeeChain = 'BNB'.obs;
  final RxString estimatedTime = '<5,222 giây'.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxBool isFeeLoading = false.obs;
  Timer? _debounceTimer;
  int _decimals = 18;
  final double _minBNB = 0.000001;
  final String _rpcUrl = "https://data-seed-prebsc-1-s1.binance.org:8545/";
  late Web3Client _client;
  late Credentials _credentials;
  DeployedContract? _tokenContract;
  late DeployedContract _transferContract;
  final String _contractAddress = "0xd6A1f22c90fd729794b1f7E528b143c0882cf23C";
  BigInt _feePercentage = BigInt.zero;
  String _estimatedFee = '';
 final double _defaultBlockTime = 3.0; // Giá trị mặc định nếu không lấy được block time
  final int _confirmationBlocks = 2; // Số block cần xác nhận
  late Network networkStore;

  @override
  void onInit() {
    final params = Get.arguments is WalletTokenSendingPageParam
        ? Get.arguments as WalletTokenSendingPageParam
        : null;
    initialize(params);
    super.onInit();
  }

  Future<void> initialize(WalletTokenSendingPageParam? params) async {
    if (params != null) {
      walletsInfo = params.wallet;
      await _initializeWeb3();
      await _fetchFeePercentage();
      await _fetchTokenInfo();
    }
  }

  Future<void> _initializeWeb3() async {
    final networkStores = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStores == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }
    networkStore = networkStores;
    _client = Web3Client(networkStore.rpcUrl?? _rpcUrl, http.Client());    
    _credentials = await _client.credentialsFromPrivateKey(decryptText(walletsInfo!.privateKey!, ""));
    const String transferAbi = '''[
      {
        "inputs": [
          {"internalType": "address", "name": "token", "type": "address"},
          {"internalType": "address", "name": "recipient", "type": "address"},
          {"internalType": "uint256", "name": "tokenAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "bnbAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "minBNB", "type": "uint256"}
        ],
        "name": "sendBNBAndToken",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "feePercentage",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint256", "name": "_newFeePercentage", "type": "uint256"}
        ],
        "name": "setFeePercentage",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]''';

    _transferContract = DeployedContract(
      ContractAbi.fromJson(transferAbi, 'HkcTransferBNBAndBEP20'),
      EthereumAddress.fromHex(_contractAddress),
    );
  }

  Future<BigInt> _checkAllowance(double amount) async {   
    final web3Client = Web3Client(networkStore.rpcUrl ?? _rpcUrl, http.Client());
    if (walletsInfo!.symbol == 'BNB') return BigInt.from(0);

    const String tokenAbi = '''[
      {
        "constant": true,
        "inputs": [
          {"name": "_owner", "type": "address"},
          {"name": "_spender", "type": "address"}
        ],
        "name": "allowance",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {"name": "_spender", "type": "address"},
          {"name": "_value", "type": "uint256"}
        ],
        "name": "approve",
        "outputs": [{"name": "", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
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

    final amountInWei =amount.toWei(decimals: _decimals);
    final contract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(walletsInfo!.contractAddress!), // Hợp đồng token BEP-20: 0x377482392014118EBe37662f022939E0b5E5479a
    );

    try {
      final result = await web3Client.call(
        contract: contract,
        function: contract.function('allowance'),
        params: [
          EthereumAddress.fromHex(walletsInfo!.walletAddress!), // Ví người gửi: 0x62e545E56909863EEffe0bAB0Dcfd720ba5Fb53b
          EthereumAddress.fromHex(_contractAddress), // Hợp đồng trung gian: 0xd6A1f22c90fd729794b1f7E528b143c0882cf23C
        ],
      );
      final allowance = result[0] as BigInt;     
      return allowance >= amountInWei ? allowance : BigInt.zero;
    } catch (e) {
      print('Error in _checkAllowance: $e');
      print('- Kiểu lỗi: ${e.runtimeType}');
      print('- Thông báo: ${e.toString()}');
      Get.snackbar('Error', 'Failed to check allowance: ${e.toString()}');
      return BigInt.zero;
    }
  }

  Future<Map<String, dynamic>> approveToken(double amount) async {    
    final web3Client = Web3Client(networkStore.rpcUrl ?? _rpcUrl, http.Client());
    if (walletsInfo!.symbol == 'BNB') {
      return {'success': true, 'message': 'No approval needed for BNB'};
    }

    const tokenAbi = '''[
      {
        "constant": false,
        "inputs": [
          {"name": "_spender", "type": "address"},
          {"name": "_value", "type": "uint256"}
        ],
        "name": "approve",
        "outputs": [{"name": "", "type": "bool"}],
        "type": "function"
      }
    ]''';

    final tokenContract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(walletsInfo!.contractAddress!), // Hợp đồng token BEP-20: 0x377482392014118EBe37662f022939E0b5E5479a
    );

    final amountInWei =amount.toWei(decimals: _decimals);// BigInt.from(amount * 1e18);
    print("rpc approveToken: $amountInWei");
    try {
      final approveFunction = tokenContract.function('approve');
      final approveTx = await web3Client.sendTransaction(
        _credentials,
        Transaction(
          to: EthereumAddress.fromHex(walletsInfo!.contractAddress!), // Hợp đồng token BEP-20
          data: approveFunction.encodeCall([
            EthereumAddress.fromHex(_contractAddress), // Hợp đồng trung gian: 0xd6A1f22c90fd729794b1f7E528b143c0882cf23C
            amountInWei,
          ]),
        ),
        chainId: networkStore.chainId, // BSC Testnet chain ID
      );
      print('Approve transaction sent: $approveTx');

      // Chờ xác nhận giao dịch
      final receipt = await web3Client.getTransactionReceipt(approveTx);
      // if (receipt == null || receipt.status == false) {
      //   throw Exception('Approval transaction failed');
      // }      
      // Kiểm tra lại allowance sau khi phê duyệt
      final newAllowance = await _checkAllowance(amount);
     // print('New allowance after approve: $newAllowance');

      return {
        'success': true,
        'txHash': approveTx,
        'newAllowance': newAllowance,
      };
    } catch (e) {
      print('Error in approveToken: $e');     
      Get.snackbar('Error', 'Failed to approve token: ${e.toString()}');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> validateBalances() async {
    try{                
      var amount = walletAmountController.text.isNotEmpty?walletAmountController.text.toDouble():0.toDouble();
      var amountInWei = walletAmountController.text.isNotEmpty?walletAmountController.text.toDouble().toWei(decimals: _decimals):BigInt.from(0);
      if (walletsInfo!.symbol != 'BNB') {
        final tokenBalance = await getTokenBalance(
          walletsInfo!.walletAddress!,
          walletsInfo!.contractAddress!,
          _client,
        );        
        final balanceInWei =BigInt.from(tokenBalance['balance']).toWei(decimals: _decimals);// BigInt.from(tokenBalance['balance'] * pow(10, _decimals));        
        if (balanceInWei < amountInWei) {
          return {
            'success': false,
            'message': tr("Account.wallet.InsufficientTokenBalance")
                .replaceAll('{0}', '$amount')
                .replaceAll('{1}', walletsInfo!.symbol!)
                .replaceAll('{2}', '${walletsInfo!.totalBalance}'),
          };
        }
      }    
      final estimatedFee = await _estimateGasFee(walletRecipientController.text, amount);       
      if (!estimatedFee['success']) {
        return {
          'success': false,
          'message': estimatedFee['message'],
        };
      }
    
      return {'success': true};    
    }catch(e){
      return {
        'success': false,
        'message': tr("Account.wallet.BalanceCheckFailed"),
      };
    }
  }
  Future<Map<String, dynamic>> sendBNBAndToken(String recipient, double amount) async {
    try {
      final isBNB = walletsInfo!.symbol == 'BNB';
      final amountInWei = amount.toWei(decimals: _decimals, isBNB: isBNB);
      // final amountInWei = isBNB
      //     ? BigInt.parse((amount * 1e18).toStringAsFixed(0))
      //     : BigInt.from(amount * 1e18);
      final minBNBInWei =_minBNB.toWei(decimals: _decimals); 

      // Kiểm tra và phê duyệt allowance nếu cần
      if (!isBNB && amountInWei > BigInt.zero) {
        final allowance = await _checkAllowance(amount);
        if (allowance < amountInWei) {
          final approveResult = await approveToken(amount);
          if (!approveResult['success']) {
            return {
              'success': false,
              'error': 'Approval failed: ${approveResult['error']}',
            };
          }
        }
      }

      // Gửi giao dịch chuyển tiền qua hợp đồng trung gian
      final function = _transferContract.function('sendBNBAndToken');
      final gasPrice = await _client.getGasPrice();
      final transaction = Transaction(
        to: EthereumAddress.fromHex(_contractAddress),
        value: EtherAmount.inWei(minBNBInWei),
        gasPrice: gasPrice,
        data: function.encodeCall([
          EthereumAddress.fromHex(isBNB ? '0x0000000000000000000000000000000000000000' : walletsInfo!.contractAddress!),
          EthereumAddress.fromHex(recipient), // Ví người nhận
          isBNB ? BigInt.zero : amountInWei,
          isBNB ? amountInWei : BigInt.zero,
          minBNBInWei,
        ]),
      );

      final txHash = await _client.sendTransaction(
        _credentials,
        transaction,
        chainId: networkStore.chainId, // BSC Testnet chain ID 97,56
      );
      

      // Chờ giao dịch được xác nhận
      final receipt = await waitForTransactionReceipt(txHash, confirmations: 1);
     // final receipt = await _client.getTransactionReceipt(txHash);
      if (receipt == null || receipt.status == false) {
        throw Exception('Transaction failed');
      }      
      return {
        'success': true,
        'txHash': txHash,
      };
    } catch (e) {
      print('Error in sendBNBAndToken: $e');
      Get.snackbar('Error', 'Failed to send transaction: ${e.toString()}');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  Future<TransactionReceipt?> waitForTransactionReceipt(
    String txHash, {
    int confirmations = 1,
    Duration timeout = const Duration(minutes: 1),
  }) async {
    final deadline = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(deadline)) {
      final receipt = await _client.getTransactionReceipt(txHash);
      
      if (receipt != null) {
        if (confirmations <= 1) return receipt;
        
        final current = await _client.getBlockNumber();
        final confirmedBlocks = current - receipt.blockNumber.blockNum;
        
        if (confirmedBlocks >= confirmations) {
          return receipt;
        }
      }
      
      await Future.delayed(const Duration(seconds: 1));
    }
    
    throw TimeoutException('Transaction not confirmed after $timeout');
  }
  Future<void> _fetchFeePercentage() async {
    try {
      final function = _transferContract.function('feePercentage');
      final result = await _client.call(
        contract: _transferContract,
        function: function,
        params: [],
      );
      _feePercentage = result[0] as BigInt;      
    } catch (e) {
      print('Error in _fetchFeePercentage: $e');
    }
  }

  Future<void> _fetchTokenInfo() async {
    // if (walletsInfo!.walletAddress == '0x0000000000000000000000000000000000000000') {
    //   _checkTokenBalance();
    //   return;
    // }

    try {
      const String tokenAbi = '''[
      {
        "constant": true,
        "inputs": [
          {"name": "_owner", "type": "address"},
          {"name": "_spender", "type": "address"}
        ],
        "name": "allowance",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": false,
        "inputs": [
          {"name": "_spender", "type": "address"},
          {"name": "_value", "type": "uint256"}
        ],
        "name": "approve",
        "outputs": [{"name": "", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
      },
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

      _tokenContract = DeployedContract(
        ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
        EthereumAddress.fromHex(walletsInfo!.contractAddress!),
      );
      // Fetch decimals from the token contract
    final decimalsResult = await _client.call(
      contract: _tokenContract!,
      function: _tokenContract!.function('decimals'),
      params: [],
    );
    _decimals = (decimalsResult[0] as BigInt).toInt();
      await _checkTokenBalance();
    } catch (e) {
      print('Lỗi _fetchTokenInfo: $e');
    }
  }

  Future<void> _checkTokenBalance() async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }
    if (walletsInfo!.chain == 'BNB') {
      return;
    }

    try {
      final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
      try {
        if (walletsInfo!.chain == Chain.BNB) {
          var bnb = await web3Client.getBalance(
            EthereumAddress.fromHex(walletsInfo!.walletAddress!),
          );
          walletsInfo!.totalBalance = bnb.getInWei.toDouble().fromWeiToBNB(decimals: _decimals);
          walletsInfo!.balanceUSD = walletsInfo!.totalBalance! * 665;
        } else if (walletsInfo!.chain != Chain.BNB) {         
          final result = await getTokenBalance(
            walletsInfo!.walletAddress!,
            walletsInfo!.contractAddress!,
            web3Client,
          );         
          walletsInfo!.totalBalance = result['balance'].toDouble();
        }
      } catch (e) {
        debugPrint('Lỗi khi lấy số dư BNB: $e');
      }

      final function = _tokenContract!.function('balanceOf');
      final result = await _client.call(
        contract: _tokenContract!,
        function: function,
        params: [EthereumAddress.fromHex(_credentials.address.hex)],
      );      
    } catch (e) {
      print('Lỗi _checkTokenBalance: $e');
    }
  }

  String _formatAddress(String? address) {
    if (address == null || address.length < 12) {
      return 'N/A';
    }
    return '${address.substring(0, 7)}...${address.substring(address.length - 5)}';
  }

  Future<Map<String, dynamic>> getTokenBalance(
      String walletAddress, String tokenAddress, Web3Client web3client) async {
    const tokenAbi = '''[
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

    final contract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(tokenAddress),
    );
    try {
      final decimals = await web3client.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      final decimalsValue = decimals[0] as BigInt;

      final balance = await web3client.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [EthereumAddress.fromHex(walletAddress)],
      );
      final rawBalance = balance[0] as BigInt;

      final balanceValue = rawBalance / BigInt.from(10).pow(decimalsValue.toInt());

      return {
        'balance': balanceValue.toDouble(),
        'decimals': decimalsValue.toInt(),
        'rawBalance': rawBalance.toString(),
      };
    } catch (e) {
      throw Exception('Failed to get token balance: $e');
    }
  }
 
  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(number);
  }

  void onAmountChanged(String value) {
    _debounceTimer?.cancel();
    if (value.isEmpty) {
      isFeeLoading.value = false;
      gasFee.value = 0.0;
      estimatedTime.value = '';
      totalAmount.value = 0.0;
      update(["wallet-token-sending-page"]);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      final amount = double.tryParse(value) ?? 0.0;
      if (amount > 0) {
        calculateFee(amount);
      }
    });
  }

  Future<void> calculateFee(double amount) async {
    _debounceTimer?.cancel();
    isFeeLoading.value = true;
    update(["wallet-token-sending-page"]);
    final recipient = walletRecipientController.text;
    amount = walletAmountController.text.isEmpty ? 0 : walletAmountController.text.toDouble();
    if (recipient.isNotEmpty && amount > 0) {
      final estimatedFee = await _estimateGasFee(recipient, amount);    
      if (estimatedFee['success']) {
        maxGasFee.value = estimatedFee['gasFee'].toString().toDouble();// .toStringAsFixed(8);
        estimatedTime.value = estimatedFee['estimatedTime'];
        _estimatedFee =
            'Gas Fee: ${estimatedFee['gasFee'].toStringAsFixed(8)} BNB\nService Fee: ${estimatedFee['serviceFee'].toStringAsFixed(8)} BNB\nTotal: ${estimatedFee['totalBNB'].toStringAsFixed(8)} BNB';
      } else {
        _estimatedFee = estimatedFee['message'];
        estimatedTime.value = 'N/A';
      }
    }else{      
        estimatedTime.value = 'N/A';
    }

    await Future.delayed(const Duration(milliseconds: 500));
    gasFee.value = maxGasFee.value;
   // estimatedTime.value = '<5,222 giây';
    totalAmount.value = amount + gasFee.value;
    isFeeLoading.value = false;
    update(["wallet-token-sending-page"]);
  }

  Future<Map<String, dynamic>> _estimateGasFee(String recipient, double amount) async {
  try {
    // Kiểm tra địa chỉ người nhận
    if (!RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(recipient)) {    
      return {
          'success': false,
          'message': tr("Checkout.Payment.Order.Recipient")
        }; 
    }
   
    final isBNB = walletsInfo!.symbol == 'BNB';
    final amountInWei =amount.toWei(decimals: _decimals,isBNB: isBNB);
    final minBNBInWei =_minBNB.toWei(decimals: _decimals);
    
    // Kiểm tra số dư BNB của ví người gửi
    final bnbBalance = await _client.getBalance(EthereumAddress.fromHex(walletsInfo!.walletAddress!));   
    if (isBNB && bnbBalance.getInWei < amountInWei) {
      return {
        'success': false,
        'message': tr("Checkout.Payment.Order.InsufficientBNBForFee").replaceAll('{0}', '${bnbBalance.getInWei.toDouble().fromWeiToBNB(decimals: _decimals)} BNB')
      };       
    }
    if (isBNB) {
      // Ước tính gas cho chuyển BNB
      final gasPrice = await _client.getGasPrice();
      final transferGas = await _client.estimateGas(
        sender: _credentials.address,
        to: EthereumAddress.fromHex(recipient),
        value: EtherAmount.inWei(amountInWei),
      );
      
      final gasFeeInWei = gasPrice.getInWei * transferGas;
      final gasFeeInBNB = gasFeeInWei / BigInt.from(10).pow(_decimals);

      // Tính thời gian ước tính
      final blockTime = await _getBlockTime();
      final estimatedSeconds = blockTime * _confirmationBlocks;
      final formattedEstimatedTime = _formatEstimatedTime(estimatedSeconds);

      return {
        'success': true,
        'gasFee': gasFeeInBNB.toDouble(),
        'serviceFee': 0.0, // Không có phí dịch vụ cho chuyển BNB thông thường
        'totalBNB': gasFeeInBNB.toDouble(),
        'estimatedTime': formattedEstimatedTime,
      };
    }else{
      // Kiểm tra số dư token (nếu không phải BNB)
      BigInt approveGas = BigInt.zero;
      BigInt allowance = BigInt.zero;
      if (!isBNB && amountInWei > BigInt.zero) {
        final tokenBalance = await getTokenBalance(
          walletsInfo!.walletAddress!, // 0x62e545E56909863EEffe0bAB0Dcfd720ba5Fb53b
          walletsInfo!.contractAddress!, // 0x377482392014118EBe37662f022939E0b5E5479a
          _client,
        );              
        var balance = BigInt.from(tokenBalance['balance'].toDouble()).toWei(decimals: _decimals);        
        if (balance < amountInWei) {
          return {
            'success': false,
            'message': tr('Insufficient token balance. Available: ${tokenBalance['balance']}')
          };             
        }

        // Kiểm tra allowance
        allowance = await _checkAllowance(amount);      
        if (allowance < amountInWei) {
          if (_tokenContract == null) {
            return {
              'success': false,
              'message': 'Token contract not initialized'
            };               
          }
          final approveResult = await approveToken(amount);
            if (!approveResult['success']) {
              return {
                'success': false,
                'error': 'Approval failed: ${approveResult['error']}',
              };
            }       
        }
      }

      // Ước tính gas cho sendBNBAndToken
      final function = _transferContract.function('sendBNBAndToken');
      final gasPrice = await _client.getGasPrice().catchError((e) {
        print('Failed to get gas price: $e');
        throw Exception('Failed to get gas price: $e');
      });    

      try {
        final transferGas = await _client.estimateGas(
          sender: _credentials.address,
          to: EthereumAddress.fromHex(_contractAddress), // 0xd6A1f22c90fd729794b1f7E528b143c0882cf23C
          value: EtherAmount.inWei(minBNBInWei),
          data: function.encodeCall([
            EthereumAddress.fromHex(isBNB ? '0x0000000000000000000000000000000000000000' : walletsInfo!.contractAddress!),
            EthereumAddress.fromHex(recipient),
            isBNB ? BigInt.zero : amountInWei,
            isBNB ? amountInWei : BigInt.zero,
            minBNBInWei,
          ]),
        );      
        final gasFeeInWei = gasPrice.getInWei * (approveGas + transferGas);
        final totalBNBInWei = gasFeeInWei + minBNBInWei;
        final totalBNB = totalBNBInWei / BigInt.from(10).pow(_decimals);

        final serviceFeeInWei = (minBNBInWei * _feePercentage) / BigInt.from(10000);
        final serviceFeeInBNB = BigInt.from(serviceFeeInWei) / BigInt.from(10).pow(_decimals);
        final blockTime = await _getBlockTime();
          final estimatedSeconds = blockTime * _confirmationBlocks;
          final formattedEstimatedTime = _formatEstimatedTime(estimatedSeconds);

        return {
          'success': true,
          'gasFee': gasFeeInWei / BigInt.from(10).pow(_decimals),
          'serviceFee': serviceFeeInBNB,
          'totalBNB': totalBNB,
          'minBNB': _minBNB,
          'needsApproval': !isBNB && amountInWei > BigInt.zero && allowance < amountInWei,
          'estimatedTime': formattedEstimatedTime,
        };
      } catch (e) {
        print('Failed to estimate transfer gas: $e');
        return {
          'success': false,
          'message': 'Failed to estimate transfer gas: $e',
        }; 
      }
    }    
  } catch (e) {
    print('Error in _estimateGasFee: $e');
    return {
      'success': false,
      'message': 'Error in _estimateGasFee: $e',
    };
  }
}
String _formatEstimatedTime(double seconds) {
    if (seconds < 60) {
      return '${seconds.toStringAsFixed(0)} giây';
    } else {
      final minutes = (seconds / 60).floor();
      final remainingSeconds = (seconds % 60).toStringAsFixed(0);
      return '$minutes phút $remainingSeconds giây';
    }
  }
Future<double> _getBlockTime() async {
  try {
    final startBlock = await _client.getBlockNumber();   
    //await Future.delayed(const Duration(seconds: 1)); // Chờ 10 giây
    final endBlock = await _client.getBlockNumber();    
    final blocks = endBlock - startBlock;
    if (blocks > 0) {
      final blockTime = 10.0 / blocks;      
      return blockTime;
    } else {      
      return _defaultBlockTime;
    }
  } catch (e) {    
    return _defaultBlockTime; // Trả về giá trị mặc định nếu có lỗi
  }
}
}