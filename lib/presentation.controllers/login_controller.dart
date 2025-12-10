import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';
import 'package:hkcoin/localization/localization_scope.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController(
    text: '',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '',
  );

  RxBool isLoading = false.obs;

  void login(VoidCallback onLogedIn) async {
    isLoading.value = true;
    if (formKey.currentState!.validate()) {
      handleEither(
        await CustomerRepository().login(
          usernameController.text.trim(),
          passwordController.text.trim(),
        ),
        (r) async {
          handleEither(await CustomerRepository().getCustomerInfo(), (r) async {
            await applyLanguage();
            onLogedIn();
          });
        },
      );
    }
    isLoading.value = false;
  }

 Future<void> applyLanguage() async {
    final ctx = Get.context;
    if (ctx == null) return;

    final localeController = Get.find<LocaleController>();
    await localeController.initLocale();

    final locale = localeController.locale;

    // đổi locale realtime trong LocalizationScope
    // ignore: use_build_context_synchronously
    await LocalizationScope.of(ctx).setLocale(locale);

    // update cho GetX UI
    await Get.updateLocale(locale);
  }
}
