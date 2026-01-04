import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.controllers/register_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String route = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController registerController = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const BaseAppBar(
              title: "Account.Register",
              enableHomeButton: false,
            ),
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
                        key: registerController.formKey,
                        child: SpacingColumn(
                          spacing: 15,
                          children: [
                            const SizedBox(height: 20),
                            MainTextField(
                              controller: registerController.fNameController,
                              label: context.tr("Account.Fields.FirstName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.FirstName.Required",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.lNameController,
                              label: context.tr("Account.Fields.LastName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.LastName.Required",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: context.tr("Account.Login.Fields.Email"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.Email.Required",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.phoneController,
                              label: context.tr("Account.Fields.Phone"),
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
                                    "Account.Fields.Phone.Required",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.passwordController,
                              label: context.tr("Account.Fields.Password"),
                              obscureText: true,
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.Password.Required",
                                  ),
                            ),
                            MainTextField(
                              controller:
                                  registerController.confirmPasswordController,
                              label: context.tr(
                                "Account.Fields.ConfirmPassword",
                              ),
                              obscureText: true,
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.ConfirmPassword.Required",
                                  ),
                            ),
                            MainTextField(
                              controller:
                                  registerController.referralCodeController,
                              label: context.tr(
                                "Account.Register.ReferralCode",
                              ),
                              readOnly:
                                  registerController
                                      .referralCodeController
                                      .text
                                      .isNotEmpty,
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.ReferralCode.Required",
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Next button
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => MainButton(
                            isLoading: registerController.isLoadingSubmit.value,
                            width: double.infinity,
                            text: "Common.Submit",
                            onTap: () async {
                              var result = await registerController.register();
                              if (result['success'] == true) {
                                _showResult(context, result);
                              }
                            },
                          ),
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

  void _showResult(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(tr("Account.Register")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                SelectableText(
                  result['message'],
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
                child: Text(tr("Common.Close")),
              ),
            ],
          ),
    );
  }
}
