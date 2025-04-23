import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';

class SplashController extends GetxController {
  void checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (Storage().getToken != null) {
      Get.offAllNamed(HomePage.route);
    } else {
      Get.offAllNamed(LoginPage.route);
    }
  }
}
