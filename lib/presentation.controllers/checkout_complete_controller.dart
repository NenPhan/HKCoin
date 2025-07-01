import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class CheckoutCompleteController extends GetxController {
  CheckoutCompleteData? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    getCheckoutCompleteData(Get.arguments);
    super.onInit();
  }

  getCheckoutCompleteData(String orderguid) async {
    isLoading.value = true;
    await handleEither(await CheckoutRepository().checkoutComplete(orderguid), (r) {
      data = r;
    });    
    isLoading.value = false;
  }
}
