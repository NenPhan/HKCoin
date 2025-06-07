import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils/bip39_wordlist.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
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
  final mnemonicController = TextEditingController();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController contractSymbolController = TextEditingController();
  final TextEditingController contractDecimalController = TextEditingController();
   final listNetwork = <Network>[].obs;
   Network? selectNetwork;
  
  final RxBool isLoadingSubmit = false.obs;
  final RxBool canSave = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    getNetworks();
    mnemonicController.addListener(_updateCanSave);
    super.onInit();
  }

  @override
  void onClose() {
    mnemonicController.removeListener(_updateCanSave);
    mnemonicController.dispose();
    super.onClose();
  }
  Future getNetworks() async {        
    await handleEitherReturn(await WalletRepository().getNetworks(), (
      r,
    ) async {      
       final uniqueNetworks = {
        for (var e in r) e.id: e
      }.values.toList();
      listNetwork.value = uniqueNetworks;       
    });
      update(["wallet-info-page"]); 
  }
    void submitForm() async {
      isLoadingSubmit.value = true;
      if (formKey.currentState!.validate()) {

      }
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
  Future createWalletAutoGenerateMnemonic() async{
     final networkStore = await Storage().getNetWork();
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }
    try{
      String mnemonic = bip39.generateMnemonic();    
    //String seed = bip39.mnemonicToSeedHex(mnemonic);
    //EthPrivateKey credentials = EthPrivateKey.fromHex(seed);
    //EthereumAddress address = await credentials.extractAddress();
   // print('Address: ${address.hex}');
     final wallets = await _generateWalletsSafe(mnemonic);     
   // print('Address: ${wallets.first.address}');
      await handleEitherReturn(
        await WalletRepository().createWallet(
          BlockchangeWallet(
            mnemonicOrPrivateKey: encryptText(mnemonic),
            createWalletType: CreateWalletType.Mnemonic.index,
            walletAddress: wallets
          ),
        ),
        (r) async {
           //Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
           update(["wallet-info-page"]);  
          Toast.showSuccessToast("Account.WalletToken.NetworkChains.Added");
          Get.find<BlockchangeWalletController>().getWalletInfo();
          update(["wallet-info-page"]);  
          Get.offAllNamed(WalletPage.route);
        },
      );
    }catch(e){

    }
    
  }

  void _updateCanSave() {
    canSave.value = mnemonicController.text.trim().isNotEmpty;
  }

  Future<void> submitAddToken(CreateWalletType type) async {
    try {
      // Set loading state and force UI update immediately
      isLoadingSubmit.value = true;
      errorMessage.value = '';
      await Future.microtask(() {}); // Allow UI to update
      
      if (!formKey.currentState!.validate()) return;
      
      final mnemonic = mnemonicController.text.trim();
      
      // Validate mnemonic in isolate if it's heavy
      final isValid = await compute(_validateMnemonicIsolate, mnemonic);
      if (!isValid) {
        errorMessage.value = 'Mnemonic không hợp lệ';
        Get.snackbar("Error", errorMessage.value);
        return;
      }
      
      // Generate wallets in background
      final wallets = await _generateWalletsSafe(mnemonic);
      
      await handleEitherReturn(
        await WalletRepository().createWallet(
          BlockchangeWallet(
            mnemonicOrPrivateKey: encryptText(mnemonic),
            createWalletType: type.index,
            walletAddress: wallets
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
    } catch (e) {
      update(["wallet-info-page"]);  
      errorMessage.value = 'Có lỗi xảy ra: ${e.toString()}';
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoadingSubmit.value = false;
    }
  }

  bool validate() {
    final isValid = mnemonicController.text.trim().isNotEmpty;
    canSave.value = isValid;
    return isValid;
  }

  Future<List<WalletAddress>> _generateWalletsSafe(String mnemonic) async {
    try {
      return await compute(_createBep20WalletsIsolate, mnemonic);
    } catch (e) {
      errorMessage.value = 'Lỗi tạo ví: ${e.toString()}';
      throw e;
    }
  }

  // Isolate functions
  static bool _validateMnemonicIsolate(String mnemonic) {
    final words = mnemonic.trim().split(RegExp(r'\s+'));
    if (![12, 15, 18, 21, 24].contains(words.length)) return false;
    if (words.any((w) => !bip39WordListEnglish.contains(w))) return false;
    return bip39.validateMnemonic(mnemonic);
  }

  static Future<List<WalletAddress>> _createBep20WalletsIsolate(String mnemonic) async {
    return [
      await _generateWalletIsolate(mnemonic, Chain.HKC, EthereumNetwork.BEP20, "0x377482392014118EBe37662f022939E0b5E5479a"),
      await _generateWalletIsolate(mnemonic, Chain.BNB, EthereumNetwork.BEP20, "0x55d398326f99059fF775485246999027B3197955"),
      await _generateWalletIsolate(mnemonic, Chain.USDT, EthereumNetwork.BEP20, "0x55d398326f99059fF775485246999027B3197955"),
    ];
  }

  static Future<WalletAddress> _generateWalletIsolate(
    String mnemonic, 
    Chain chain, 
    EthereumNetwork networkChain, 
    String contractAddress
  ) async {
    try {
      final seed = bip39.mnemonicToSeed(mnemonic);
      final root = bip32.BIP32.fromSeed(seed);
      const ethPath = "m/44'/60'/0'/0/0";
      
      final key = root.derivePath(ethPath);
      final privateKeyHex = HEX.encode(key.privateKey!);
      final publicKeyHex = HEX.encode(key.publicKey);

      final credentials = EthPrivateKey.fromHex(privateKeyHex);
      final address = await credentials.extractAddress();

      return WalletAddress(
        address: address.hexEip55,
        contractAddress: contractAddress,
        privateKey: encryptText(privateKeyHex),
        publicKey: encryptText(publicKeyHex),
        chain: chain,
        networkChain: networkChain.index
      );
    } catch (e) {
      throw Exception('Failed to generate wallet for ${chain.toString()}: $e');
    }
  }
}