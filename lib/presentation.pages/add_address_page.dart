import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/country.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/gen/fonts.gen.dart';
import 'package:hkcoin/presentation.controllers/add_address_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/custom_drop_down_search.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});
  static String route = "/add-address";

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final AddAddressController controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BaseAppBar(title: "Account.CustomerAddresses.AddNew"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scrSize(context).width * 0.03,
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: controller.formKey,
                        child: SpacingColumn(
                          spacing: 15,
                          children: [
                            const SizedBox(height: 20),
                            MainTextField(
                              controller: controller.fNameController,
                              label: tr("Account.Fields.FirstName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.FirstNameIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: controller.lNameController,
                              label: tr("Account.Fields.LastName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.LastNameIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              isRequired: false,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: tr("Account.Fields.Email"),
                            ),
                            MainTextField(
                              controller: controller.phoneController,
                              label: tr("Account.Fields.Phone"),
                               keyboardType: TextInputType.phone,
                              isNumberOnly: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\+?[0-9]*$'),
                                ),
                              ],
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.PhoneIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: controller.cityController,
                              label: tr("Account.Fields.City"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.CityIsNotProvided",
                                  ),
                            ),
                            GetBuilder<AddAddressController>(
                              id: "province-drop-down",
                              builder: (controller) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CustomDropdownSearch<Country>(
                                      items: controller.listCountries,
                                      selectedItem: controller.selectedCountry,
                                      onChanged: (Country? country) async {
                                        if (country != null) {
                                          controller.selectedCountry = country;
                                          controller.selectedProvince = null;
                                          controller.provinceError = null;
                                          controller.countryError = null;
                                          await controller.getProvinces(countryId: country.id!);
                                          controller.update(['province-drop-down']);
                                        }
                                      },
                                      itemAsString: (Country? country) => country?.name ?? "",
                                      labelText: "Address.SelectCountry",
                                      errorText: controller.countryError,
                                      isEnabled: !controller.isLoading.value,
                                      icon: Icons.public,
                                      validator: (Country? value) =>
                                        value == null ? tr("Address.Fields.Country.Required") : null,
                                    ),
                                                                    
                                    SizedBox(height: scrSize(context).height * 0.015),
                                    CustomDropdownSearch<Province>(
                                      items: controller.listProvince,
                                      selectedItem: controller.selectedProvince,
                                      onChanged: (Province? province) {
                                        controller.selectedProvince = province;
                                        controller.provinceError = null; // Xóa lỗi khi chọn
                                        controller.update(['province-drop-down']);
                                      },
                                      itemAsString: (Province? province) => province?.name ?? "",
                                      labelText: tr("Address.Fields.StateProvince"),
                                      errorText: controller.provinceError,
                                      isEnabled: !controller.isLoading.value,
                                      icon: Icons.location_city,
                                      height: 56.0,
                                      itemHeight: 44.0,                                      
                                      validator: (Province? value) =>
                                          value == null ? tr("Address.Fields.StateProvince.Required") : null,
                                    ),                                                                       
                                  ],
                                );
                              },
                            ),
                            MainTextField(
                              controller: controller.addressController,
                              label: tr("Address"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.AddressIsNotProvided",
                                  ),
                            ),
                            Obx(
                              () => CheckboxMenuButton(
                                value: controller.isDefault.value,
                                onChanged: (value) {
                                  controller.changeIsDefault();
                                },
                                child: Text(tr("Address.SetDefaultAddress")),
                              ),
                            ),
                            Obx(
                              () => MainButton(
                                isLoading: controller.isLoading.value,
                                width: double.infinity,
                                text: "Common.Save",
                                onTap: () async {
                                  if (controller.validateForm()) {
                                    await controller.save();
                                    Get.back();
                                    Toast.showSuccessToast("Address.Save.Successfull");
                                  } else {
                                    controller.update(['province-drop-down']);
                                    //Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin");
                                  }                                
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
