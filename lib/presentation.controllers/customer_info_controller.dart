import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.repositories/auth_repository.dart';

class CustomerInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  RxBool isLoadingSaveButton = false.obs;

  @override
  void onInit() {
    getCustomerInfo();
    super.onInit();
  }

  void getCustomerInfo() async {
    handleEither(await AuthRepository().getCustomerInfo(), (r) {
      fNameController.text = r.firstName;
      lNameController.text = r.lastName;
      emailController.text = r.email;
      phoneController.text = "0${r.phone}";
      usernameController.text = r.username;
    });
    update(["customer-info-page"]);
  }

  Future updateCustomerInfo() async {
    isLoadingSaveButton.value = true;
    CustomerInfo? customerInfo = await Storage().getCustomer();
    if (customerInfo != null && (formKey.currentState?.validate() ?? false)) {
      customerInfo.firstName = fNameController.text;
      customerInfo.lastName = lNameController.text;
      customerInfo.email = emailController.text;
      customerInfo.phone = phoneController.text;
      handleEither(await AuthRepository().updateCustomerInfo(customerInfo), (
        r,
      ) {
        Get.back();
        Toast.showSuccessToast("Lưu thông tin thành công");
      });
    }

    isLoadingSaveButton.value = false;
  }
}
