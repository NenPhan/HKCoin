import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_controller.dart';
// import 'package:hkcoin/presentation.pages/wallet_token_add_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/expandale_container.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';

class WalletTokenPage extends StatefulWidget {
  const WalletTokenPage({super.key});
  static String route = "/wallet-token";

  @override
  State<WalletTokenPage> createState() => _WalletTokenPageState();
}

class _WalletTokenPageState extends State<WalletTokenPage> {
  final WalletTokenController controller = Get.put(WalletTokenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SpacingColumn(
          spacing: 10,
          children: [
            const BaseAppBar(title: "Account.WalletToken"),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: scrSize(context).width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainButton(text: tr("Account.WalletToken.Btn"), onTap: () {
                    // Get.toNamed(AddWalletTokenPage.route);
                  }),
                ],
              ),
            ),
            Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(child: LoadingWidget())
                      : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: scrSize(context).width * 0.03,
                            vertical: 0,
                          ),
                          itemCount: controller.walletTokens.length,
                          itemBuilder: (context, index) {
                            var item = controller.walletTokens[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ExpandaleContainer(
                                titleWidget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr(
                                        "Account.WalletToken.Balance",
                                      ).replaceAll(
                                        "{0}",
                                        "${item.token ?? ""} BEP20",
                                      ),
                                      style: textTheme(context).bodyLarge
                                          ?.copyWith(color: Colors.deepOrange),
                                    ),
                                    Text(
                                      item.balance ?? "",
                                      style: textTheme(context).titleLarge,
                                    ),
                                  ],
                                ),
                                expandedWidget: SpacingColumn(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    QRCodeWidget(
                                          data: item.walletToken??"", // Dữ liệu QR code
                                          size: 250, // Kích thước
                                          backgroundColor:
                                              Colors.white, // Màu nền
                                          foregroundColor:
                                              Colors.amber[900], // Màu QR code
                                          fileName:
                                              'walletToken${item.walletToken}.png', // Tùy chọn tên file khi lưu
                                        ),
                                    // SvgPicture.string(
                                    //   item.walletQrCode ?? "",
                                    //   width: scrSize(context).width * 0.6,
                                    // ),
                                    Text(tr("Account.WalletToken.Address")),
                                    Text(item.walletToken ?? ""),
                                    MainButton(
                                      width: scrSize(context).width * 0.25,                                      
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                      ),
                                      text: "Common.Copy",
                                      onTap: () {
                                        try {
                                          if (item.token != null) {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: item.walletToken!,
                                              ),
                                            );
                                          }
                                          Toast.showSuccessToast(
                                            "Common.CopyToClipboard.Succeeded",
                                          );
                                        } catch (e) {
                                          Toast.showErrorToast(
                                            "Common.CopyToClipboard.Failded",
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
