import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/data.repositories/wallet_repository.dart';
import 'package:hkcoin/presentation.controllers/blockchange_wallet_controller.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
class WalletDetailController extends GetxController {
  final formKey = GlobalKey<FormState>();
  int walletId=0;
   final listNetwork = <Network>[].obs;
   final wallets = <BlockchangeWallet>[].obs;
   final walletInfos = <WalletsModel>[].obs;
   var selectedNetwork = Rxn<Network>();
   var mnemonicWords = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingWallets = false.obs;
   BlockchangeWalletInfo? walletsInfo;
   final TextEditingController searchController = TextEditingController();   
   final RxBool isLoadingSubmit = false.obs;
  @override
  void onInit() {        
    getWalletInfo(Get.arguments);
    super.onInit();
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
 
  Future getWallets() async {
    isLoadingWallets.value = true;    
    update(["blockchange-wallets"]);   
      await handleEither(await WalletRepository().getWallets(), (r) async {
        //wallets.value = r;        
        await fetchWalletsBalance(r);
      });
   
    isLoadingWallets.value = false;
    update(["blockchange-wallets"]);
  }
  Future deleteWallet(int walletId) async{    
    return handleEitherReturn(
      await WalletRepository().deleteWallet(walletId),
      (r) async {
        var blockChangeWallet = Get.find<BlockchangeWalletController>();
       await blockChangeWallet.getNetworks();
       await blockChangeWallet.getWalletInfo();
       update([
          'wallet-info-page'
        ]);
        Get.back();       
        Get.back();
        return true;
      },
      onError: (message) async {
        return false;
      },
    );
  }
  Future getWalletInfo(int walletId) async {
    isLoading.value = true;    
    update(["wallet-detail-page"]);   
      await handleEither(await WalletRepository().getWalletById(walletId), (r) {
        if(r !=null){
          walletsInfo = r;   
          print("private key: ${r.privateKey}");
          if (r.encryptedMnemonic?.isNotEmpty ?? false) {
            final mnemonicString = decryptText(r.encryptedMnemonic!, '');
            mnemonicWords.value = mnemonicString.split(' '); // Split into list
          } else {
            mnemonicWords.clear(); // Clear list if no mnemonic
          }      
          if(r.publicKey?.isNotEmpty??false){
            searchController.text = decryptText(r.publicKey!,"");
          }            
          fetchWalletBalance(walletsInfo!);     
        }else{
          mnemonicWords.clear();
        }  
      });
   
    isLoading.value = false;
    update(["wallet-detail-page"]);
  }
  Future fetchWalletBalance(BlockchangeWalletInfo wallets) async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }    
    walletInfos.clear();
    wallets.walletAddressFormat = _formatAddress(wallets.walletAddress);
    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
    double totalBalance = 0.0;
    double totalBalanceUSD = 0.0;       
     for (var wallet in walletsInfo!.walletAddressModel!) {      
        //final credentials = EthPrivateKey.fromHex(decryptText(wallet.privateKey!,""));
        //final address = await credentials.extractAddress();        
        // Lấy số dư từ BNB (Binance Smart Chain)
        try {                            
         if(wallet.chain==Chain.BNB){
            var bnb = await web3Client.getBalance(EthereumAddress.fromHex(wallet.walletAddress));
            wallet.totalBalance = fromWeiToBNB(bnb.getInWei.toDouble());     
            wallet.totalBalanceUSD = wallet.totalBalance!*665; 
            walletInfos.add(wallet);
            totalBalance+=wallet.totalBalanceUSD!;  
         }else if(wallet.chain!=Chain.BNB){
            final result = await getTokenBalance(
              wallet.walletAddress, 
              wallet.contractAddress,
              web3Client,
            );          
            wallet.totalBalance = result['balance'].toDouble();      
            walletInfos.add(wallet);
            if(wallet.chain==Chain.USDT){
              totalBalance+=wallet.totalBalance!;
            }                                   
          }                 
        } catch (e) {
          debugPrint('Lỗi khi lấy số dư BNB: $e');
          //Get.snackbar('Error', 'Lỗi khi lấy số dư BNB: $e');
        }       
     }           
    wallets.totalBalance = totalBalance;
    update(["wallet-info-page"]);
    wallets.balanceUSD = totalBalanceUSD;
    //wallet.unit = unit;
    web3Client.dispose();
  }
  Future fetchWalletsBalance(List<BlockchangeWallet> ws) async {
  final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
  if (networkStore == null) {
    Get.snackbar('Error', 'No network selected');
    return;
  }

  final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
  wallets.clear(); 
  for (var w in ws) {
    double walletTotalBalance = 0.0; // Tạo biến riêng cho từng ví    
    for (var info in w.walletAddress!) {
      if (info.chain == Chain.BNB) {
        var bnb = await web3Client.getBalance(EthereumAddress.fromHex(info.address));
        walletTotalBalance += fromWeiToBNB(bnb.getInWei.toDouble()) * 665; // Giả sử 665 là tỷ giá BNB/USD
      } else {        
        if(info.chain == Chain.USDT){
           
          final result = await getTokenBalance(
            info.address, 
            info.contractAddress,
            web3Client,
          );
          walletTotalBalance += result['balance'].toDouble();
        }         
      }
    }        
    w.balance=walletTotalBalance;    
    wallets.add(w);
  }    
  wallets.refresh(); // Cập nhật UI nếu dùng GetX
    update(["blockchange-wallets"]);
  web3Client.dispose();
}
  @override
  void onClose() {    
    super.onClose();
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
  // Build a list of buttons from mnemonic words
  List<Widget> buildMnemonicButtons() {
    return mnemonicWords.asMap().entries.map((entry) {
      final index = entry.key + 1; // Start index from 1
      final word = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: TextButton(
          onPressed: () {
            // Optional: Add action for button press
            print('Tapped word: $index. $word');
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[50],
            foregroundColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            '$index. $word', // Display index before word
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }).toList();
  }
}
