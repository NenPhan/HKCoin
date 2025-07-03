import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/blockchange_wallet_controller.dart';
import 'package:hkcoin/presentation.controllers/create_wallet_controller.dart';
import 'package:hkcoin/presentation.pages/add_phase_mnemonic_page.dart';
import 'package:hkcoin/presentation.pages/wallet_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/confirm_dialog.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';

class AddWalletPage extends StatefulWidget {
  const AddWalletPage({super.key});
  static String route = "/add-wallet";

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final CreateWalletController controller = Get.put(CreateWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BaseAppBar(title: "Account.wallet.Addnew"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scrSize(context).width * 0.03,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      _buildWalletCard(
                        title: "Account.wallet.CreateNew",
                        description: "Account.wallet.CreateNew.Hint",
                        icon: Icons.add,
                        iconColor: Colors.amber.shade900,
                        cardBackgroundColor: Colors.white12,
                        iconBackgroundColor: Colors.white24,
                        titleColor: Colors.white70,
                        onTap: () {
                          ScreenPopup(
                            title: "Account.wallet.CreateNew",
                            headerColor: Colors.grey.shade300,
                            titleColor: Colors.black87,
                            iconColor: Colors.black87,
                            isDismissible: false,
                            heightFactor: .7,
                            child: Column(
                              children: [
                                buildExpandableCard(
                                  icon: Icons.account_balance_wallet,
                                  iconColor: Colors.teal,
                                  title: 'Account.wallet.CreateNew.Hint',
                                  titleColor: Colors.black87,
                                  description: 'Mô tả nhanh',
                                  descriptionColor: Colors.grey.shade700,
                                  expanTextColor: Colors.black54,
                                  detailText:
                                      "Account.wallet.CreateNew.DetailText",
                                  buttonText:
                                      'Account.wallet.CreateNew.BtnInput',
                                  onButtonPressed: () {
                                    ConfirmDialog.show(
                                      context: context,
                                      title: 'Common.Confirm',
                                      content:tr("Confirm.CreadWallet"),
                                      okText: 'Common.OK',
                                      cancelText: 'Common.Cancel',
                                      onOkPressed: () async {
                                        try {
                                          await controller
                                              .createWalletAutoGenerateMnemonic();
                                          final blockchangeWalletController =
                                              Get.find<
                                                BlockchangeWalletController
                                              >();
                                          await Get.toNamed(
                                            AddWalletPage.route,
                                          )?.then((result) {
                                            if (result != null) {
                                              blockchangeWalletController
                                                  .getWalletInfo();
                                              Get.offAllNamed(
                                                WalletPage.route,
                                              ); // Navigate back to WalletPage
                                            }
                                          });
                                        } catch (e) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to create wallet: $e',
                                              ),
                                            ),
                                          );
                                        } finally {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      onCancelPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  tags: [
                                    {
                                      'label': 'Account.wallet.Tags.Mnemonic',
                                      'textColor': Colors.black,
                                      'backgroundColor': Colors.grey.shade300,
                                    },
                                    {
                                      'label': 'Account.wallet.Tags.PrivateKey',
                                      'textColor': Colors.black,
                                      'backgroundColor': Colors.grey.shade300,
                                    },
                                  ],
                                  buttonColor: Colors.amber.shade900,
                                  buttonTextColor: Colors.white,
                                  backgroundHeaderColor: Colors.teal.shade50,
                                ),
                              ],
                            ),
                          ).show(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildWalletCard(
                        title: "Account.wallet.Enter",
                        description: "Account.wallet.Enter.Hint",
                        icon: Icons.expand_more,
                        iconColor: Colors.amber.shade900,
                        cardBackgroundColor: Colors.white12,
                        iconBackgroundColor: Colors.white24,
                        titleColor: Colors.white70,
                        onTap: () {
                          ScreenPopup(
                            title: "Account.wallet.Enter",
                            headerColor: Colors.grey.shade300,
                            titleColor: Colors.black87,
                            iconColor: Colors.black87,
                            isDismissible: false,
                            heightFactor: .7,
                            child: Column(
                              children: [
                                buildExpandableCard(
                                  icon: Icons.account_balance_wallet,
                                  iconColor: Colors.teal,
                                  title: 'Account.wallet.CreateNew.Hint',
                                  titleColor: Colors.black87,
                                  description: 'Mô tả nhanh',
                                  descriptionColor: Colors.grey.shade700,
                                  expanTextColor: Colors.black54,
                                  buttonText:
                                      'Account.wallet.CreateNew.BtnInput',
                                  onButtonPressed: () {
                                    Get.toNamed(AddMnemonicPage.route);
                                  },
                                  tags: [
                                    {
                                      'label': 'Account.wallet.Tags.Mnemonic',
                                      'textColor': Colors.black,
                                      'backgroundColor': Colors.grey.shade300,
                                    },
                                    {
                                      'label': 'Account.wallet.Tags.PrivateKey',
                                      'textColor': Colors.black,
                                      'backgroundColor': Colors.grey.shade300,
                                    },
                                  ],
                                  buttonColor: Colors.amber.shade900,
                                  buttonTextColor: Colors.white,
                                  backgroundHeaderColor: Colors.teal.shade50,
                                ),
                              ],
                            ),
                          ).show(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard({
    required String title,
    String? description,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.blue,
    Color iconBackgroundColor = const Color(
      0xFFE3F2FD,
    ), // mặc định blue.shade50
    Color cardBackgroundColor = Colors.white,
    Color titleColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: cardBackgroundColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon bên trái
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 16),

              // Thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(title),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor, //
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr(description ?? ""),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Mũi tên bên phải
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandableCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color titleColor,
    required String description,
    required Color descriptionColor,
    String? detailText,
    required String buttonText,
    required VoidCallback onButtonPressed,
    required List<Map<String, dynamic>> tags, // ✅ tag với màu
    required Color buttonColor,
    required Color buttonTextColor,
    required Color backgroundHeaderColor,
    Color backgroundBodyColor = const Color(0xFFF5F5F5),
    Color borderColor = const Color(0xFFE0E0E0),
    Color expanTextColor = const Color(0xFFE0E0E0),
  }) {
    bool expanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onButtonPressed,
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: backgroundHeaderColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor),
                      ),
                      const SizedBox(width: 12),
                      // Title & toggle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr(title),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (detailText != null && detailText.isNotEmpty)
                              InkWell(
                                onTap:
                                    () => setState(() => expanded = !expanded),
                                child: Text(
                                  context.tr("Common.ExpandCollapseAll"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: expanTextColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Button
                      ElevatedButton(
                        onPressed: onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(context.tr(buttonText)),
                      ),
                    ],
                  ),
                ),

                // Body content
                Container(
                  width: double.infinity,
                  color: backgroundBodyColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Tags
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        tag['backgroundColor'] ??
                                        Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    context.tr(tag['label'] ?? ''),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: tag['textColor'] ?? Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut,
                        child:
                            expanded &&
                                    detailText != null &&
                                    detailText.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    context.tr(detailText),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: descriptionColor,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
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
