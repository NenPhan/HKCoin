import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/auth_repository.dart';
import 'package:hkcoin/data.repositories/news_repository.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';
import 'package:signalr_core/signalr_core.dart';

class HomeBodyController extends GetxController {
  RxBool isLoadingWallet = false.obs;
  RxBool isLoadingProduct = false.obs;
  RxBool isLoadingNews = false.obs;

  WalletInfo? walletInfo;
  List<Product> products = [];
  String? rxchangeRateData;
  List<News> news = [];

  @override
  void onInit() {
    getProductsData();
    getCustomerData();
    getKHCoinData();
    getNewsData();
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

  void getKHCoinData() async {
    final connection =
        HubConnectionBuilder()
            .withUrl(
              'https://sandbox.hakacoin.net/hkc-hub/',
              HttpConnectionOptions(
                logging: (level, message) {
                  // print(message);
                },
              ),
            )
            .build();

    await connection.start();

    connection.on('ReceiveExchangeRateData', (message) {
      // print(message.toString());
      if (message != null && message.isNotEmpty) {
        rxchangeRateData = message.first;
      }
      update(["exchange-rate"]);
    });
  }

  void getNewsData() async {
    isLoadingNews.value = true;
    await handleEither(await NewsRepository().getNews(), (r) {
      news = r;
    });
    isLoadingNews.value = false;
    update(["news-list"]);
  }
}
