import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.controllers/checkout_complete_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_payment_page.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';
import 'package:html/parser.dart';

class CheckoutCompletePage extends StatefulWidget {
  const CheckoutCompletePage({super.key});
  static String route = "/checkout-complete";

  @override
  State<CheckoutCompletePage> createState() => _CheckoutCompletePageState();
}

class _CheckoutCompletePageState extends State<CheckoutCompletePage> {
  final CheckoutCompleteController controller = Get.put(
    CheckoutCompleteController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child:
              controller.isLoading.value
                  ? const Center(child: LoadingWidget())
                  : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: SpacingColumn(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: scrSize(context).height * 0.02),
                          Text(
                            context.tr("Checkout.OrderTotals.Information"),
                            style: textTheme(context).titleMedium,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _buildTextInfoWidget(
                                  title: "Order.OrderDate",
                                  content: dateFormat(
                                    controller.data?.order.createdOn,
                                  ),
                                ),
                                _buildTextInfoWidget(
                                  title: "Order.Order",
                                  content:
                                      controller.data?.order.orderNumber ?? "",
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextInfoWidget(
                                  title: "Order.OrderStatus",
                                  content:
                                      controller.data?.order.orderStatus ?? "",
                                ),
                                _buildTextInfoWidget(
                                  title: "Order.OrderTotal",
                                  content:
                                      (controller
                                                      .data
                                                      ?.order
                                                      .orderWalletTotal ??
                                                  0) >
                                              0
                                          ? controller
                                                  .data
                                                  ?.order
                                                  .orderWalletTotalStr ??
                                              ""
                                          : controller.data?.order.orderTotal ??
                                              "",
                                  contentStyle: textTheme(
                                    context,
                                  ).bodyMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: scrSize(context).height * 0.01),
                          _buildPaymentInfo(controller.data),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MainButton(
                                  text: "Account.Login.BackHome",
                                  onTap: () {
                                    Get.offNamedUntil(
                                      HomePage.route,
                                      (route) => false,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                MainButton(
                                  visible:
                                      !controller.data!.order.coinExtension!
                                          .contains("HTX") &&
                                      (controller.data!.order.status !=
                                              OrderStatus.complete &&
                                          controller.data!.order.status !=
                                              OrderStatus.cancelled),
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  ),
                                  text: tr("Checkout.Payment.IPay"),
                                  backgroundColor: Colors.lightGreen,
                                  onTap: () {
                                    final String qrData =
                                        "https://hakacoin.net/ipay/?orderid=${controller.data!.order.id}";
                                    xPopUpDialog(
                                      context,
                                      title: context.tr(
                                        "Account.CustomerInfo.Popup.QRCode.Title",
                                      ),
                                      description: context
                                          .tr(
                                            "Checkout.Payment.Popup.QRCode.Description",
                                          )
                                          .replaceAll(
                                            '{0}',
                                            controller.data!.order.orderNumber!,
                                          ),
                                      child: QRCodeWidget(
                                        data: qrData, // Dữ liệu QR code
                                        size: 250, // Kích thước
                                        logoWidget: TokenIconWidget(
                                          imageProvider:
                                              Assets.images.hkcIcon
                                                  .image(height: 45)
                                                  .image,
                                          width: 24,
                                          height: 24,
                                          hasBorder: false,
                                          backgroundColor: Colors.transparent,
                                          placeholder:
                                              const CircularProgressIndicator(),
                                          errorWidget: const Icon(
                                            Icons.token,
                                            size: 24,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        backgroundColor:
                                            Colors.white, // Màu nền
                                        fileName:
                                            'affiliateLink_ipay.png', // Tùy chọn tên file khi lưu
                                      ),
                                      centerTitle: true, // Căn giữa tiêu đề
                                      centerDescription: true, // Căn giữa mô tả
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  _buildTextInfoWidget({
    required String title,
    required String content,
    TextStyle? contentStyle,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            context.tr(title),
            style: textTheme(
              context,
            ).bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          Text(content, style: contentStyle ?? textTheme(context).bodyMedium),
        ],
      ),
    );
  }

  _buildPaymentInfo(CheckoutCompleteData? data) {
    return Container(
      padding: EdgeInsets.all(scrSize(context).width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SpacingColumn(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(context.tr("Account.Order.Fields.BillingAddress")),
          ),
          _buildAlert(data?.notifiesAlert ?? ""),
          if (data?.infoPayment?.qRCodePayment != null)
            Center(
              child: QRCodeWidget(
                data: data!.infoPayment!.walletAddress!,
                size: scrSize(context).width * 0.6,
                backgroundColor: Colors.white,
                logoWidget: TokenIconWidget(
                  imageProvider: Assets.images.hkcIcon.image(height: 45).image,
                  width: 24,
                  height: 24,
                  hasBorder: false,
                  backgroundColor: Colors.transparent,
                  placeholder: const CircularProgressIndicator(),
                  errorWidget: const Icon(Icons.token, size: 24),
                  padding: const EdgeInsets.all(2),
                ),
                showShare: true,
                showSaveStore: true,
              ),
              // child: SvgPicture.string(
              //   data!.infoPayment!.qRCodePayment!,
              //   width: scrSize(context).width * 0.6,
              // ),
            ),
          Html(
            data: context
                .tr("Checkout.Billing.Information.WalletAddress")
                .replaceAll("{0}", data?.infoPayment?.walletAddress ?? ""),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainButton(
                  width: scrSize(context).width * 0.25,
                  icon: const Icon(Icons.copy, color: Colors.white),
                  text: "Common.Copy",
                  backgroundColor: const Color(0xFF504F4F),
                  onTap: () {
                    try {
                      if (data?.infoPayment?.walletAddress != null) {
                        Clipboard.setData(
                          ClipboardData(
                            text: data!.infoPayment!.walletAddress!,
                          ),
                        );
                      }
                      Toast.showSuccessToast(
                        "Common.CopyToClipboard.Succeeded",
                      );
                    } catch (e) {
                      Toast.showErrorToast("Common.CopyToClipboard.Failded");
                    }
                  },
                ),
                const SizedBox(width: 10),
                MainButton(
                  visible:
                      !data!.order.coinExtension!.contains("HTX") &&
                      (controller.data!.order.status != OrderStatus.complete &&
                          controller.data!.order.status !=
                              OrderStatus.cancelled),
                  icon: const Icon(Icons.payment, color: Colors.white),
                  text: tr(
                    "Checkout.Payment.Wallet",
                  ).replaceAll('{0}', data.order.coinExtension ?? ""),
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    Get.toNamed(
                      WalletPaymmentOrderPage.route,
                      arguments: WalletPaymmentOrderParam(
                        order: controller.data!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildAlert(String alert) {
    var list =
        parse(alert).querySelectorAll("body").map((e) => e.innerHtml).toList();
    String alertString = "";
    if (list.isNotEmpty) {
      alertString = list.first.replaceAll(" <br>", "\n");
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Icon(Icons.warning_rounded, color: Colors.red[50]),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.all(scrSize(context).width * 0.03),
                color: Colors.red[100],
                child: Text(
                  alertString,
                  style: textTheme(
                    context,
                  ).bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
