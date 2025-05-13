
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/withdrawals_histories.dart';
import 'package:hkcoin/data.repositories/withdrawals_repository.dart';

class WithDrawalHistoryController extends GetxController {
  WithDrawalHistoriesPagination? withDrawalHistoriesPagination;
  RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  List<String> listColumn = [
    "Account.WithDrawalRequest.Fields.Amount",
    "Account.WithDrawalRequest.Fields.AmountSwap",
    "Account.WithDrawalRequest.Fields.WithDrawalSwap",
    "Account.WithDrawalRequest.Fields.Status",
    "Account.WithDrawalRequest.Fields.Reason",
    "Account.WithDrawalRequest.Fields.CustomerComments",
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
       //isLoading.value = true;
        update(["drawal-histories-list"]);
        await handleEither(
          await WithDrawalsRepository().getWithDrawalHistoriesData(page: page, limit: limit),
          (r) {
            if (isLoadMore) {
              withDrawalHistoriesPagination?.withDrawalHistories?.addAll((r.withDrawalHistories ?? []));
              // Update pagination info
              withDrawalHistoriesPagination?.pageNumber = r.pageNumber;//currentPage
              withDrawalHistoriesPagination?.hasNextPage = r.hasNextPage;          
              withDrawalHistoriesPagination?.totalPages = r.totalPages;
            }else{
              withDrawalHistoriesPagination = r;
            }          
          },
        );
       // isLoading.value = false;
        update(["drawal-histories-list"]);

        if (page == 1) {
          update(["drawal-histories-pagination"]);
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
