import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';
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

  applyLanguage() async {
    var localController = Get.find<LocaleController>();
    await localController.initLocale();
    var locale = localController.locale;
    await Get.context?.setLocale(locale);
    await Get.updateLocale(locale);
  }
}
