import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/extensions/extensions.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/data.repositories/wallet_repository.dart';
import 'package:hkcoin/presentation.pages/wallet_token_send_page.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletTokenSendingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  int walletId=0;
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
  final RxDouble gasFee = 0.0.obs; // Phí mạng tính bằng BNB
  final RxDouble maxGasFee = 0.0.obs; // Phí mạng tối đa
  final RxString maxGasFeeChain = 'BNB'.obs; // Thời gian ước tính
  final RxString estimatedTime = '<5,222 giây'.obs; // Thời gian ước tính
  final RxDouble totalAmount = 0.0.obs; // Tổng số tiền (token + phí)
  final RxBool isFeeLoading = false.obs;
   Timer? _debounceTimer;
   int _decimals = 18;
   final double _minBNB = 0.00001; 
   final String _rpcUrl = "https://data-seed-prebsc-1-s1.binance.org:8545/"; // BSC Testnet
 late Web3Client _client;
 late Credentials _credentials;
 DeployedContract? _tokenContract;
 late DeployedContract _transferContract;
 final String _contractAddress = "0xd6A1f22c90fd729794b1f7E528b143c0882cf23C"; 
  BigInt _feePercentage = BigInt.zero;
   String _estimatedFee = '';

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
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }   
     _client =Web3Client(_rpcUrl, http.Client());      
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
  Future getNetworks() async {        
    await handleEitherReturn(await WalletRepository().getNetworks(), (
      r,
    ) async {      
       final uniqueNetworks = {
        for (var e in r) e.id: e
      }.values.toList();
      listNetwork.value = uniqueNetworks;
      try{
        final networkStore = await Storage().getNetWork();
        if (networkStore == null || listNetwork.isEmpty) {
          var network = listNetwork.firstWhere(
            (e) => e.networkDefault ?? false,
            orElse: () => listNetwork.first,
          );          
         await Storage().saveNetWork(network); 
          selectedNetwork.value = network;     
          listNetwork.value.sort((a, b) {
            if (a.id == network.id) return -1;
            if (b.id == network.id) return 1;
            return 0;
          });                             
        }else{
          selectedNetwork.value = networkStore; 
          listNetwork.value.sort((a, b) {
            if (a.id == networkStore.id) return -1;
            if (b.id == networkStore.id) return 1;
            return 0;
          });
        }                   
      }catch(e){
        rethrow;
      }      
    });
      update(["wallet-info-page"]); 
  }
  Future filterNetworks(String query) async {      
    if (query.isEmpty) {
      listNetwork.assignAll(listNetwork); // Nếu không có query, hiển thị tất cả
    } else {
      listNetwork.assignAll(
        listNetwork.where((network) =>
            network.name!.toLowerCase().contains(query.toLowerCase())).toList(),
      ); // Lọc mạng theo tên
    }    
  }
 
  Future getWalletInfo(int walletId) async {
    isLoading.value = true;    
    update(["wallet-token-detail-page"]);   
      await handleEither(await WalletRepository().getWalletTokenById(walletId), (r) {
        if(r !=null){
          walletsInfo = r;                                
          fetchWalletBalance(walletsInfo!);     
        }
      });
   
    isLoading.value = false;
    update(["wallet-token-detail-page"]);
  }
  Future fetchWalletBalance(BlockchangeWalletTokenInfo wallet) async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }    
   // walletInfos.clear();
    //wallets.walletAddressFormat = _formatAddress(wallets.walletAddress);
    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());    
    try {                            
      if(wallet.chain==Chain.BNB){
        var bnb = await web3Client.getBalance(EthereumAddress.fromHex(wallet.walletAddress!));
        wallet.totalBalance = fromWeiToBNB(bnb.getInWei.toDouble());     
        wallet.balanceUSD = wallet.totalBalance!*665;                        
      }else if(wallet.chain!=Chain.BNB){
        final result = await getTokenBalance(
          wallet.walletAddress!, 
          wallet.contractAddress!,
          web3Client,
        );          
        wallet.totalBalance = result['balance'].toDouble();                  
        // if(wallet.chain==Chain.USDT){
        //   totalBalance+=wallet.totalBalance!;
        // }                                   
      }                 
    } catch (e) {
      debugPrint('Lỗi khi lấy số dư BNB: $e');
      //Get.snackbar('Error', 'Lỗi khi lấy số dư BNB: $e');
    }                        
    update(["wallet-token-detail-page"]);    
    //wallet.unit = unit;
    web3Client.dispose();
  }
  @override
  void onClose() {   
    _debounceTimer?.cancel(); 
    super.onClose();
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
     print("Phần trăm phí: $_feePercentage");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchTokenInfo() async {
    if (walletsInfo!.walletAddress == '0x0000000000000000000000000000000000000000') {
      // setState(() {
      //   _tokenName = 'BNB';
      //   _tokenSymbol = 'BNB';
      //   _decimals = 18;
      //   _tokenInfo = 'Asset: BNB';
      // });
      _checkTokenBalance();
      return;
    }

    try {
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

    // Tạo contract instance
    _tokenContract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(walletsInfo!.walletAddress!),
    );
    //  final ssss = await _client.call(
    //     contract: _tokenContract!,
    //     function: _tokenContract!.function('balanceOf'),
    //     params: [EthereumAddress.fromHex(walletsInfo!.walletAddress!)],
    //   );
      // const String tokenAbi = '''[
      //   {
      //     "constant": true,
      //     "inputs": [],
      //     "name": "name",
      //     "outputs": [{"name": "", "type": "string"}],
      //     "type": "function"
      //   },
      //   {
      //     "constant": true,
      //     "inputs": [],
      //     "name": "symbol",
      //     "outputs": [{"name": "", "type": "string"}],
      //     "type": "function"
      //   },
      //   {
      //     "constant": true,
      //     "inputs": [],
      //     "name": "decimals",
      //     "outputs": [{"name": "", "type": "uint8"}],
      //     "type": "function"
      //   },
      //   {
      //     "constant": true,
      //     "inputs": [
      //       {"name": "_owner", "type": "address"}
      //     ],
      //     "name": "balanceOf",
      //     "outputs": [{"name": "balance", "type": "uint256"}],
      //     "type": "function"
      //   },
      //   {
      //     "constant": true,
      //     "inputs": [
      //       {"name": "_owner", "type": "address"},
      //       {"name": "_spender", "type": "address"}
      //     ],
      //     "name": "allowance",
      //     "outputs": [{"name": "", "type": "uint256"}],
      //     "type": "function"
      //   },
      //   {
      //     "constant": false,
      //     "inputs": [
      //       {"name": "_spender", "type": "address"},
      //       {"name": "_value", "type": "uint256"}
      //     ],
      //     "name": "approve",
      //     "outputs": [{"name": "", "type": "bool"}],
      //     "type": "function"
      //   }
      // ]''';

      // _tokenContract = DeployedContract(
      //   ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      //   EthereumAddress.fromHex(walletsInfo!.walletAddress!),
      // );

      // final nameFunction = _tokenContract!.function('name');
      // final symbolFunction = _tokenContract!.function('symbol');
      // final decimalsFunction = _tokenContract!.function('decimals');

      // final nameResult = await _client.call(
      //   contract: _tokenContract!,
      //   function: nameFunction,
      //   params: [],
      // );
      // print(nameResult[0]);
      // final symbolResult = await _client.call(
      //   contract: _tokenContract!,
      //   function: symbolFunction,
      //   params: [],
      // );
      // final decimalsResult = await _client.call(
      //   contract: _tokenContract!,
      //   function: decimalsFunction,
      //   params: [],
      // );

      // setState(() {
      //   _tokenName = nameResult[0] as String;
      //   _tokenSymbol = symbolResult[0] as String;
      //   _decimals = (decimalsResult[0] as BigInt).toInt();
      //   _tokenInfo = 'Token: $_tokenName ($_tokenSymbol)';
      // });

      //_updateSelectedToken();
      await _checkTokenBalance();
    } catch (e) {
       print('Lỗi _fetchTokenInfo: $e');
      // setState(() {
      //   _tokenInfo = 'Error fetching token info: $e';
      // });
    }
  }
  Future<void> _checkTokenBalance() async {
     final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }
    if (walletsInfo!.chain == 'BNB') {
      // setState(() {
      //   _tokenBalance = _balance;
      //   _tokenBalanceStatus = _balanceStatus;
      // });
      return;
    }

    try {
      print("wallet address: ${_credentials.address}");
      // if (_tokenContract == null) {
      //   print('Token contract not initialized');
      //   return;
      // }
      
    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
      try {
      if (walletsInfo!.chain == Chain.BNB) {
        var bnb = await web3Client.getBalance(
          EthereumAddress.fromHex(walletsInfo!.walletAddress!),
        );
        walletsInfo!.totalBalance = fromWeiToBNB(bnb.getInWei.toDouble());
        walletsInfo!.balanceUSD = walletsInfo!.totalBalance! * 665;
      } else if (walletsInfo!.chain != Chain.BNB) {
        final result = await getTokenBalance(
          walletsInfo!.walletAddress!,
          walletsInfo!.contractAddress!,
          web3Client,
        );
        walletsInfo!.totalBalance = result['balance'].toDouble();
        // if(wallet.chain==Chain.USDT){
        //   totalBalance+=wallet.totalBalance!;
        // }
      }
    } catch (e) {
      debugPrint('Lỗi khi lấy số dư BNB: $e');
      //Get.snackbar('Error', 'Lỗi khi lấy số dư BNB: $e');
    }
    
      final function = _tokenContract!.function('balanceOf');
      final result = await _client.call(
        contract: _tokenContract!,
        function: function,
        params: [EthereumAddress.fromHex(_credentials.address.hex)],
      );
      print("balanceOf: ${result[0].toDouble()}");
      // setState(() {
      //   _tokenBalance = result[0] as BigInt;
      //   _tokenBalanceStatus =
      //       '$_tokenSymbol Balance: ${(_tokenBalance / BigInt.from(10).pow(_decimals)).toStringAsFixed(8)}';
      // });
    } catch (e) {
      print('Lỗi _checkTokenBalance: $e');
      if (e is RangeError) {
        print('Address format issue: ${_credentials.address}');
      }
      // setState(() {
      //   _tokenBalanceStatus = 'Error checking token balance: $e';
      // });
    }
  }

  String _formatAddress(String? address) {
    if (address == null || address.length < 12) {
      return 'N/A';
    }
    return '${address.substring(0, 7)}...${address.substring(address.length - 5)}';
  }
  Future<Map<String, dynamic>> getTokenBalance(
    String walletAddress, 
    String tokenAddress,
    Web3Client web3client) async {
  
  // ABI của token (chỉ cần các hàm balanceOf và decimals)
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

    // Tạo contract instance
    final contract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(tokenAddress),
    );    
    try {
      // Lấy số decimals
      final decimals = await web3client.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      final decimalsValue = decimals[0] as BigInt;

      // Lấy balance
      final balance = await web3client.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [EthereumAddress.fromHex(walletAddress)],
      );
      final rawBalance = balance[0] as BigInt;

      // Tính toán số dư thực tế
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
  double fromWeiToBNB(double weiAmount, {int decimals = 18}) {       
    return weiAmount / (BigInt.from(10).pow(decimals)).toDouble();
  }
  BigInt toWei(String value, {int decimals = 18}) {
    if (!value.contains('.')) {
      return BigInt.parse(value + '0' * decimals);
    }

    final parts = value.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Cắt hoặc đệm cho phần thập phân đủ độ dài
    String fullDecimal = (decimalPart + '0' * decimals).substring(0, decimals);

    return BigInt.parse(integerPart + fullDecimal);
  }
  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Locale Đức (dùng dấu . cho nghìn)
    return formatter.format(number);
  }
  void onAmountChanged(String value) {
    // Hủy timer nếu đang chờ
    _debounceTimer?.cancel();
    
    if (value.isEmpty) {
      isFeeLoading.value = false;
      gasFee.value = 0.0;
      estimatedTime.value = '';
      totalAmount.value = 0.0;
      update(["wallet-token-sending-page"]);
      return;
    }
    
    // Bắt đầu timer mới
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
      final feeData = await _estimateGasFee(recipient, amount);
      if (!feeData.containsKey('error')) {
        maxGasFee.value=feeData['gasFee'].toStringAsFixed(8);
         _estimatedFee =
              'Gas Fee: ${feeData['gasFee'].toStringAsFixed(8)} BNB\nService Fee: ${feeData['serviceFee'].toStringAsFixed(8)} BNB\nTotal: ${feeData['totalBNB'].toStringAsFixed(8)} BNB';
      }else{
        _estimatedFee = feeData['error'];
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập thời gian tính toán
    gasFee.value = maxGasFee.value;
    estimatedTime.value = '<5,222 giây'; // Có thể thay đổi dựa trên gas price
    
    // Tính tổng số tiền (nếu cần)
    totalAmount.value = amount + gasFee.value;
     isFeeLoading.value = false;
    update(["wallet-token-sending-page"]);
  }   
  Future<Map<String, dynamic>> _estimateGasFee(String recipient, double amount) async {
    try {
      final isBNB = walletsInfo!.symbol == 'BNB';
      final amountInWei = isBNB
          ? BigInt.parse((amount * 1e18).toStringAsFixed(0))
          : BigInt.from(amount) * BigInt.from(10).pow(_decimals);
      final minBNBInWei = BigInt.from(_minBNB * 1e18);

      BigInt approveGas = BigInt.zero;
      BigInt allowance = BigInt.zero;
      if (!isBNB && amountInWei > BigInt.zero) {
        allowance = await _checkAllowance(amount);
        if (allowance < amountInWei) {
          final approveFunction = _tokenContract!.function('approve');
          approveGas = await _client.estimateGas(
            sender: _credentials.address,
            to: EthereumAddress.fromHex(walletsInfo!.walletAddress!),
            data: approveFunction.encodeCall([
              EthereumAddress.fromHex(_contractAddress),
              amountInWei,
            ]),
          );
        }
      }

      final function = _transferContract.function('sendBNBAndToken');
      final gasPrice = await _client.getGasPrice();
      final transferGas = await _client.estimateGas(
        sender: _credentials.address,
        to: EthereumAddress.fromHex(_contractAddress),
        value: EtherAmount.inWei(minBNBInWei),
        data: function.encodeCall([
          EthereumAddress.fromHex(isBNB ? '0x0000000000000000000000000000000000000000' : walletsInfo!.walletAddress!),
          EthereumAddress.fromHex(recipient),
          isBNB ? BigInt.zero : amountInWei,
          isBNB ? amountInWei : BigInt.zero,
          minBNBInWei,
        ]),
      );

      final gasFeeInWei = gasPrice.getInWei * (approveGas + transferGas);
      final totalBNBInWei = gasFeeInWei + minBNBInWei;
      final totalBNB = totalBNBInWei / BigInt.from(10).pow(18);

      final serviceFeeInWei = (minBNBInWei * _feePercentage) / BigInt.from(10000);
      final serviceFeeInBNB =BigInt.from(serviceFeeInWei) / BigInt.from(10).pow(18);

      return {
        'gasFee': gasFeeInWei / BigInt.from(10).pow(18),
        'serviceFee': serviceFeeInBNB,
        'totalBNB': totalBNB,
        'minBNB': _minBNB,
        'needsApproval': !isBNB && amountInWei > BigInt.zero && allowance < amountInWei,
      };
    } catch (e) {
      return {'error': 'Error estimating fee: $e'};
    }
  }
  Future<BigInt> _checkAllowance(double amount) async {
     final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return BigInt.from(0);
    }
    final web3Client = Web3Client(networkStore.rpcUrl?? "https://data-seed-prebsc-1-s1.binance.org:8545/", http.Client());
    if (walletsInfo!.symbol == 'BNB') return BigInt.from(0);
     const tokenAbi = '''[
       {
          "constant": true,
          "inputs": [
            {"name": "_owner", "type": "address"},
            {"name": "_spender", "type": "address"}
          ],
          "name": "allowance",
          "outputs": [{"name": "", "type": "uint256"}],
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [{"name": "_owner", "type": "address"}],
          "name": "balanceOf",
          "outputs": [{"name": "", "type": "uint256"}],
          "type": "function"
        }
      ]''';


    
      final amountInWei = BigInt.from(amount) * BigInt.from(10).pow(_decimals);
     
      final contract = DeployedContract(
        ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
        EthereumAddress.fromHex(walletRecipientController.text),
      );    
    try {
      var address = walletsInfo!.walletAddress!;
      print('address: $address');
      print('_contractAddress: $_contractAddress');
      final result = await web3Client.call(
        contract: contract,
        function: contract.function('allowance'),
        params: [EthereumAddress.fromHex(address), EthereumAddress.fromHex(_contractAddress)],
      );
      print('allowance: ${result[0]}');
      // final function = _tokenContract!.function('allowance');
      // final result = await _client.call(
      //   contract: _tokenContract!,
      //   function: function,
      //   params: [_credentials.address, EthereumAddress.fromHex(_contractAddress)],
      // );
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
}
