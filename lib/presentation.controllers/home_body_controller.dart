import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/auth_repository.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';

class HomeBodyController extends GetxController {
  RxBool isLoadingWallet = false.obs;
  RxBool isLoadingProduct = false.obs;

  WalletInfo? walletInfo;
  List<Product> products = [];

  @override
  void onInit() {
    getProductsData();
    getCustomerData();
    super.onInit();
  }

  void getCustomerData() async {
    isLoadingWallet.value = true;
    handleEither(await AuthRepository().getWalletInfo(), (r) {
      walletInfo = r;
    });
    isLoadingWallet.value = false;
    update(["wallet-info"]);
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
