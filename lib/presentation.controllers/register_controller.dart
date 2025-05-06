import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  void register() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        handleEither(
          await AuthRepository().register(
            RegisterForm(
              firstName: fNameController.text.trim(),
              lastName: lNameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              password: passwordController.text.trim(),
              referralCode: referralCodeController.text.trim(),
            ),
          ),
          (r) {
            Get.back();
          },
        );
      } else {
        Toast.showErrorToast("Identity.Error.PasswordMismatch");
      }
    }
  }
}
