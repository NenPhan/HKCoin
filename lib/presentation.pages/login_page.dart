import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/login_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:restart_app/restart_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bitcoin and chart illustration
                SizedBox(height: scrSize(context).height * 0.1),
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
                          MainTextField(
                            controller: controller.usernameController,
                            hintText: tr("Account.Login.Fields.UserName"),
                            validator:
                                (value) =>
                                    value != "" && value != null
                                        ? null
                                        : tr(
                                          "Account.Login.Fields.UserName.Required",
                                        ),
                          ),
                          const SizedBox(height: 16),
                          MainTextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            hintText: tr("Account.Login.Fields.Password"),
                            validator:
                                (value) =>
                                    value != "" && value != null
                                        ? null
                                        : tr(
                                          "Account.Login.Fields.Password.Required",
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
                  return MainButton(
                    isLoading: controller.isLoading.value,
                    text: 'Account.Login',
                    onTap: () async {
                      if (controller.isLoading.value) return;
                      controller.login(() async {
                        await Future.delayed(Duration(seconds: 1));
                        // Get.offAllNamed(HomePage.route);
                        Restart.restartApp();
                      });
                    },
                  );
                }),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (!controller.isLoading.value) {
                      Get.toNamed(RegisterPage.route);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
