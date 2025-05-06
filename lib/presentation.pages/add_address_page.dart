import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/gen/fonts.gen.dart';
import 'package:hkcoin/presentation.controllers/add_address_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
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
            BaseAppBar(title: tr("Account.CustomerAddresses.AddNew")),
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
                              label: tr("Account.Fields.Email"),
                            ),
                            MainTextField(
                              controller: controller.phoneController,
                              label: tr("Account.Fields.Phone"),
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
                                    CustomDropDownButton<Province>(
                                      selectedValue: null,
                                      items: controller.listProvince,
                                      onChanged: (province) async {
                                        controller.selectedProvince = province;
                                      },
                                      itemDesign: (item) {
                                        return SpacingRow(
                                          spacing:
                                              scrSize(context).width * 0.02,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name ?? "",
                                                style:
                                                    textTheme(
                                                      context,
                                                    ).bodyMedium,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    if (controller.provinceError != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: scrSize(context).width * 0.03,
                                          top: scrSize(context).height * 0.007,
                                        ),
                                        child: Text(
                                          controller.provinceError!,
                                          style: textTheme(
                                            context,
                                          ).bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red[100],
                                            fontFamily: FontFamily.googleSans,
                                          ),
                                        ),
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
                                child: Text(tr("Đặt làm địa chỉ mặc định")),
                              ),
                            ),
                            Obx(
                              () => MainButton(
                                isLoading: controller.isLoading.value,
                                width: double.infinity,
                                text: "Common.Save",
                                onTap: () async {
                                  await controller.save();
                                  Get.back();
                                  Toast.showSuccessToast("Đã thêm địa chỉ");
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
