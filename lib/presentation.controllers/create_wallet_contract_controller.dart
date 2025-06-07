import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils/bip39_wordlist.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/customer_wallet_token.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hkcoin/data.repositories/wallet_repository.dart';
import 'package:hkcoin/presentation.controllers/blockchange_wallet_controller.dart';
import 'package:hkcoin/presentation.pages/wallet_page.dart';
import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:hex/hex.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:web3dart/web3dart.dart';

class CreateWalletWithContractController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController contractSymbolController = TextEditingController();
  final TextEditingController contractDecimalController = TextEditingController();
   final listNetwork = <Network>[].obs;
   Network? selectNetwork;
  String? selectedWalletAddress;
  late int walletId;
  
  final RxBool isLoadingSubmit = false.obs;
  final RxBool canSave = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    //Get.arguments    
    getNetworks();   
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
          selectNetwork = network;     
          listNetwork.value.sort((a, b) {
            if (a.id == network.id) return -1;
            if (b.id == network.id) return 1;
            return 0;
          });                             
        }else{
          selectNetwork = networkStore; 
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
    void submitForm() async {
      isLoadingSubmit.value = true;
      if (!formKey.currentState!.validate()) return;
      if (walletId<=0 || selectedWalletAddress == null) {
        errorMessage.value = 'Không tìm thấy địa chỉ ví';
        Get.snackbar("Error", errorMessage.value);
        return;
      }
      await handleEitherReturn(
        await WalletRepository().createCustomerToken(
          CustomerWalletToken(
            id: walletId,
            contractAddress: contractController.text.trim(),
            walletAddress: selectedWalletAddress,
            symbol: contractSymbolController.text.trim(),
            decimals: contractDecimalController.text.trim().isNotEmpty ? int.parse(contractDecimalController.text.trim()) : 18,
            ethereumNetworkId: selectNetwork?.id??1
          ),
        ),
        (r) async {
          update(["wallet-info-page"]);  
          Toast.showSuccessToast("Account.WalletToken.NetworkChains.Added");
          Get.find<BlockchangeWalletController>().getWalletInfo();
          update(["wallet-info-page"]);  
          Get.offAllNamed(WalletPage.route);
          //Get.back();
        },
      );
      isLoadingSubmit.value = false;
    }
  Future<void> updateContractInfomation() async {
    final contractAddress = contractController.text;
    if(selectNetwork == null){
      final networkStore = await Storage().getNetWork();
      if (networkStore != null) {
        selectNetwork = networkStore;        
      }else{
        Get.snackbar('Error', 'No network selected');
        return;
      }      
    }
    const tokenAbi = '''[      
      {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [{"name": "", "type": "string"}],
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [{"name": "", "type": "uint8"}],
        "type": "function"
      }
    ]''';
    final client = Web3Client(selectNetwork!.rpcUrl!, Client());
    try{
       final contract = DeployedContract(
        ContractAbi.fromJson(tokenAbi, 'BEP20'),
        EthereumAddress.fromHex(contractAddress),
      );       
      // Gọi hàm symbol
      final symbolFunction = contract.function('symbol');
      final symbolResult = await client.call(
        contract: contract,
        function: symbolFunction,
        params: [],
      );
      final symbol = symbolResult[0] as String;
      contractSymbolController.text = symbol;
      // Gọi hàm decimals
      final decimalsFunction = contract.function('decimals');
      final decimalsResult = await client.call(
        contract: contract,
        function: decimalsFunction,
        params: [],
      );
      final decimals = decimalsResult[0] as BigInt;
      contractDecimalController.text = decimals.toString();
    }catch(e){
      errorMessage.value = 'Địa chỉ hợp đồng không đúng định dạng: ${e.toString()}';
    }   
    update(["add-wallet-contract-page"]);
  }
}