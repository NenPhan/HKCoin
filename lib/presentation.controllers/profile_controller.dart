import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.repositories/customer_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileController extends GetxController {
  CustomerInfo? customerInfo;
  RxBool isLoggingOut = false.obs;
  final RxString appVersion = '1.0.0'.obs;
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

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = info.version;
    update(['profile']); // 🔥 BẮT BUỘC
  }
}
