import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/customer_info_controller.dart';
import 'package:hkcoin/widgets/disable_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class NormalWithdrawalPagePage extends StatefulWidget {
  const NormalWithdrawalPagePage({super.key});

  @override
  State<NormalWithdrawalPagePage> createState() => _NormalWithdrawalPagePageState();
}

class _NormalWithdrawalPagePageState extends State<NormalWithdrawalPagePage> {
  final CustomerInfoController controller = Get.put(CustomerInfoController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerInfoController>(
      id: "customer-info-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Form(
                            key: controller.formKey,
                            child: SpacingColumn(
                              spacing: 15,
                              children: [
                                const SizedBox(height: 20),
                                DisableWidget(
                                  child: MainTextField(
                                    controller: controller.usernameController,
                                    label: tr("Account.Fields.Username"),
                                  ),
                                ),
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
                                  controller: controller.emailController,
                                  label: tr("Account.Login.Fields.Email"),
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.Register.Errors.EmailIsNotProvided",
                                      ),
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => MainButton(
                              isLoading: controller.isLoadingSaveButton.value,
                              text: "Common.Save",
                              onTap: () async {
                                await controller.updateCustomerInfo();
                              },
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
      },
    );
  }
}
