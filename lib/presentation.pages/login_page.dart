import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/login_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hkcoin/widgets/button_loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Bitcoin and chart illustration
              Hero(
                tag: "main-logo",
                child: Assets.images.hkcLogo.image(
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Let\'s Get Started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Phone number input with country code
              Obx(
                () => IgnorePointer(
                  ignoring: controller.isLoading.value,
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: tr("Account.Login.Fields.UserName"),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                          ),
                          validator:
                              (value) =>
                                  value != "" && value != null
                                      ? null
                                      : tr(
                                        "Account.Register.Errors.UsernameIsNotProvided",
                                      ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: controller.showPassword.value,
                          decoration: InputDecoration(
                            hintText: tr("Account.Login.Fields.Password"),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.showPassword.value =
                                    !controller.showPassword.value;
                              },
                              child: Icon(
                                controller.showPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value != "" && value != null
                                      ? null
                                      : tr(
                                        "Account.Register.Errors.PasswordIsNotProvided",
                                      ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Next button
              Obx(() {
                return ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.value) return;
                    controller.login(() {
                      Get.offAllNamed(HomePage.route);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.isLoading.value
                          ? const ButtonLoadingWidget()
                          : Text(
                            tr('Account.Login'),
                            style: textTheme(context).titleSmall,
                          ),
                );
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
