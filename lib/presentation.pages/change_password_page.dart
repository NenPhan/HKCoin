import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/change_password_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';

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
                const BaseAppBar(title: "Đổi mật khẩu"),
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

                                TextFormField(
                                  controller: controller.oldPasswordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr(
                                          "Account.ChangePassword.Fields.OldPassword",
                                        ),
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
                                    hintText: tr(
                                      "Account.ChangePassword.Fields.OldPassword",
                                    ),
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
                                        "Account.Register.Errors.PasswordIsNotProvided",
                                      ),
                                ),
                                TextFormField(
                                  controller: controller.newPasswordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr(
                                          "Account.ChangePassword.Fields.NewPassword",
                                        ),
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
                                    hintText: tr(
                                      "Account.ChangePassword.Fields.NewPassword",
                                    ),
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
                                        "Account.Register.Errors.PasswordIsNotProvided",
                                      ),
                                ),
                                TextFormField(
                                  controller:
                                      controller.confirmPasswordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: RichText(
                                      text: TextSpan(
                                        text: tr(
                                          "Account.ChangePassword.Fields.ConfirmNewPassword",
                                        ),
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
                                    hintText: tr(
                                      "Account.ChangePassword.Fields.ConfirmNewPassword",
                                    ),
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
                                        "Account.Register.Errors.ConfirmPasswordIsNotProvided",
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
