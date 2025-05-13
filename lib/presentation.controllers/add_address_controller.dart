import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/params/add_address_param.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/data.repositories/util_repository.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class AddAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Province? selectedProvince;
  String? provinceError;

  RxBool isDefault = false.obs;
  RxBool isLoading = false.obs;
  List<Province> listProvince = [];

  @override
  void onInit() {
    getProvinces();
    super.onInit();
  }

  Future getProvinces() async {
    handleEither(await UtilRepository().getProvinces(), (r) {
      listProvince = r;
      update(["province-drop-down"]);
    });
  }

  Future save() async {
    isLoading.value = true;
    var isValidated = formKey.currentState!.validate();
    if (selectedProvince == null) {
      provinceError = "Tỉnh chưa được chọn";
      update(["province-drop-down"]);
    } else {
      provinceError = null;
      update(["province-drop-down"]);
      if (isValidated) {
        await handleEither(
          await CheckoutRepository().addAddress(
            AddAddressParam(
              firstName: fNameController.text.trim(),
              lastName: lNameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneController.text.trim(),
              city: cityController.text.trim(),
              address1: addressController.text.trim(),
              countryId: selectedProvince?.countryId,
              stateProvinceId: selectedProvince?.id,
              isDefaultBillingAddress: isDefault.value,
            ),
          ),
          (r) {},
        );
      }
    }
    isLoading.value = false;
  }

  changeIsDefault() {
    isDefault.value = !isDefault.value;
  }
}
