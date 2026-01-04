import 'package:hkcoin/core/extensions/enum_type_extension.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/profile_controller.dart';
import 'package:hkcoin/presentation.pages/about_us_page.dart';
import 'package:hkcoin/presentation.pages/change_password_page.dart';
import 'package:hkcoin/presentation.pages/customer_downlines_page.dart';
import 'package:hkcoin/presentation.pages/customer_info_page.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';
import 'package:hkcoin/presentation.pages/my_orders_page.dart';
import 'package:hkcoin/presentation.pages/update_kyc_page.dart';
import 'package:hkcoin/presentation.pages/withdrawalrequest_page.dart';
import 'package:hkcoin/widgets/language_selector.dart';
import 'package:hkcoin/widgets/qrcode_widget.dart';
import 'package:hkcoin/widgets/stores/store_brand_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    final controller = Get.put(ProfileController());
    controller.loadAppInfo(); // 👈
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      id: "profile",
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 190,
                  elevation: 0,
                  backgroundColor: Colors.black54, // ⭐ NỀN TRẮNG
                  surfaceTintColor: Colors.black, // ⭐ QUAN TRỌNG (Material 3)
                  shadowColor: Colors.white.withOpacity(0.05),

                  // ===== APPBAR KHI CUỘN LÊN =====
                  titleSpacing: 16,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10), // ⭐ HẠ LOGO + TEXT
                    child: Row(
                      children: [
                        StoreBrandWidget(
                          type: StoreBrandType.icon,
                          logoSize: 45,
                          textTransform: TextTransform.uppercase,
                          titleStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          subtitle: context.tr("Account.MyAccount"),
                          subtitleStyle: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ===== HEADER KHI MỞ RỘNG =====
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 6, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight),

                          Text(
                            controller.customerInfo?.fullName ?? "",
                            style: textTheme(context).titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.customerInfo?.email ?? "Chưa có email",
                            style: textTheme(context).bodyMedium,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              circleIcon(
                                context,
                                icon: Icons.qr_code,
                                onTap: () {
                                  if (controller.customerInfo?.affiliateLink !=
                                      null) {
                                    xPopUpDialog(
                                      context,
                                      title: context.tr(
                                        "Account.CustomerInfo.Popup.QRCode.Title",
                                      ),
                                      description: context.tr(
                                        "Account.CustomerInfo.Popup.QRCode.Description",
                                      ),
                                      child: QRCodeWidget(
                                        data:
                                            controller
                                                .customerInfo
                                                ?.affiliateLink ??
                                            "",
                                        size: 240,
                                      ),
                                    );
                                  }
                                },
                              ),
                              circleIcon(
                                context,
                                icon: Icons.copy,
                                label: controller.customerInfo?.customerNumber,
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          controller
                                              .customerInfo
                                              ?.customerNumber ??
                                          "",
                                    ),
                                  );
                                  Toast.showSuccessToast(
                                    "Common.CopyToClipboard.SponsorCode.Succeeded",
                                  );
                                },
                              ),
                              circleIcon(
                                context,
                                icon: Icons.link_sharp,
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          controller
                                              .customerInfo
                                              ?.affiliateLink ??
                                          "",
                                    ),
                                  );
                                  Toast.showSuccessToast(
                                    "Common.CopyToClipboard.SponsorCode.Succeeded",
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ProfileInfoCard(
                        title: "Account.CustomerInfo",
                        trailing: GestureDetector(
                          onTap: () {
                            Get.toNamed(CustomerInfoPage.route);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.tr("Common.Edit"),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          ProfileInfoRow(
                            icon: Icons.person,
                            label: "Account.Fields.FullName",
                            value: controller.customerInfo?.fullName ?? "",
                          ),
                          if (controller.customerInfo?.birthDate ?? false)
                            Divider(color: Colors.grey.withOpacity(0.3)),
                          if (controller.customerInfo?.birthDate ?? false)
                            ProfileInfoRow(
                              icon: Icons.cake,
                              label: "Account.Fields.DateOfBirth",
                              value:
                                  controller.customerInfo?.birthDate
                                      ?.formatDate() ??
                                  "",
                            ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ProfileInfoRow(
                            icon: Icons.wc,
                            label: "Account.Fields.Gender",
                            value:
                                controller.customerInfo?.gender?.display(
                                  context,
                                ) ??
                                "",
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ProfileInfoRow(
                            icon: Icons.phone,
                            label: "Account.Fields.Phone",
                            value: controller.customerInfo?.phone ?? "",
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ProfileInfoRow(
                            icon: Icons.email,
                            label: "Email",
                            value:
                                controller.customerInfo?.email ??
                                "Chưa có email",
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ProfileInfoRow(
                            icon: Icons.account_circle,
                            label: "Account.Fields.Username",
                            value: controller.customerInfo?.username ?? "",
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                        ],
                      ),
                      ProfileInfoCard(
                        children: [
                          ListTile(
                            dense: true, // ⭐ giảm chiều cao tổng thể
                            visualDensity: const VisualDensity(vertical: -2),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            leading: Icon(
                              Icons.local_atm,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              context.tr("Account.WithDrawalRequest.Create"),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.toNamed(WithDrawRequestPage.route);
                            },
                          ),
                        ],
                      ),
                      ProfileInfoCard(
                        children: [
                          ListTile(
                            dense: true, // ⭐ giảm chiều cao tổng thể
                            visualDensity: const VisualDensity(vertical: -2),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            leading: Icon(
                              Icons.people_alt_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              context.tr("Account.Downlines.Customers"),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.toNamed(CustomerDownlinesPage.route);
                            },
                          ),
                        ],
                      ),
                      ProfileInfoCard(
                        title: "Account.Management",
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.description,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(context.tr("Account.CustomerOrders")),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.toNamed(MyOrdersPage.route);
                            },
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ListTile(
                            leading: const Icon(
                              Icons.security,
                              color: Colors.red,
                            ),
                            title: Text(context.tr("Account.KYC")),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.toNamed(UpdateKycPage.route);
                            },
                          ),
                        ],
                      ),
                      ProfileInfoCard(
                        title: "Account.Securities",
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.shield_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(context.tr("Account.ChangePassword")),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.toNamed(ChangePasswordPage.route);
                            },
                          ),
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: Text(
                              context.tr("Account.Logout"),
                              style: const TextStyle(color: Colors.red),
                            ),
                            onTap: () {
                              controller.logout(() {
                                Storage().dispose();
                                Get.offAllNamed(LoginPage.route);
                              });
                            },
                          ),
                        ],
                      ),
                      const ProfileInfoCard(
                        children: [
                          LanguageSelectorPro(textColor: Colors.white),
                        ],
                      ),
                      // -------- Thông tin ứng dụng --------
                      ProfileInfoCard(
                        title: "Common.Application.Information",
                        trailing: GestureDetector(
                          onTap: () {
                            Get.toNamed(AboutUsPage.route);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.tr("Common.Edit"),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          ProfileInfoRow(
                            icon: Icons.verified,
                            label: "Common.CurrentVersion",
                            value: controller.appVersion.value,
                          ),
                          const ProfileInfoRow(
                            icon: Icons.devices,
                            label: "Common.Platform",
                            value: "Android / iOS",
                          ),
                          const ProfileInfoRow(
                            icon: Icons.business,
                            label: "Common.License",
                            value: "HKC",
                          ),
                          const ProfileInfoRow(
                            icon: Icons.copyright,
                            label: "Common.License",
                            value: "© 2025 HKC",
                          ),
                        ],
                      ),

                      const SizedBox(height: homeBottomPadding),
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

  static Widget circleIcon(
    BuildContext context, {
    required IconData icon,
    String? label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Color? backgroundColor,
    double iconSize = 20,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
  }) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    final resolvedIconColor = iconColor ?? primary;
    final resolvedTextColor = textColor ?? primary;
    final resolvedBgColor = backgroundColor ?? primary.withOpacity(0.12);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: resolvedBgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TEXT (HIỆN TRƯỚC)
            if (label != null) ...[
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: resolvedTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],

            // ICON
            Icon(icon, size: iconSize, color: resolvedIconColor),
          ],
        ),
      ),
    );
  }
}
// ================= COMPONENTS =================

class ProfileInfoCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? trailing;

  const ProfileInfoCard({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null)
                Expanded(
                  child: Text(
                    context.tr(title ?? ""),
                    style: textTheme(
                      context,
                    ).titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              if (trailing != null) trailing!,
            ],
          ),
          // ===== SUBTITLE (nếu có) =====
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              context.tr(subtitle!),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          const SizedBox(height: 5),
          ...children,
        ],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(label),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
