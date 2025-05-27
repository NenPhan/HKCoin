import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/notification_service.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/check_update.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.models/slide.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.repositories/check_update_repository.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';
import 'package:hkcoin/data.repositories/news_repository.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class HomeBodyController extends GetxController {
  RxBool isLoadingWallet = false.obs;
  RxBool isLoadingProduct = false.obs;
  RxBool isLoadingNews = false.obs;
  bool isLoadingSlide = false;

  WalletInfo? walletInfo;
  List<Product> products = [];
  String? rxchangeRateData;
  List<News> news = [];
  List<Slide> slides = [];
  Rx<CheckUpdateResult?> updateResult = Rx<CheckUpdateResult?>(null);
  @override
  void onInit() {
    getProductsData();
    getCustomerData();
    getKHCoinData();
    getNewsData();
    
    getSlideData();
    updateDeviceToken();
    if(Platform.isAndroid)
    {
      checkUpdate();
    }
    handleNotiOpenApp();
    super.onInit();
  }

  handleNotiOpenApp() async {
    String? payload = await Storage().getNotiPayload();
    if (payload != null) {
      NotificationService.handleClickNotification(payload);
    }
  }

  void updateDeviceToken() async {
    var messaging = FirebaseMessaging.instance;

    var token = await messaging.getToken();

    handleEitherReturn(
      await CustomerRepository().updateDeviceToken(token),
      (r) async {},
    );

    messaging.onTokenRefresh.listen((token) async {
      handleEitherReturn(
        await CustomerRepository().updateDeviceToken(token),
        (r) async {},
      );
    });
  }
  void checkUpdate() async{
     handleEitherReturn(
      await CheckUpdateRepository().checkVersion(),
      (r) async {
        updateResult.value=r;
      },
    );
  }

  void getCustomerData() async {
    isLoadingWallet.value = true;
    handleEither(await CustomerRepository().getWalletInfo(), (r) {
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
        HubConnectionBuilder().withUrl(AppConfig().socketUrl).build();

    await connection.start();

    connection.on('ReceiveExchangeRateData', (message) {
      // print(message.toString());
      if (message != null && message.isNotEmpty) {
        rxchangeRateData = message.first as String;
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

  void getSlideData() async {
    isLoadingSlide = true;
    update(["home-slide"]);
    await handleEither(await NewsRepository().getSlides(), (r) {
      slides = r;
    });
    isLoadingSlide = false;
    update(["home-slide"]);
  }
}
