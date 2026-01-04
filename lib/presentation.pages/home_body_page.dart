import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/cart_controller.dart';
import 'package:hkcoin/presentation.controllers/home_body_controller.dart';
import 'package:hkcoin/presentation.controllers/private_message_controller.dart';
import 'package:hkcoin/presentation.pages/cart_page.dart';
import 'package:hkcoin/presentation.pages/private_message_page.dart';
import 'package:hkcoin/widgets/coin_exchange_rate_widget.dart';
import 'package:hkcoin/widgets/count_display_button.dart';
import 'package:hkcoin/widgets/custom_icon_button.dart';
import 'package:hkcoin/widgets/gscankit-main/barcode_scanner.dart';
import 'package:hkcoin/widgets/home_banner_widget.dart';
import 'package:hkcoin/widgets/home_product_widget.dart';
import 'package:hkcoin/widgets/news_widget.dart';
import 'package:hkcoin/widgets/shimmer_container.dart';
import 'package:hkcoin/widgets/show_update_dialog_widget.dart';
import 'package:hkcoin/widgets/stores/store_brand_widget.dart';

class HomeBodyPage extends StatefulWidget {
  const HomeBodyPage({super.key});

  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<HomeBodyPage> {
  final HomeBodyController homeBodyController = Get.put(HomeBodyController());
  @override
  void initState() {
    ever(homeBodyController.updateResult, (result) {
      if (result != null && result.updateAvailable) {
        showUpdateDialog(Get.context!, updateResult: result);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          0,
        ),
        child: SingleChildScrollView(
          child: SpacingColumn(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const StoreBrandWidget(
                    type: StoreBrandType.full,
                    logoSize: 170,
                  ),
                  // Hero(
                  //   tag: "main-logo",
                  //   child: Assets.images.hkcLogo.image(height: 45),
                  // ),
                  const Spacer(),
                  CustomIconButton(
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 30),
                    onTap: () {
                      Get.to(
                        () => GscanKit(
                          onInitstate: () {},
                          appBar: (context, controller) {
                            return AppBar(
                              title: Text(
                                context.tr("QRCode.Scan"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              leading: InkWell(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                            );
                          },
                          flashHintText: context.tr("QRCode.Scan.Flash.Tip"),
                          scanResultHandler: UniversalQrHandler(
                            purpose: ScanPurpose.generic,
                          ),
                          enabledActionButtons: const {
                            ScannerAction.cameraSwitch,
                            ScannerAction.torch,
                            ScannerAction.gallery,
                          },
                          gscanOverlayConfig: const GscanOverlayConfig(
                            scannerScanArea: ScannerScanArea.center,
                            scannerBorder: ScannerBorder.visible,
                            scannerBorderPulseEffect:
                                ScannerBorderPulseEffect.enabled,
                            borderColor: Colors.white,
                            borderRadius: 24.0,
                            scannerLineAnimationColor: Colors.green,
                            scannerOverlayBackground:
                                ScannerOverlayBackground.blur,
                            scannerLineAnimation: ScannerLineAnimation.enabled,
                          ),
                        ),
                        fullscreenDialog: true, // 🔥 rất nên dùng cho camera
                      );
                    },
                  ),
                  GetBuilder<CartController>(
                    id: "home-cart-icon",
                    builder: (controller) {
                      return CustomIconButton(
                        icon: const Icon(Icons.shopping_bag, size: 30),
                        onTap: () {
                          Get.toNamed(CartPage.route);
                        },
                        noticeBadge: controller.cart?.items.isNotEmpty ?? false,
                      );
                    },
                  ),
                  GetBuilder<PrivateMessageController>(
                    id: "home-message-icon",
                    builder: (controller) {
                      return CountDisplay(
                        key: UniqueKey(),
                        icon: const Icon(Icons.notifications, size: 30),
                        countColor: Colors.amber[900]!,
                        onTap: () {
                          Get.toNamed(PrivateMessagePage.route)?.then((_) {
                            // Refresh count khi quay về từ trang tin nhắn
                            controller.refreshMessageCount();
                          });
                        },
                        count: controller.privateMessageCount.value,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GetBuilder<HomeBodyController>(
                id: "wallet-info",
                builder: (controller) {
                  return controller.isLoadingWallet.value
                      ? ShimmerContainer(
                        height: (scrSize(context).width * 0.08) * 5,
                      )
                      : Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: scrSize(context).width * 0.03,
                        ),
                        decoration: BoxDecoration(
                          // color: Colors.deepOrange,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 249, 194, 12),
                              Colors.deepOrange,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr("Account.Report.Shopping"),
                              style: textTheme(context).bodyLarge,
                            ),
                            const SizedBox(height: 10),
                            SpacingColumn(
                              spacing: 10,
                              children: [
                                Center(
                                  child: Text(
                                    controller.walletInfo?.walletShopping ?? "",
                                    style: textTheme(
                                      context,
                                    ).titleLarge?.copyWith(
                                      fontSize: scrSize(context).width * 0.08,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    controller.walletInfo?.profitsShopping ??
                                        "",
                                    style: textTheme(context).titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                },
              ),
              const SizedBox(height: 10),
              GetBuilder<HomeBodyController>(
                id: "home-slide",
                builder: (controller) {
                  return HomeSlideWidget(
                    isLoading: controller.isLoadingSlide,
                    slides: controller.slides,
                  );
                },
              ),
              GetBuilder<HomeBodyController>(
                id: "exchange-rate",
                builder: (controller) {
                  return CoinExchangeRateWidget(
                    data: controller.rxchangeRateData ?? "",
                  );
                },
              ),
              const SizedBox(height: 10),
              GetBuilder<HomeBodyController>(
                id: "product-list",
                builder:
                    (controller) =>
                        HomeProductWidget(products: controller.products),
              ),
              const SizedBox(height: 10),
              GetBuilder<HomeBodyController>(
                id: "news-list",
                builder: (controller) {
                  return NewsListWidget(
                    news: controller.news,
                    isLoading: controller.isLoadingNews.value,
                  );
                },
              ),
              // const SizedBox(height: homeBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
