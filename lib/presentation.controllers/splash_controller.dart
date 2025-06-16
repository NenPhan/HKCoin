import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/deep_link_manager.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';

class SplashController extends GetxController {
  void checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    await applyLanguage();
    if (Storage().getToken != null) {
      Get.offAllNamed(HomePage.route);
    } else {
      Get.offAllNamed(LoginPage.route);
    }
    await DeeplinkManager.checkInitLink();
  }

  applyLanguage() async {
    var localController = Get.find<LocaleController>();
    await localController.initLocale();
    var locale = localController.locale;
    await Get.context?.setLocale(locale);
    await Get.updateLocale(locale);
  }
}
