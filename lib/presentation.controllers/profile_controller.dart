import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/data.models/customer_info.dart';

class ProfileController extends GetxController {
  CustomerInfo? customerInfo;
  @override
  void onInit() {
    getProfileData();
    super.onInit();
  }

  void getProfileData() async {
    customerInfo = await Storage().getCustomer();
    update(["profile"]);
  }
}
