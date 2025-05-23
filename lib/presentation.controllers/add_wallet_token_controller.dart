import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/add_wallet_token.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class AddWalletTokenController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final tokenAddressController = TextEditingController();
  
  bool isSubmitting = false;
  String? errorMessage;
  AddWalletToken? addWalletToken;
  List<AviableChainNetwork> aviableChainNetworks = [];
  AviableChainNetwork? selectedChainNetwork;
  RxBool isLoadingSubmit = false.obs;
  RxBool canSave = false.obs;
  @override
  void onInit() {
    addWalletTokens();
    super.onInit();
  }

  void addWalletTokens() async {
    handleEither(await CustomerRepository().addWalletToken(), (r) {
      addWalletToken = r;
      aviableChainNetworks = r.aviableChainNetwork!;      
      tokenAddressController.text = r.tokenAddress!;
    });
    update(["add-wallet-token-page"]);
  }

  void submitAddToken() async {
    isLoadingSubmit.value = true;
    if (formKey.currentState!.validate()) {
      if (selectedChainNetwork == null || selectedChainNetwork!.id == 0) {
        Toast.showErrorToast(
          "Account.WalletToken.Token.Fields.ChainNetwork.Requird",
        );
        return;
      }    
      await handleEitherReturn(
        await CustomerRepository().submitWalletToken(
          AddWalletToken(
            tokenAddress: tokenAddressController.text.trim(),            
            chainNetworkId: selectedChainNetwork!.id,
          ),
        ),
        (r) async {
           Toast.showSuccessToast(
            "Account.WalletToken.NetworkChains.Added",
          );
          Get.back();
        },
      );
    }
    isLoadingSubmit.value = false;
  }
   validate() {
    canSave.value =
        tokenAddressController.text.trim() != "" &&
        selectedChainNetwork != null && selectedChainNetwork!.id>0;
  }
}
