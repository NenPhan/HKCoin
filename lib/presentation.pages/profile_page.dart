import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';
import 'package:hkcoin/presentation.controllers/profile_controller.dart';
import 'package:hkcoin/presentation.pages/about_us_page.dart';
import 'package:hkcoin/presentation.pages/change_password_page.dart';
import 'package:hkcoin/presentation.pages/customer_downlines_page.dart';
import 'package:hkcoin/presentation.pages/customer_info_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';
import 'package:hkcoin/presentation.pages/my_orders_page.dart';
import 'package:hkcoin/presentation.pages/update_kyc_page.dart';
import 'package:hkcoin/presentation.pages/withdrawalrequest_page.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/expandale_button.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List items = [
    {
      "name": "Account.WithDrawalRequest.Create",
      "icon": Icons.local_atm,
      "page": WithDrawRequestPage.route,
    },
    {
      "name": "Account.Downlines.Customers",
      "icon": Icons.people_alt_outlined,
      "page": CustomerDownlinesPage.route,
    },
    {
      "name": "Account.Management",
      "items": [
        {
          "name": "Account.CustomerInfo",
          "icon": Icons.person,
          "page": CustomerInfoPage.route,
        },
        // {
        //   "name": "Account.WalletToken",
        //   "icon": Icons.wallet,
        //   "page": WalletTokenPage.route,
        // },
        {
          "name": "Account.CustomerOrders",
          "icon": Icons.description,
          "page": MyOrdersPage.route,
        },
        {
          "name": "Account.KYC",
          "icon": Icons.security,
          "page": UpdateKycPage.route,
        },
      ],
    },
    {
      "name": "Account.ChangePassword",
      "icon": Icons.shield_outlined,
      "page": ChangePasswordPage.route,
    },
    {"name": "AboutUs", "icon": Icons.info, "page": AboutUsPage.route},
  ];
  @override
  void initState() {
    Get.put(ProfileController());
    super.initState();
  }

  _buildButton(Map<String, dynamic> item, {VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        onTap?.call();
        if (item["page"] != null) {
          Get.toNamed(item["page"]);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: scrSize(context).height * 0.02),
        child: SpacingRow(
          spacing: scrSize(context).width * 0.05,
          children: [
            Icon(item["icon"], size: scrSize(context).width * 0.07),
            Text(context.tr(item["name"]), style: textTheme(context).bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: "profile",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: scrSize(context).height * 0.02,
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      width: double.infinity,
                      height: scrSize(context).height * 0.15,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.deepOrange,
                            Colors.black,
                          ],
                          stops: [0.1, 0.4, 0.9],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.customerInfo?.fullName ?? "",
                                style: textTheme(context).titleLarge,
                              ),
                              Text(
                                controller.customerInfo?.email ?? "",
                                style: textTheme(context).bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  try {
                                    if (controller
                                            .customerInfo
                                            ?.affiliateLink !=
                                        null) {
                                      final String qrData =
                                          controller
                                              .customerInfo
                                              ?.affiliateLink ??
                                          "";
                                      xPopUpDialog(
                                        context,
                                        title: context.tr(
                                          "Account.CustomerInfo.Popup.QRCode.Title",
                                        ),
                                        description: context.tr(
                                          "Account.CustomerInfo.Popup.QRCode.Description",
                                        ),
                                        child: QRCodeWidget(
                                          data: qrData, // Dữ liệu QR code
                                          size: 250, // Kích thước
                                          logoWidget: TokenIconWidget(
                                            imageProvider:  Assets.images.hkcIcon.image(height: 45).image,
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
                                              'affiliateLink_${controller.customerInfo!.customerNumber}.png', // Tùy chọn tên file khi lưu
                                        ),
                                        centerTitle: true, // Căn giữa tiêu đề
                                        centerDescription:
                                            true, // Căn giữa mô tả
                                      );
                                    }
                                  } catch (e) {
                                    Toast.showErrorToast(
                                      "Common.CopyToClipboard.Failded",
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.qr_code,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  try {
                                    if (controller
                                            .customerInfo
                                            ?.customerNumber !=
                                        null) {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text:
                                              controller
                                                  .customerInfo!
                                                  .customerNumber,
                                        ),
                                      );
                                    }
                                    Toast.showSuccessToast(
                                      "Common.CopyToClipboard.SponsorCode.Succeeded",
                                    );
                                  } catch (e) {
                                    Toast.showErrorToast(
                                      "Common.CopyToClipboard.Failded",
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        controller
                                                .customerInfo
                                                ?.customerNumber ??
                                            "",
                                        style: textTheme(context).labelMedium,
                                      ),
                                      const Icon(
                                        Icons.copy_all,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  try {
                                    if (controller
                                            .customerInfo
                                            ?.affiliateLink !=
                                        null) {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text:
                                              controller
                                                  .customerInfo!
                                                  .affiliateLink,
                                        ),
                                      );
                                    }
                                    Toast.showSuccessToast(
                                      "Common.CopyToClipboard.AffiliateLink.Succeeded",
                                    );
                                  } catch (e) {
                                    Toast.showErrorToast(
                                      "Common.CopyToClipboard.Failded",
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.rotate(
                                        angle:
                                            -45 *
                                            3.141592653589793 /
                                            180, // Xoay 45 độ (chuyển từ độ sang radian)
                                        child: const Icon(
                                          Icons.link,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 15,
                      child: CustomDropDownButton(
                        buttonWidth: scrSize(context).width * 0.4,
                        dropdownWidth: scrSize(context).width * 0.4,
                        buttonHeight: 50,
                        selectedValue:
                            Get.find<LocaleController>().listLanguage
                                .where(
                                  (e) =>
                                      e.isoCode ==
                                      Get.find<LocaleController>()
                                          .localeIsoCode,
                                )
                                .first,
                        items: Get.find<LocaleController>().listLanguage,
                        onChanged: (language) async {
                          inspect(language);
                          var locale = language!.isoCode!.toLocaleFromIsoCode();
                          await context.setLocale(locale);
                          await Get.updateLocale(locale);
                          await Get.find<LocaleController>().setLanguage(
                            language.id,
                            locale,
                          );
                          // Restart.restartApp();
                        },
                        itemDesign: (item) {
                          return SpacingRow(
                            spacing: scrSize(context).width * 0.02,
                            children: [
                              Image.network(
                                item.flagImageFileName ?? "",
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  item.shortName ?? "",
                                  style: textTheme(context).bodyMedium,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(scrSize(context).width * 0.03),
                  child: Column(
                    children: [
                      ...List.generate(items.length, (index) {
                        if (items[index]["items"] != null) {
                          return ExpandaleButton(
                            title: items[index]["name"],
                            items: List.generate(items[index]["items"].length, (
                              index2,
                            ) {
                              return _buildButton(
                                items[index]["items"][index2],
                              );
                            }),
                          );
                        }
                        return _buildButton(items[index]);
                      }),
                      GetBuilder<ProfileController>(
                        id: "logout-button",
                        builder: (controller) {
                          return _buildButton(
                            {"name": "Account.Logout", "icon": Icons.logout},
                            onTap: () {
                              controller.logout(() {
                                Storage().dispose();
                                Get.offAllNamed(LoginPage.route);
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
