import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/login_controller.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/password_recovery_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:hkcoin/widgets/stores/store_brand_widget.dart';

import '../widgets/language_selector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [LanguageSelectorPro()],
                ),

                SizedBox(height: scrSize(context).height * 0.08),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: StoreBrandWidget(
                      type: StoreBrandType.full,
                      textTransform: TextTransform.uppercase,
                      logoSize: 250,
                      subtitle: 'subtitle',
                      titleStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      subtitleStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
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
                            hintText: "Account.Login.Fields.UserName",
                            focusNode: usernameFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(passwordFocus);
                            },
                            validator:
                                (value) =>
                                    value != "" && value != null
                                        ? null
                                        : context.tr(
                                          "Account.Login.Fields.UserName.Required",
                                        ),
                          ),
                          const SizedBox(height: 16),
                          MainTextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            focusNode: passwordFocus,
                            onFieldSubmitted: (_) => _triggerLogin(),
                            hintText: "Account.Login.Fields.Password",
                            validator:
                                (value) =>
                                    value != "" && value != null
                                        ? null
                                        : context.tr(
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
                        await Future.delayed(const Duration(seconds: 1));
                        Get.offAllNamed(HomePage.route);
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
                    backgroundColor: const Color(0xFFC8925A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.tr('Account.Register'),
                    style: textTheme(context).titleSmall,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr("Account.Login.ForgotPassword"),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () async {
                          Get.toNamed(PasswordRecoveryPage.route);
                        },
                        child: Text(
                          context.tr("Account.Login.ForgotPassword.Click"),
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _triggerLogin() {
    if (controller.isLoading.value) return;

    controller.login(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(HomePage.route);
    });
  }
}
