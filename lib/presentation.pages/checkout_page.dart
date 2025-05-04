import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';
import 'package:hkcoin/presentation.controllers/checkout_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: SpacingColumn(
                          spacing: 10,
                          children: [
                            const SizedBox(height: 5),
                            if (controller.data != null)
                              AddressWidget(
                                address: controller.data?.existingAddresses,
                                onChanged: () {
                                  controller.getCheckoutData();
                                },
                              ),
                            if (controller.cart != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  scrSize(context).width * 0.03,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: scrSize(context).width * 0.03,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SpacingRow(
                                  spacing: scrSize(context).width * 0.05,
                                  children: [
                                    Image.network(
                                      controller
                                              .cart!
                                              .items
                                              .first
                                              .image
                                              .thumbUrl
                                              .contains("http")
                                          ? controller
                                              .cart!
                                              .items
                                              .first
                                              .image
                                              .thumbUrl
                                          : "https:${controller.cart!.items.first.image.thumbUrl}",
                                      width: scrSize(context).width * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                    SpacingColumn(
                                      spacing: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .cart!
                                              .items
                                              .first
                                              .productName,
                                          style: textTheme(context).titleSmall,
                                        ),
                                        Text(
                                          "${controller.cart!.items.first.minimumCustomerEnteredPrice} - ${controller.cart!.items.first.maximumCustomerEnteredPrice}",
                                          style: textTheme(
                                            context,
                                          ).bodyMedium?.copyWith(
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.cart != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  scrSize(context).width * 0.03,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: scrSize(context).width * 0.03,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mức đầu tư: ${controller.cart!.items.first.unitPrice}",
                                      style: textTheme(context).bodyMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.data != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  scrSize(context).width * 0.03,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: scrSize(context).width * 0.03,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      tr("Checkout.PaymentMethod"),
                                      style: textTheme(context).bodyLarge
                                          ?.copyWith(color: Colors.white),
                                    ),

                                    ...List.generate(
                                      controller
                                              .data
                                              ?.paymentMethod
                                              ?.paymentMethods
                                              ?.length ??
                                          0,
                                      (index) {
                                        var method =
                                            controller
                                                .data
                                                ?.paymentMethod
                                                ?.paymentMethods?[index];

                                        return GestureDetector(
                                          onTap: () {
                                            for (PaymentMethodElement item
                                                in controller
                                                        .data
                                                        ?.paymentMethod
                                                        ?.paymentMethods ??
                                                    []) {
                                              item.selected = false;
                                            }
                                            method?.selected = true;
                                            controller.selectPaymentMethod(
                                              method?.paymentMethodSystemName,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey[800]!,
                                                ),
                                              ),
                                            ),
                                            child: SpacingRow(
                                              spacing: 15,
                                              children: [
                                                Image.network(
                                                  method?.brandUrl ?? "",
                                                  width: 30,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    method?.name ?? "",
                                                  ),
                                                ),
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        method?.selected ??
                                                                false
                                                            ? Colors.deepOrange
                                                            : Colors
                                                                .transparent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child:
                                                      method?.selected ?? false
                                                          ? const Center(
                                                            child: Icon(
                                                              Icons.check,
                                                              size: 15,
                                                            ),
                                                          )
                                                          : const SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.data != null)
                              Html(data: controller.data?.termsOfService),
                            SizedBox(height: scrSize(context).width * 0.25),
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
                            Text(
                              controller.orderTotal?.orderTotal ?? "",
                              style: textTheme(context).titleSmall,
                            ),
                          ],
                        ),
                        SizedBox(width: scrSize(context).width * 0.03),
                        GetBuilder<CheckoutController>(
                          id: "checkout-button",
                          builder: (controller) {
                            return MainButton(
                              width: scrSize(context).width * 0.3,
                              isLoading: controller.isCheckingOut,
                              text: tr("Checkout"),
                              onTap: () async {
                                var result =
                                    await controller.checkoutComplete();
                                if (result) {
                                  Get.find<CartController>().getCartData();
                                  Get.offNamedUntil(
                                    HomePage.route,
                                    (route) => false,
                                  );
                                  Toast.showSuccessToast(
                                    "Thanh toán thành công",
                                  );
                                }
                              },
                            );
                          },
                        ),
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
