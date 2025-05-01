import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/customer_info_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/disable_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';

class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({super.key});
  static String route = "/customer-info";

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
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
                const BaseAppBar(title: "Thông tin khách hàng"),
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
                                  child: TextFormField(
                                    controller: controller.usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      label: RichText(
                                        text: TextSpan(
                                          text: tr("Account.Fields.Username"),
                                          children: [
                                            TextSpan(
                                              text: "*",
                                              style: textTheme(context)
                                                  .titleMedium
                                                  ?.copyWith(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      hintText: tr("Account.Fields.Username"),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 20,
                                          ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: controller.fNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr("Account.Fields.FirstName"),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: textTheme(context)
                                                .titleMedium
                                                ?.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: tr("Account.Fields.FirstName"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                  ),
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.Register.Errors.FirstNameIsNotProvided",
                                      ),
                                ),
                                TextFormField(
                                  controller: controller.lNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr("Account.Fields.LastName"),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: textTheme(context)
                                                .titleMedium
                                                ?.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: tr("Account.Fields.LastName"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                  ),

                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.Register.Errors.LastNameIsNotProvided",
                                      ),
                                ),
                                TextFormField(
                                  controller: controller.emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr("Account.Login.Fields.Email"),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: textTheme(context)
                                                .titleMedium
                                                ?.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: tr("Account.Login.Fields.Email"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                  ),
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.Register.Errors.EmailIsNotProvided",
                                      ),
                                ),
                                TextFormField(
                                  controller: controller.phoneController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr("Account.Fields.Phone"),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: textTheme(context)
                                                .titleMedium
                                                ?.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: tr("Account.Fields.Phone"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                  ),
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
                              text: tr("Common.Save"),
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
