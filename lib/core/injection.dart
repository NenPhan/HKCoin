import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';

class Injection {
  static setup() async {
    // final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
    await Storage.init();
    var cartController = Get.put(CartController());
    cartController.getCartData();
  }
}
