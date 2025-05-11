import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WalletController extends GetxController {
  WalletInfo? walletInfo;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getWalletInfo();
    super.onInit();
  }

  getWalletInfo() async {
    isLoading.value = true;
    await handleEither(await CustomerRepository().getWalletInfo(), (r) {
      walletInfo = r;
    });
    isLoading.value = false;
  }
}
