import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

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
          handleEither(await CustomerRepository().getCustomerInfo(), (r) {
            onLogedIn();
          });
        },
      );
    }
    isLoading.value = false;
  }
}
