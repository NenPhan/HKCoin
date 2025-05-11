import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/wallet_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tr("Account.Report.Walletmain"),
                  style: textTheme(context).titleLarge,
                ),
                const SizedBox(height: 20),
                controller.isLoading.value
                    ? const Expanded(child: Center(child: LoadingWidget()))
                    : controller.walletInfo == null
                    ? Container()
                    : SpacingColumn(
                      spacing: 10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            scrSize(context).width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SpacingColumn(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                tr("Account.Report.Walletmain"),
                                style: textTheme(context).bodyLarge,
                              ),
                              Text(
                                controller.walletInfo!.walletMain,
                                style: textTheme(context).bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            scrSize(context).width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SpacingColumn(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                tr("Account.Report.Shopping"),
                                style: textTheme(context).bodyLarge,
                              ),
                              Text(
                                controller.walletInfo!.walletShopping,
                                style: textTheme(context).bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            scrSize(context).width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SpacingColumn(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                tr("Account.Report.Coupon"),
                                style: textTheme(context).bodyLarge,
                              ),
                              Text(
                                controller.walletInfo!.walletCoupon,
                                style: textTheme(context).bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            scrSize(context).width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SpacingColumn(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                tr("Account.Report.Coupon"),
                                style: textTheme(context).bodyLarge,
                              ),
                              Text(
                                controller.walletInfo!.orderCount,
                                style: textTheme(context).bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: homeBottomPadding),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
