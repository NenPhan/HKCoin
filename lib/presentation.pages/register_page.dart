import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/register_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
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
            const BaseAppBar(enableHomeButton: false),
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
                              label: context.tr("Account.Fields.ConfirmPassword"),
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
                              label: context.tr("Account.Register.ReferralCode"),
                              readOnly: registerController.referralCodeController.text.isNotEmpty,
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
                        child: ElevatedButton(
                          onPressed: () {
                            registerController.register();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[900],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            tr('Account.Register'),
                            style: textTheme(context).titleSmall,
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
}
