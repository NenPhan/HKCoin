import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/presentation.controllers/checkout_complete_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
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
                            tr("Checkout.OrderTotals.Information"),
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
                          MainButton(
                            text: "Account.Login.BackHome",
                            onTap: () {
                              Get.offNamedUntil(
                                HomePage.route,
                                (route) => false,
                              );
                            },
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
            tr(title),
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
            child: Text(tr("Account.Order.Fields.BillingAddress")),
          ),
          _buildAlert(data?.notifiesAlert ?? ""),
          if (data?.infoPayment?.qRCodePayment != null)
            Center(
              child: SvgPicture.string(
                data!.infoPayment!.qRCodePayment!,
                width: scrSize(context).width * 0.6,
              ),
            ),
          Text(tr("ID ví: ")),
          Text(data?.infoPayment?.walletAddress ?? ""),
          MainButton(
            width: scrSize(context).width * 0.25,
            icon: const Icon(Icons.copy, color: Colors.white),
            text: "Common.Copy",
            onTap: () {
              try {
                if (data?.infoPayment?.walletAddress != null) {
                  Clipboard.setData(
                    ClipboardData(text: data!.infoPayment!.walletAddress!),
                  );
                }
                Toast.showSuccessToast("Common.CopyToClipboard.Succeeded");
              } catch (e) {
                Toast.showErrorToast("Common.CopyToClipboard.Failded");
              }
            },
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
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Icon(Icons.warning_rounded, color: Colors.red[50]),
                ),
              ),
            ),
            Flexible(
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
