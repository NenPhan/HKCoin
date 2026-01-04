import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/extensions/enum_type_extension.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class CustomerInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final selectedGender = GenderType.defaultValue.obs;

  RxBool isLoadingSaveButton = false.obs;

  @override
  void onInit() {
    getCustomerInfo();
    super.onInit();
  }

  void getCustomerInfo() async {
    handleEither(await CustomerRepository().getCustomerInfo(), (r) {
      fNameController.text = r.firstName ?? "";
      lNameController.text = r.lastName ?? "";
      emailController.text = r.email;
      phoneController.text = r.phone ?? "";
      usernameController.text = r.username;
      selectedGender.value = GenderTypeX.mapGenderFromInt(r.genderId);
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
      customerInfo.genderId = selectedGender.value.toApiValue();
      handleEither(
        await CustomerRepository().updateCustomerInfo(customerInfo),
        (r) {
          Get.back();
          Toast.showSuccessToast("Common.Submit.Updated");
        },
      );
    }

    isLoadingSaveButton.value = false;
  }

  void setGender(GenderType gender) {
    selectedGender.value = gender;
    update(["gender"]);
  }
}
