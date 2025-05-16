
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/customer_downlines.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class CustomerDownlinesController extends GetxController {
  CustomerDownlines? customerDownlines;
  RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  @override
  void onInit() {
    getCustomerDownlinesData();
    super.onInit();
  }

  Future getCustomerDownlinesData({int parentId = 0, int page = 1, bool isLoadMore = false, int limit = 12}) async {
    if (!isLoadMore) {
      isInitialLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try{      
       //isLoading.value = true;
        update(["customer-downlines-page"]);
        await handleEither(
          await CustomerRepository().getCustomerDownlinesData(parentId: parentId, page: page, limit: limit),
          (r) {
            if (isLoadMore) {
              customerDownlines?.customerDownLineInfo?.addAll((r.customerDownLineInfo ?? []));
              // Update pagination info
              customerDownlines?.pageNumber = r.pageNumber;//currentPage
              customerDownlines?.hasNextPage = r.hasNextPage;          
              customerDownlines?.totalPages = r.totalPages;
            }else{
              customerDownlines = r;
            }          
          },
        );
       // isLoading.value = false;
        update(["customer-downlines-page"]);

        if (page == 1) {
          update(["customer-downlines-pagination"]);
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
