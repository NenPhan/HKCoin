import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/product_detail.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';

class ProductDetailController extends GetxController {
  ProductDetail? data;
  RxBool isLoading = false.obs;

  @override
  onInit() {    
    if (Get.arguments is int) {
      getProductDetailData(Get.arguments as int);
    } else {
      isLoading.value = false;      
    }
    super.onInit();
  }
  getProductDetailData(int id) async {    
    isLoading.value = true;
    await handleEither(await ProductRepository().getProductsById(id), (p) {
      data = p;      
    });    
    isLoading.value = false;
  }  
}
