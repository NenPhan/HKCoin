import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WithDrawalRequestController extends GetxController {
   final formKey = GlobalKey<FormState>();
  RxBool isLoadingWallet = false.obs;
  RxBool isLoadingSaveButton = false.obs;
   WalletInfo? walletInfo;

  @override
  void onInit() {    
    getCustomerData();
    super.onInit();
  }
   void getCustomerData() async {    
    isLoadingWallet.value = true;
    handleEither(await CustomerRepository().getWalletInfo(), (r) {
      walletInfo = r;
    });
    isLoadingWallet.value = false;
    update(["wallet-info"]);
  }
}