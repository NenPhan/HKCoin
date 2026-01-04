import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/stores/store_config.dart';
import 'package:hkcoin/data.repositories/store_respository.dart';

class AboutUsController extends GetxController {
  StoreConfig? store;
  RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  @override
  void onInit() {
    getgetCurrentStoreData();
    super.onInit();
  }

  Future getgetCurrentStoreData() async {
    isLoading.value = true;
    update(["currentStore"]);
    await handleEither(await StoreRepository().getCurrentStore(), (r) {
      store = r;
    });
    isLoading.value = false;
    update(["currentStore"]);
  }
}
