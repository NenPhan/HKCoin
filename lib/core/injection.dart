import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';
import 'package:hkcoin/presentation.controllers/private_message_controller.dart';
class Injection {
  static Future setup() async {
    // final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
    await Storage.init();
    Get.put(LocaleController());
    var cartController = Get.put(CartController());
    cartController.getCartData();
    var messageController = Get.put(PrivateMessageController());
    messageController.getPrivateMessageCount();
  }
}
