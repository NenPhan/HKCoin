import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_detail_controller.dart';
import 'package:hkcoin/presentation.pages/wallet_token_received_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_send_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';

class WalletTokenDetailPage extends StatefulWidget {
  const WalletTokenDetailPage({super.key});
  static String route = "/wallet-token-detail";

  @override
  State<WalletTokenDetailPage> createState() => _WalletTokenDetailPageState();
}

class _WalletTokenDetailPageState extends State<WalletTokenDetailPage> {
  final WalletTokenDetailController controller = Get.put(
    WalletTokenDetailController(),
  );
  Future<void> _onRefresh() async {
    // Call getWallet on refresh
    await controller.getWalletInfo(Get.arguments);
    // Update GetBuilder
    controller.update(['wallet-token-detail-page']);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletTokenDetailController>(
      id: "wallet-token-detail-page",
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    BaseAppBar(
                      title: controller.walletsInfo?.symbol ?? "",
                      centerTitle: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6, // Tỉ lệ 6
                            child: Container(
                              height: 36, // Chiều cao cố định
                              margin: const EdgeInsets.only(
                                right: 5,
                              ), // Khoảng cách phải 5px (tổng 2 bên là 10px)
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1B1B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                // Căn giữa nội dung theo chiều dọc và ngang
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // Co lại vừa đủ nội dung
                                    children: [
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        size: 18,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        // Cho phép text co dãn trong container
                                        child: Text(
                                          controller.walletsInfo?.walletName ??
                                              'My Wallet',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign:
                                              TextAlign.left, // Căn giữa text
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Cột bên phải - Địa chỉ ví với nút copy (chiếm 40%)
                          Expanded(
                            flex: 4, // Tỉ lệ 4
                            child: Container(
                              height: 36, // Chiều cao cố định
                              margin: const EdgeInsets.only(
                                left: 5,
                              ), // Khoảng cách trái 5px (tổng 2 bên là 10px)
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1B1B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center, // Căn giữa toàn bộ nội dung
                                children: [
                                  Expanded(
                                    // Phần text chiếm hết không gian còn lại
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        controller.walletsInfo?.walletAddress !=
                                                null
                                            ? '${controller.walletsInfo!.walletAddress!.substring(0, 5)}...${controller.walletsInfo!.walletAddress!.substring(controller.walletsInfo!.walletAddress!.length - 4)}'
                                            : '0x1a2...b3c4',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign:
                                            TextAlign.center, // Căn giữa text
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 36, // Cố định kích thước nút copy
                                    child: IconButton(
                                      icon: const Icon(Icons.copy, size: 18),
                                      onPressed: () {
                                        if (controller
                                                .walletsInfo
                                                ?.walletAddress !=
                                            null) {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text:
                                                  controller
                                                      .walletsInfo
                                                      ?.walletAddress ??
                                                  "",
                                            ),
                                          );
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      splashRadius: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Biểu tượng logo to tròn
                    TokenIconWidget(
                      imageUrl: controller.walletsInfo?.iconUrl,
                      width: 80,
                      height: 80,
                      hasBorder: false,
                      backgroundColor: Colors.transparent,
                      placeholder:
                          const CircularProgressIndicator(), // Tùy chọn
                      errorWidget: const Icon(
                        Icons.token,
                        size: 80,
                      ), // Tùy chọn
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(height: 40),
                    // Số dư
                    FormattedNumber(
                      value: controller.walletsInfo?.totalBalance,
                      decimalDigits:
                          controller.walletsInfo?.chain == Chain.BNB ? 5 : 2,
                      style: const TextStyle(fontSize: 40),
                      suffix: controller.walletsInfo?.chain!.name,
                    ),
                    const SizedBox(height: 8),
                    FormattedNumber(
                      value: controller.walletsInfo?.balanceUSD,
                      decimalDigits: 2,
                      style: const TextStyle(fontSize: 18),
                      prefix: r"$",
                    ),

                    // Số dư bằng USD
                    // Text(
                    //   ,,
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                    const SizedBox(height: 40),

                    // 2 nút Nhận và Gửi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              WalletTokenReceivedPage.route,
                              arguments: WalletTokenReceivedPageParam(
                                wallet: controller.walletsInfo!,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Colors.white70,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            context.tr("Account.Wallet.Received"),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              WalletTokenSendingPage.route,
                              arguments: WalletTokenSendingPageParam(wallet: controller.walletsInfo!),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Colors.white70,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            context.tr('Account.Wallet.Send'),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
