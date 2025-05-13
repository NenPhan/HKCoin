import 'dart:developer';

import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/wallet_histories.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class WalletHistoryController extends GetxController {
  WalletHistoriesPagination? walletHistoriesPagination;
  RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  List<String> listColumn = [
    "Account.Transaction.Fields.Code",
    "Account.Transaction.Fields.Amount",
    "Account.Transaction.Fields.Reason",
    "Account.Transaction.Fields.WalletType",
    "Account.Transaction.Fields.Status",
    "Account.Transaction.Fields.Message",
    "Common.CreatedOn",
  ];

  @override
  void onInit() {
    getWalletHistoriesData();
    super.onInit();
  }

  Future getWalletHistoriesData({int page = 1, bool isLoadMore = false, int limit = 15}) async {
    if (!isLoadMore) {
      isInitialLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try{
      log("Load trang");
       //isLoading.value = true;
        update(["wallet-histories-list"]);
        await handleEither(
          await CustomerRepository().getWalletHistories(page: page, limit: limit),
          (r) {
            if (isLoadMore) {
              walletHistoriesPagination?.walletHistories?.addAll(r.walletHistories ?? []);
              // Update pagination info
              walletHistoriesPagination?.pageNumber = r.pageNumber;//currentPage
              walletHistoriesPagination?.hasNextPage = r.hasNextPage;          
              walletHistoriesPagination?.totalPages = r.totalPages;
            }else{
              walletHistoriesPagination = r;
            }          
          },
        );
       // isLoading.value = false;
        update(["wallet-histories-list"]);

        if (page == 1) {
          update(["wallet-histories-pagination"]);
        }
    }catch(e){
      rethrow;
    }
    finally {
      isInitialLoading.value = false;
      isLoadingMore.value = false;
    }
   
  }
}
