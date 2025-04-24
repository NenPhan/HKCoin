import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';

class HomeBodyController extends GetxController {
  RxBool isLoadingProduct = false.obs;
  List<Product> products = [];

  @override
  void onInit() {
    getProductsData();
    super.onInit();
  }

  void getProductsData() async {
    isLoadingProduct.value = true;
    handleEither(await ProductRepository().getProducts(), (r) {
      products = r;
    });
    isLoadingProduct.value = false;
    update(["product-list"]);
  }
}
