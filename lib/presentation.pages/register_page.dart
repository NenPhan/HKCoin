import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            const BaseAppBar(),
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
                              label: tr("Account.Fields.FirstName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.FirstNameIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.lNameController,
                              label: tr("Account.Fields.LastName"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.LastNameIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.emailController,
                              label: tr("Account.Login.Fields.Email"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.EmailIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.phoneController,
                              label: tr("Account.Fields.Phone"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.PhoneIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller: registerController.passwordController,
                              label: tr("Account.Fields.Password"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.PasswordIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller:
                                  registerController.confirmPasswordController,
                              label: tr("Account.Fields.ConfirmPassword"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.ConfirmPasswordIsNotProvided",
                                  ),
                            ),
                            MainTextField(
                              controller:
                                  registerController.referralCodeController,
                              label: tr("Account.Register.ReferralCode"),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Register.Errors.ReferralCodeIsNotProvided",
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
                            backgroundColor: Colors.green,
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
