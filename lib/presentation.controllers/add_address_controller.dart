import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/country.dart';
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
  String? countryError;

  RxBool isDefault = false.obs;
  RxBool isLoading = false.obs;
  List<Province> listProvince = [];
  List<Country> listCountries = [];
  Country? selectedCountry;

  @override
  void onInit() {
    getCountries();
    super.onInit();
  }

  Future getCountries() async {
    handleEither(await UtilRepository().getCountries(), (r) {
      listCountries = r;
      update(["province-drop-down"]);
    });
  }

  Future getProvinces({int countryId = 230}) async {
    handleEither(await UtilRepository().getProvinces(countryId: countryId), (
      r,
    ) {
      listProvince = r;
      update(["province-drop-down"]);
    });
  }

  bool validateForm() {
    countryError =
        selectedCountry == null
            ? Get.context?.tr("Address.Fields.Country.Required")
            : null;
    provinceError =
        selectedProvince == null
            ? Get.context?.tr("Address.Fields.StateProvince.Required")
            : null;
    update(['province-drop-down']);
    return countryError == null && provinceError == null;
  }

  Future save() async {
    isLoading.value = true;
    var isValidated = formKey.currentState!.validate();
    if (selectedCountry == null) {
      countryError = Get.context?.tr("Address.Fields.Country.Required");
      update(["province-drop-down"]);
    } else {
      countryError = null;
    }
    if (selectedProvince == null) {
      provinceError = Get.context?.tr("Address.Fields.StateProvince.Required");
      update(["province-drop-down"]);
    } else {
      provinceError = null;
      update(["province-drop-down"]);
      if (isValidated && selectedCountry != null && selectedProvince != null) {
        await handleEither(
          await CheckoutRepository().addAddress(
            AddAddressParam(
              firstName: fNameController.text.trim(),
              lastName: lNameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneController.text.trim(),
              city: cityController.text.trim(),
              address1: addressController.text.trim(),
              countryId: selectedCountry?.id,
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
