import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/checkout_controller.dart';
import 'package:hkcoin/widgets/address_widget.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  static String route = "/checkout";

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CheckoutController>(
          id: "checkout",
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BaseAppBar(title: tr("Checkout")),
                    const SizedBox(height: 20),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AddressWidget(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: scrSize(context).width * 0.03,
                    ),
                    decoration: BoxDecoration(color: Colors.grey[900]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(tr("Messages.Order.OrderTotal")),
                            Text("100\$", style: textTheme(context).titleSmall),
                          ],
                        ),
                        SizedBox(width: scrSize(context).width * 0.03),
                        MainButton(text: tr("Checkout"), onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
