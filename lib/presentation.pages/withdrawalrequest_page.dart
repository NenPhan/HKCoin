import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/WithDrawalRequestController.dart';
import 'package:hkcoin/presentation.pages/withdrawal_investment_page.dart';
import 'package:hkcoin/presentation.pages/withdrawal_profit_page.dart';
import 'package:hkcoin/presentation.pages/withdrawalrequest_histories_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:shimmer/shimmer.dart';

class WithDrawRequestPage extends StatefulWidget {
  const WithDrawRequestPage({super.key});
  static String route = "/withdraw-request";
  @override
  State<WithDrawRequestPage> createState() => _WithDrawRequestPagePageState();
}

class _WithDrawRequestPagePageState extends State<WithDrawRequestPage>
    with SingleTickerProviderStateMixin {
  final WithDrawalRequestController controller = Get.put(
    WithDrawalRequestController(),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return GetBuilder<WithDrawalRequestController>(
      id: "withdraw-request-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.WithDrawalRequest.Create"),
                // Wallet info section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.isLoadingWallet.value) {
                          return const WalletInfoShimmer();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SpacingColumn(
                                spacing: size.height * 0.01,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr("Account.Report.Shopping"),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  Text(
                                    controller.walletInfo?.walletShopping ??
                                        "N/A",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    controller.walletInfo?.profitsShopping ??
                                        "N/A",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SpacingColumn(
                                spacing: size.height * 0.01,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr("Account.Report.Walletmain"),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  Text(
                                    controller.walletInfo?.walletMain ?? "N/A",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.01,
                    vertical: size.height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Distribute buttons evenly
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(ProfitWithdrawalContentPage.route);
                        },
                        icon: const Icon(Icons.download), // Icon for Button 1
                        label: Text(
                          context.tr("Account.WithDrawalRequest.Profits.Title"),
                        ), // Replace with your localized text
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(InvestmentWithdrawalContentPage.route);
                        },
                        icon: const Icon(Icons.download), // Icon for Button 2
                        label: Text(
                          context.tr("Account.WithDrawalRequest.Title"),
                        ), // Replace with your localized text
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // History section with proper height management
                const Expanded(child: WithdrawalrequestHistoryPage()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WalletInfoShimmer extends StatelessWidget {
  const WalletInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Row(
        children: [
          Expanded(child: _column(size)),
          const SizedBox(width: 10),
          Expanded(child: _column(size)),
        ],
      ),
    );
  }

  Widget _column(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== ROW 1: TITLE =====
        _box(width: size.width * 0.25, height: size.width * 0.035),
        const SizedBox(height: 10),

        // ===== ROW 2: BIG AMOUNT =====
        _box(width: double.infinity, height: size.width * 0.055),
        const SizedBox(height: 10),

        // ===== ROW 3: SMALL AMOUNT =====
        _box(width: size.width * 0.22, height: size.width * 0.03),
      ],
    );
  }

  Widget _box({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
