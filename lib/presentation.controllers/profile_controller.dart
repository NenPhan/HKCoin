import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';

class ProfileController extends GetxController {
  CustomerInfo? customerInfo;
  RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    getProfileData();
    super.onInit();
  }

  void getProfileData() async {
    customerInfo = await Storage().getCustomer();
    update(["profile"]);
  }

  void logout(VoidCallback onLogedOut) async {
    isLoggingOut.value = true;
    update(["logout-button"]);
    await handleEither(await CustomerRepository().logout(), (r) async {
      onLogedOut();
    });
    isLoggingOut.value = false;
    update(["logout-button"]);
  }
}
