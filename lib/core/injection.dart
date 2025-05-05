// ignore_for_file: unused_local_variable

import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class Injection {
  static Future setup() async {
    // final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
    await Storage.init();
    var localController = Get.put(LocaleController());
    await localController.initLocale();
    var cartController = Get.put(CartController());
    cartController.getCartData();
  }
}
