import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/about_us_controller.dart';
import 'package:hkcoin/presentation.controllers/home_body_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/show_update_dialog_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  static String route = "/about-us";

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final controller = Get.put(AboutUsController());
  final homecontroller = Get.find<HomeBodyController>();
  String appVersion = '1.0.0';
  String appName = 'HKCoin';

  Future<void> _initPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      appName = packageInfo.appName;
    });
  }

  Future<void> _checkForUpdate() async {
    // Thêm logic kiểm tra cập nhật ở đây
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      homecontroller.checkUpdate();
      Get.back();
      if (homecontroller.updateResult.value != null &&
          homecontroller.updateResult.value!.updateAvailable) {
        ever(homecontroller.updateResult, (result) {
          if (result != null) {
            showUpdateDialog(context, updateResult: result);
          }
        });
      } else {
        Get.snackbar(
          context.tr("Account.PrivateMessage"),
          context.tr("Common.LatestVersion"),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (ex) {
      Get.back();
      Get.snackbar(
        context.tr("Admin.Common.Errors"),
        context.tr("Identity.Error.DefaultError"),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    Get.snackbar(
      context.tr("Account.PrivateMessage"),
      context.tr("Common.Update.Checking"),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _launchWebsite() async {
    final storeUrl = controller.store?.baseUrl; // Get URL from controller

    if (storeUrl == null || storeUrl.isEmpty) {
      Get.snackbar(
        context.tr("Admin.Common.Errors"),
        context.tr("Identity.Error.DefaultError"),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final uri = Uri.tryParse(storeUrl);
    if (uri == null || !uri.hasAbsolutePath) {
      Get.snackbar(
        context.tr("Admin.Common.Errors"),
        context.tr("Identity.Error.DefaultError"),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in browser app
      );
    } else {
      Get.snackbar(
        context.tr("Admin.Common.Errors"),
        context.tr("Identity.Error.DefaultError"),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AboutUsController>(
          id: "currentStore",
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BaseAppBar(title: "AboutUs"),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Phần logo và thông tin cơ bản
                          Container(
                            width: scrSize(context).width * 0.9,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Logo
                                Container(
                                  width: scrSize(context).width * 0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      controller.store?.logoUrl ?? '',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Tên ứng dụng
                                Text(
                                  controller.store?.name ?? appName,
                                  style: textTheme(context).headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),

                                // Phiên bản
                                Text(
                                  'Version $appVersion',
                                  style: textTheme(context).titleMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20), // Khoảng cách giữa 2 phần
                          // Card thông tin bổ sung
                          Container(
                            width: scrSize(context).width * 0.9,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).highlightColor.withOpacity(.12),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Phiên bản có thể click
                                InkWell(
                                  onTap: _checkForUpdate,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          context.tr('Common.CurrentVersion'),
                                          style: textTheme(context).bodyLarge,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              appVersion,
                                              style: textTheme(
                                                context,
                                              ).bodyMedium?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(height: 20),

                                // Trang web chính thức
                                InkWell(
                                  onTap: _launchWebsite,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          context.tr('Common.Website'),
                                          style: textTheme(context).bodyLarge,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
