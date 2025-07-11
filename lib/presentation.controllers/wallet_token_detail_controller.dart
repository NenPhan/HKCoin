import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
// import 'package:hkcoin/core/services/blockchain_service.dart.2.bak';
import 'package:hkcoin/core/services/blockchain_service_refactor.dart';
import 'package:hkcoin/data.models/blockchain_transaction.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/blockchange_wallet_token_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/token_settings.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/data.repositories/wallet_repository.dart';
import 'package:hkcoin/presentation.controllers/blockchange_wallet_controller.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletTokenDetailController extends GetxController {
  // final bscScanApiKey="Z9JBDKUZG93MHRGU21KFF81EAD287KD3E4";
  // final wsUrls = [
  //     'wss://go.getblock.us/83a3f76dee6b4ef889fc38a7d22215dd',
  //     'wss://bsc-rpc.publicnode.com',
  //     'wss://bsc-testnet-rpc.publicnode.com',
  //     'wss://bsc-ws-node.nariox.org:443',
  //     'wss://bsc-dataseed1.binance.org:443',
  //     'wss://bsc-dataseed2.binance.org:443',
  //     'wss://bsc-dataseed3.binance.org:443',
  //   ];
     late final BlockchainService _blockchainService;
 // final Rx<BlockchainService?> _blockchainService = Rx<BlockchainService?>(null);
  final formKey = GlobalKey<FormState>();
  final listNetwork = <Network>[].obs;
  final wallets = <BlockchangeWallet>[].obs;
  final walletInfos = <WalletsModel>[].obs;
  var selectedNetwork = Rxn<Network>();
  var mnemonicWords = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingWallets = false.obs;
  BlockchangeWalletTokenInfo? walletsInfo;
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoadingSubmit = false.obs;
  final RxList<BlockChainTransaction> transactions = <BlockChainTransaction>[].obs;
  StreamSubscription<BigInt>? _balanceSubscription;
  StreamSubscription<BigInt>? _tokenBalanceSubscription;
  StreamSubscription<BlockChainTransaction>? _transactionSubscription;
  late EthereumAddress walletAddress;
  late EthereumAddress tokenContract;
  late bool hasRunService = false;
  TokenSetting? tokenSetting;

  @override
  void onInit() async {
    super.onInit();
    await _loadTokenSettings();
    await getNetworks();
    final walletId = Get.arguments as int?;
    if (walletId != null) {
      await getWalletInfo(walletId);
    } else {
      Get.snackbar('Lỗi', 'ID ví không hợp lệ');
    }
  }
  Future<void> _loadTokenSettings() async {
    try {
      final settings = await Storage().getTokenSetting();
      if (settings != null) {
        tokenSetting = settings;
      } else {
        final blockchainWalletController = Get.find<BlockchangeWalletController>();
        await blockchainWalletController.getTokenConfigs();
        // Xử lý khi không có dữ liệu trong Storage
        tokenSetting = blockchainWalletController.tokenSettings;            
      }
    } catch (e) {        
      // Có thể gán giá trị mặc định khi có lỗi
      tokenSetting = TokenSetting(
        bscScanApiKey: 'Z9JBDKUZG93MHRGU21KFF81EAD287KD3E4',
        contractAddressSend: '',
        contractFunction: 'sendBNBAndToken',
        minBNB: 0.00001,
        wsUrls: [],
      );
    }
  }
  Future<void> _initTracking(Web3Client web3Client) async {
    if(!hasRunService){
      _blockchainService = BlockchainService(
        wsUrls: tokenSetting!.wsUrls,
        bscScanApiKey: tokenSetting!.bscScanApiKey,
        web3Client: web3Client
      );
      await _blockchainService.init();
      hasRunService=true;
    }    
    // _blockchainService.startTrackingBalance(walletAddress);    
    _blockchainService.trackToken(tokenContract, walletAddress);
     // Lắng nghe token transfer
    _blockchainService.watchTokenTransfers().listen((tx) async {
      if (tx.to.hex == walletAddress.hex &&
          tx.contract.hex == tokenContract.hex) {
            print("watchTokenTransfers ${tx.amount}");
           // transactions.insert(0,tx);
        //tokenTransfers.insert(0, tx);
        _updateBalance(); 
        await _transactionHistory();
      }
    });

    _updateBalance();
    await _transactionHistory();
   
  }

  Future<void> _updateBalance() async {  
    try{
      if (walletsInfo!.chain == Chain.BNB) {
        final bnb = await _blockchainService.getBalance(walletAddress);       
        walletsInfo!.totalBalance = fromWeiToBNB(bnb.getInWei.toDouble());
        walletsInfo!.balanceUSD = walletsInfo!.totalBalance! * await fetchBnbPrice();
      }else{
        final bal = await _blockchainService.getTokenBalance(walletAddress, tokenContract);      
        final balanceValue = bal / BigInt.from(10).pow(18);
        walletsInfo!.totalBalance = balanceValue;
        if (walletsInfo!.chain == Chain.USDT) {
          walletsInfo!.balanceUSD = walletsInfo!.totalBalance! * await fetchUsdtPrice();          
        }
      }
    } catch(e){
        debugPrint(e.toString());
    }finally{
      update(['wallet-token-detail-page']);
    }         
  }
 
  Future<void> _transactionHistory() async {
    if (walletsInfo?.walletAddress == null) {      
      return;
    }
    try {
      isLoading.value = true;
      final history = await _blockchainService.getTransactionHistory(wallet: walletsInfo!);        
      transactions.assignAll(history);
    } catch (e) {      
      //Get.snackbar('Lỗi', 'Không thể tải lịch sử giao dịch: $e');
    } finally {
      isLoading.value = false;
      update(['wallet-token-detail-page']);
    }
  }
  @override
  void onClose() {
    _balanceSubscription?.cancel();
    _tokenBalanceSubscription?.cancel();
    _transactionSubscription?.cancel();
   // blockchainService.dispose();
    searchController.dispose();
    super.onClose(); 
    _blockchainService.stopTrackingBalance(walletAddress);
     _blockchainService.dispose();
  }
  Future<void> getNetworks() async {
    try {
      await handleEitherReturn(await WalletRepository().getNetworks(), (r) async {
        final uniqueNetworks = {for (var e in r) e.id: e}.values.toList();
        listNetwork.value = uniqueNetworks;
        final networkStore = await Storage().getNetWork();
        if (networkStore == null || listNetwork.isEmpty) {
          var network = listNetwork.firstWhere(
            (e) => e.networkDefault ?? false,
            orElse: () => listNetwork.first,
          );
          await Storage().saveNetWork(network);
          selectedNetwork.value = network;
        } else {
          selectedNetwork.value = networkStore;
        }
        listNetwork.sort((a, b) => a.id == selectedNetwork.value?.id ? -1 : 1);
      });
      update(['wallet-info-page']);
    } catch (e) {
      print('Lỗi tải danh sách mạng: $e');
      Get.snackbar('Lỗi', 'Không thể tải danh sách mạng: $e');
    }
  }

  Future<void> filterNetworks(String query) async {
    if (query.isEmpty) {
      await getNetworks();
    } else {
      listNetwork.assignAll(
        listNetwork.where((network) => network.name!.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> getWalletInfo(int walletId) async {
    isLoading.value = true;
    try {
      await handleEither(await WalletRepository().getWalletTokenById(walletId), (r) {
        if (r != null) {
          walletsInfo = r;
          walletAddress = EthereumAddress.fromHex(walletsInfo!.walletAddress!);
          tokenContract = EthereumAddress.fromHex(walletsInfo!.contractAddress!);         
          fetchWalletBalance(walletsInfo!); 
        } else {
          throw Exception('Không tìm thấy thông tin ví cho walletId: $walletId');
        }
      });
    } catch (e) {
      print('Lỗi tải thông tin ví: $e');
      Get.snackbar('Lỗi', 'Không thể tải thông tin ví: $e');
    } finally {
      isLoading.value = false;
      update(['wallet-token-detail-page']);
    }
  }

  Future<void> fetchWalletBalance(BlockchangeWalletTokenInfo wallet) async {
    // final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    // if (networkStore == null) {
    //   Get.snackbar('Lỗi', 'Không có mạng nào được chọn');
    //   return;
    // }
    try {      
      final web3Client = Web3Client(selectedNetwork.value?.rpcUrl??"https://bsc-dataseed.binance.org/", http.Client());
           
      _initTracking(web3Client);   
      update(['wallet-token-detail-page']);
      web3Client.dispose();
    } catch (e) {      
      Get.snackbar('Lỗi', 'Không thể lấy số dư: $e');
    }
  }
  Future<double> fetchUsdtPrice() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=tether&vs_currencies=usd',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);         
        return data['tether']['usd'].toDouble();
      } else {        
        return 1.0; // Giá trị mặc định (USDT thường ~1 USD)
      }
    } catch (e) {      
      return 1.0; // Giá trị mặc định
    }
  }
  Future<double> fetchBnbPrice() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['binancecoin']['usd'].toDouble();
      }
      print('Lỗi lấy giá BNB: ${response.statusCode}');
      return 600.0; // Giá mặc định
    } catch (e) {
      print('Lỗi lấy giá BNB: $e');
      return 600.0; // Giá mặc định
    }
  }

  Future<void> fetchWalletsBalance(List<BlockchangeWallet> ws) async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Lỗi', 'Không có mạng nào được chọn');
      return;
    }

    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
    wallets.clear();
    for (var w in ws) {
      double walletTotalBalance = 0.0;
      for (var info in w.walletAddress!) {
        try {
          if (info.chain == Chain.BNB) {
            final bnb = await web3Client.getBalance(EthereumAddress.fromHex(info.address));
            walletTotalBalance += fromWeiToBNB(bnb.getInWei.toDouble()) * await fetchBnbPrice();
          } else if (info.chain == Chain.USDT) {
            final result = await getTokenBalance(info.address, info.contractAddress, web3Client);
            walletTotalBalance += result['balance'].toDouble();
          }
        } catch (e) {
          print('Lỗi lấy số dư cho ${info.address}: $e');
        }
      }
      w.balance = walletTotalBalance;
      wallets.add(w);
    }
    wallets.refresh();
    update(['blockchange-wallets']);
    web3Client.dispose();
  }

  String _formatAddress(String? address) {
    if (address == null || address.length < 12) return 'N/A';
    return '${address.substring(0, 7)}...${address.substring(address.length - 5)}';
  }

  Future<Map<String, dynamic>> getTokenBalance(
    String walletAddress,
    String tokenAddress,
    Web3Client web3Client,
  ) async {
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

    final contract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(tokenAddress),
    );
    try {
      final decimals = await web3Client.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      final decimalsValue = decimals[0] as BigInt;

      final balance = await web3Client.call(
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
      throw Exception('Không thể lấy số dư token: $e');
    }
  }

  double fromWeiToBNB(double weiAmount, {int decimals = 18}) {
    return weiAmount / BigInt.from(10).pow(decimals).toDouble();
  }

  BigInt toWei(String value, {int decimals = 18}) {
    if (!value.contains('.')) {
      return BigInt.parse(value + '0' * decimals);
    }
    final parts = value.split('.');
    final integerPart = parts[0];
    final decimalPart = (parts[1] + '0' * decimals).substring(0, decimals);
    return BigInt.parse(integerPart + decimalPart);
  }

  String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(number);
  }
}