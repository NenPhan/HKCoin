import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.controllers/recover_password_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});
  static String route = "/password-recovery";

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final RecoverPasswordController recoveryController = Get.put(
    RecoverPasswordController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const BaseAppBar(
              title: "Account.PasswordRecovery",
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
                        key: recoveryController.formKey,
                        child: SpacingColumn(
                          spacing: 15,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tr("Account.PasswordRecovery.Tooltip"),
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ),
                            MainTextField(
                              controller: recoveryController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: context.tr(
                                "Account.PasswordRecovery.Email",
                              ),
                              validator:
                                  (value) => requiredValidator(
                                    value,
                                    "Account.Fields.Email.Required",
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
                            isLoading: recoveryController.isLoadingSubmit.value,
                            width: double.infinity,
                            text: "Common.Submit",
                            onTap: () async {
                              final result =
                                  await recoveryController.recoveryPassword();
                              if (result['success'] == true) {
                                _showResult(context, result['message']);
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

  void _showResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(tr("Account.PasswordRecovery")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                SelectableText(message, style: const TextStyle(fontSize: 12)),
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
