import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_histories.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WalletHistoryController extends GetxController {  
  WalletHistoriesPagination? walletHistoriesPagination;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getWalletHistoriesData();
    super.onInit();
  }
  Future getWalletHistoriesData({int page = 1, int limit = 15}) async {    
    isLoading.value = true;
    update(["wallet-histories-list"]);
    await handleEither(
      await CustomerRepository().getWalletHistories(page: page, limit: limit),
      (r) {
        walletHistoriesPagination = r;
      },
    );    
    isLoading.value = false;
    update(["wallet-histories-list"]);
  }
}
