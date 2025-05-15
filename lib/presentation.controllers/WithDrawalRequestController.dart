import 'dart:developer';

import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WithDrawalRequestController extends GetxController {
  RxBool isLoadingWallet = false.obs;
  WalletInfo? walletInfo;

  @override
  void onInit() {
    getCustomerData();
    super.onInit();
  }

  Future<void> getCustomerData() async {
    log("getCustomerData");
    isLoadingWallet.value = true;
    handleEither(await CustomerRepository().getWalletInfo(), (r) {
      log(r.walletCoupon);
      walletInfo = r;
    });
    isLoadingWallet.value = false;
    log("isLoadingWallet.value");
    update(["withdraw-request-page"]);
  }
}
