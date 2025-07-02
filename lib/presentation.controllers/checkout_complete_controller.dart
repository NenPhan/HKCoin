import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class CheckoutCompleteController extends GetxController {
  CheckoutCompleteData? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    if (Get.arguments is int) {
      getCheckoutCompleteData(Get.arguments as int);
    } 
    else if (Get.arguments is String) {
      try {
        final intValue = int.parse(Get.arguments as String);
        getCheckoutCompleteData(intValue);
      } catch (e) {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;      
    }    
    super.onInit();
  }

  getCheckoutCompleteData(int id) async {
    isLoading.value = true;
    await handleEither(await CheckoutRepository().checkoutComplete(id), (r) {
      data = r;
    });    
    isLoading.value = false;
  }
}
