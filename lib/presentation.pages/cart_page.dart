import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';
import 'package:hkcoin/presentation.popups/delete_cart_popup.dart';
import 'package:hkcoin/presentation.popups/input_price_popup.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_icon_button.dart';
import 'package:hkcoin/widgets/main_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  static String route = "/cart";

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    Get.find<CartController>().getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CartController>(
          id: "cart",
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseAppBar(title: tr("Enums.RuleScope.Cart")),
                if (controller.cart == null || controller.cart!.items.isEmpty)
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: SpacingColumn(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              tr("Giỏ hàng trống"),
                              style: textTheme(context).titleMedium,
                            ),
                          ),
                          MainButton(
                            width: null,
                            text: tr("Trở về trang chủ"),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                if (controller.cart != null &&
                    controller.cart!.items.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(scrSize(context).width * 0.03),
                    margin: EdgeInsets.all(scrSize(context).width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SpacingRow(
                      spacing: scrSize(context).width * 0.05,
                      children: [
                        Image.network(
                          controller.cart!.items.first.image.thumbUrl.contains(
                                "http",
                              )
                              ? controller.cart!.items.first.image.thumbUrl
                              : "https:${controller.cart!.items.first.image.thumbUrl}",
                          width: scrSize(context).width * 0.2,
                          fit: BoxFit.cover,
                        ),
                        SpacingColumn(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.cart!.items.first.productName,
                              style: textTheme(context).titleLarge,
                            ),
                            Text(
                              "${controller.cart!.items.first.minimumCustomerEnteredPrice} - ${controller.cart!.items.first.maximumCustomerEnteredPrice}",
                              style: textTheme(
                                context,
                              ).bodyLarge?.copyWith(color: Colors.deepOrange),
                            ),

                            // ...List.generate(5, (index) {
                            //   return Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.all(
                            //       scrSize(context).width * 0.03,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Row(
                            //       children: [
                            //         Text(
                            //           "description[index]",
                            //           style: textTheme(context).bodyLarge,
                            //         ),
                            //         const Spacer(),
                            //         const Icon(
                            //           Icons.check,
                            //           color: Colors.deepOrange,
                            //         ),
                            //       ],
                            //     ),
                            //   );
                            // }),
                          ],
                        ),
                        const Spacer(),
                        CustomIconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onTap: () {
                            showPopUpDialog(
                              context,
                              DeleteCartPopup(
                                onConfirm: () async {
                                  var result =
                                      await Get.find<CartController>()
                                          .deleteCart();
                                  if (result) Get.back();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(scrSize(context).width * 0.03),
                    margin: EdgeInsets.all(scrSize(context).width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mức đầu tư: ${controller.cart!.items.first.unitPrice}",
                          style: textTheme(
                            context,
                          ).bodyLarge?.copyWith(color: Colors.white),
                        ),
                        CustomIconButton(
                          icon: const Icon(Icons.edit_rounded),
                          onTap: () {
                            showPopUpDialog(
                              context,
                              InputPricePopup(
                                onConfirm: (price) async {
                                  await Get.find<CartController>().updateCart(
                                    productId: controller.cart!.items.first.id,
                                    price: price,
                                  );
                                  Get.find<CartController>().getCartData();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  MainButton(
                    text: tr("Enums.WalletPostingReason.Purchase"),
                    onTap: () async {
                      var result = await controller.deleteCart();
                      if (result) {
                        Get.back();
                        Toast.showSuccessToast(tr("Thanh toán thành công"));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
