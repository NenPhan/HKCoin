import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/main_button.dart';

class CheckoutCompletePage extends StatefulWidget {
  const CheckoutCompletePage({super.key});
  static String route = "/checkout-complete";

  @override
  State<CheckoutCompletePage> createState() => _CheckoutCompletePageState();
}

class _CheckoutCompletePageState extends State<CheckoutCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SpacingColumn(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr("Thanh toán thành công"),
                style: textTheme(context).titleLarge,
              ),
              Container(
                width: scrSize(context).width * 0.1,
                height: scrSize(context).width * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check),
              ),
              MainButton(
                text: "Account.Login.BackHome",
                onTap: () {
                  Get.offNamedUntil(HomePage.route, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
