import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/checkout_complete_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';

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
                  ? const LoadingWidget()
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
                            tr("Thông tin đơn hàng"),
                            style: textTheme(context).titleMedium,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _buildTextInfoWidget(
                                  title: "Ngày đặt hàng",
                                  content: dateFormat(
                                    controller.data?.order.createdOn,
                                  ),
                                ),
                                _buildTextInfoWidget(
                                  title: "Mã đơn hàng",
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
                                  title: "Trạng thái đơn hàng",
                                  content:
                                      controller.data?.order.orderStatus ?? "",
                                ),
                                _buildTextInfoWidget(
                                  title: "Tổng đơn hàng",
                                  content:
                                      controller.data?.order.orderTotal ?? "",
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
                          _buildPaymentInfo(
                            controller.data?.infoPayment?.qRCodePayment,
                            controller.data?.infoPayment?.walletAddress ?? "",
                          ),
                          SizedBox(height: scrSize(context).height * 0.03),
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

  _buildPaymentInfo(String? svgString, String address) {
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
          if (svgString != null)
            Center(
              child: SvgPicture.string(
                svgString,
                width: scrSize(context).width * 0.6,
              ),
            ),
          const Text("ID ví: "),
          Text(address),
          MainButton(
            width: scrSize(context).width * 0.2,
            text: tr("Common.Copy"),
            onTap: () {
              try {
                Clipboard.setData(ClipboardData(text: address));
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
}
