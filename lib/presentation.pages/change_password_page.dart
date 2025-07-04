import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/change_password_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  static String route = "/change-password";

  @override
  State<ChangePasswordPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<ChangePasswordPage> {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      id: "change-password-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.ChangePassword"),
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

                                MainTextField(
                                  controller: controller.oldPasswordController,
                                  obscureText: true,
                                  label:
                                      "Account.ChangePassword.Fields.OldPassword",
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.ChangePassword.Fields.OldPassword.Requird",
                                      ),
                                ),
                                MainTextField(
                                  controller: controller.newPasswordController,
                                  obscureText: true,
                                  label:
                                      "Account.ChangePassword.Fields.NewPassword",
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.ChangePassword.Fields.NewPassword.Requird",
                                      ),
                                ),
                                MainTextField(
                                  controller:
                                      controller.confirmPasswordController,
                                  obscureText: true,
                                  label:
                                      "Account.ChangePassword.Fields.ConfirmNewPassword",
                                  validator:
                                      (value) => requiredValidator(
                                        value,
                                        "Account.ChangePassword.Fields.ConfirmNewPassword.Requird",
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
                                await controller.changePassword();
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
