import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/register_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';

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
                            TextFormField(
                              controller: registerController.fNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Fields.FirstName"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Fields.FirstName"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.FirstNameIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller: registerController.lNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Fields.LastName"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Fields.LastName"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),

                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.LastNameIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller: registerController.emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Login.Fields.Email"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Login.Fields.Email"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.EmailIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller: registerController.phoneController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Fields.Phone"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Fields.Phone"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.PhoneIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller: registerController.passwordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Fields.Password"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Login.Fields.Password"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.PasswordIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller:
                                  registerController.confirmPasswordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Fields.ConfirmPassword"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Fields.ConfirmPassword"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
                                    value,
                                    "Account.Register.Errors.ConfirmPasswordIsNotProvided",
                                  ),
                            ),
                            TextFormField(
                              controller:
                                  registerController.referralCodeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: tr("Account.Register.ReferralCode"),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: textTheme(context).titleMedium
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: tr("Account.Register.ReferralCode"),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              validator:
                                  (
                                    value,
                                  ) => registerController.requiredValidator(
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
