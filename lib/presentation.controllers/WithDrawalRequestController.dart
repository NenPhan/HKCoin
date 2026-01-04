import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WithDrawalRequestController extends GetxController {
  RxBool isLoadingWallet = true.obs;
  WalletInfo? walletInfo;

  @override
  void onInit() {
    getCustomerData();
    super.onInit();
  }

  Future<void> getCustomerData() async {
    isLoadingWallet.value = true;
    handleEither(await CustomerRepository().getWalletInfo(), (r) {
      walletInfo = r;
    });
    isLoadingWallet.value = false;
    update(["withdraw-request-page"]);
  }
}
