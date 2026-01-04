import 'package:get/get.dart';
import 'package:hkcoin/data.models/services/store_service.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';
import 'package:hkcoin/presentation.controllers/splash_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StoreService(), permanent: true);
    Get.put(LocaleController(), permanent: true);

    // ⭐ BẮT BUỘC
    Get.put(SplashController());
  }
}
