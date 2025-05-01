import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/params/change_password_param.dart';
import 'package:hkcoin/data.repositories/auth_repository.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool isLoadingSaveButton = false.obs;

  Future changePassword() async {
    isLoadingSaveButton.value = true;
    if (formKey.currentState?.validate() ?? false) {
      handleEither(
        await AuthRepository().changePassword(
          ChangePasswordParam(
            oldPassword: oldPasswordController.text.trim(),
            newPassword: newPasswordController.text.trim(),
            confirmNewPassword: confirmPasswordController.text.trim(),
          ),
        ),
        (r) {
          Get.back();
          Toast.showSuccessToast("Đổi mật khẩu thành công");
        },
      );
    }

    isLoadingSaveButton.value = false;
  }
}
