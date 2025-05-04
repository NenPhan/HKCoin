import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class AddAddressController extends GetxController {
  final GlobalKey formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  RxBool isLoading = false.obs;
  List<Province> listProvince = [];

  @override
  void onInit() {
    getProvinces();
    super.onInit();
  }

  Future getProvinces() async {
    isLoading.value = true;
    handleEither(await CheckoutRepository().getProvinces(), (r) {
      listProvince = r;
    });
    isLoading.value = false;
  }
}
