import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/presentation.controllers/blockchange_wallet_controller.dart';
import 'package:hkcoin/presentation.pages/add_wallet_bycontract_page.dart';
import 'package:hkcoin/presentation.pages/add_wallet_page.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_detail_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/screen_popup_widget.dart';
import 'package:hkcoin/widgets/shimmer_skeleton.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  static String route = "/wallet-info-page";

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final controller = Get.put(BlockchangeWalletController());
  Future<void> _onRefresh() async {
    // Call getWallet on refresh
    await controller.getWalletInfo();
    // Update GetBuilder
    controller.update(['wallet-info-page']);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlockchangeWalletController>(
      id: "wallet-info-page",
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Column(
                    children: [
                      BaseAppBar(
                        isBackEnabled: false,
                        actionWidget: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  ScreenPopup(
                                    title: "Account.wallet.Network.Selected",
                                    isDismissible: false,
                                    backgroundColor: const Color(0xFF1B1B1B),
                                    heightFactor: .75,
                                    child: Obx(
                                      () => Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller:
                                                controller.searchController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Account.wallet.Network.Filter',
                                              prefixIcon: Icon(Icons.search),
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.white10,
                                            ),
                                            onChanged: (value) {
                                              //controller.filterNetworks(value);
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.55,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount:
                                                  controller
                                                      .listNetwork
                                                      .length, // Fix null list
                                              itemBuilder: (ctx, index) {
                                                final network =
                                                    controller
                                                        .listNetwork[index];
                                                final isSelected =
                                                    controller
                                                        .selectedNetwork
                                                        .value
                                                        ?.id ==
                                                    network
                                                        .id; // Fix null selected
                                                return Card(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4,
                                                      ),
                                                  color:
                                                      isSelected
                                                          ? const Color(
                                                            0xFF353434,
                                                          )
                                                          : null,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      if (isSelected)
                                                        Positioned(
                                                          left: 0,
                                                          top: 0,
                                                          bottom: 0,
                                                          child: Container(
                                                            width: 4,
                                                            height: 15,
                                                            decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.circular(
                                                                          4,
                                                                        ),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                          4,
                                                                        ),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ListTile(
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        leading: const Icon(
                                                          Icons.wifi,
                                                          color: Colors.white70,
                                                          size: 24,
                                                        ),
                                                        title: Text(
                                                          network.name ??
                                                              "Unnamed Wallet",
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        ),
                                                        trailing: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white70,
                                                        ),
                                                        onTap: () {
                                                          controller
                                                              .selectNetwork(
                                                                network,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).show(context);
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap:
                                        () => _showWalletPopup(
                                          context,
                                          controller,
                                        ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          controller.walletsInfo?.name ??
                                              context.tr(
                                                "Account.wallet.Addnew",
                                              ),
                                          style: textTheme(
                                            context,
                                          ).titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Header Row
                      const SizedBox(height: 10),
                      if (controller.isLoading.value ||
                          controller.walletsInfo == null) ...[
                        // 👉 SHIMMER HEADER (2 ROW: nhỏ + to)
                        AppSkeleton(blocks: WalletHeaderSkeleton.build()),
                        const SizedBox(height: 40),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                controller.walletsInfo?.walletAddressFormat ??
                                    "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow:
                                    TextOverflow
                                        .ellipsis, // Cắt ngắn văn bản nếu quá dài
                                maxLines: 1, // Giới hạn chỉ 1 dòng
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (controller.walletsInfo?.walletAddress !=
                                    null) {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          controller
                                              .walletsInfo!
                                              .walletAddress!,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.tr("Common.CopyToClipboard"),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Balance
                        FormattedNumber(
                          value: controller.walletsInfo?.totalBalance ?? 0,
                          decimalDigits: 3,
                          style: const TextStyle(fontSize: 22),
                          prefix: r"$",
                        ),
                        const SizedBox(height: 40),
                      ],
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.2,
                            ), // Nền trắng nhạt
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, size: 28),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (controller.walletsInfo == null) {
                                Get.toNamed(AddWalletPage.route)?.then((
                                  result,
                                ) {
                                  if (result != null) {
                                    controller.getWalletInfo();
                                    Get.back(result: true);
                                  }
                                });
                              } else {
                                Get.toNamed(
                                  AddWalletWithContractPage.route,
                                  arguments: {
                                    'walletAddress':
                                        controller.walletsInfo!.walletAddress!,
                                    'id':
                                        controller
                                            .walletsInfo!
                                            .id!, // Thêm id vào arguments
                                  },
                                )?.then((result) {
                                  if (result != null) {
                                    controller.getWalletInfo();
                                    Get.back(result: true);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ), // Hide widget when walletInfo is null
                      if (controller.isLoadingList.value) ...[
                        AppSkeleton(blocks: TokenListSkeleton.build(count: 3)),
                      ] else ...[
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.walletInfos.length,
                            itemBuilder: (context, index) {
                              final wallet = controller.walletInfos[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Get.toNamed(
                                      WalletTokenDetailPage.route,
                                      arguments: wallet.id,
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    color: const Color(0xFF1E1E1E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          // Chain Logo/Icon
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue.withOpacity(
                                                0.2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Chain Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  wallet.chain.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                // const SizedBox(height: 4),
                                                // Text(
                                                //   wallet.walletAddress,
                                                //   style: const TextStyle(
                                                //     fontSize: 12,
                                                //     color: Colors.grey,
                                                //   ),
                                                //   maxLines: 1,
                                                //   overflow: TextOverflow.ellipsis,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          // Balance Info
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FormattedNumber(
                                                value: wallet.totalBalance,
                                                decimalDigits:
                                                    wallet.chain == Chain.BNB
                                                        ? 5
                                                        : 3,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                suffix: wallet.chain.name,
                                              ),
                                              const SizedBox(height: 4),
                                              FormattedNumber(
                                                value: wallet.totalBalanceUSD,
                                                decimalDigits: 3,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                prefix: r"$",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr("Account.wallet.Token.DontSee"),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                if (controller.walletsInfo == null) {
                                  Get.toNamed(AddWalletPage.route)?.then((
                                    result,
                                  ) {
                                    if (result != null) {
                                      controller.getWalletInfo();
                                      Get.back(result: true);
                                    }
                                  });
                                } else {
                                  Get.toNamed(
                                    AddWalletWithContractPage.route,
                                    arguments: {
                                      'walletAddress':
                                          controller
                                              .walletsInfo!
                                              .walletAddress!,
                                      'id':
                                          controller
                                              .walletsInfo!
                                              .id!, // Thêm id vào arguments
                                    },
                                  )?.then((result) {
                                    if (result != null) {
                                      controller.getWalletInfo();
                                      Get.back(result: true);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                context.tr("Account.wallet.Token.Add"),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    BlockchangeWalletController controller,
  ) {
    return MainButton(
      width: double.infinity,
      text: "HomePage",
      onTap: () async {
        Get.offNamedUntil(HomePage.route, (route) => false);
      },
    );
  }

  void _showWalletPopup(
    BuildContext context,
    BlockchangeWalletController controller,
  ) {
    ScreenPopup(
      title: "Account.wallet.List",
      isDismissible: false,
      backgroundColor: const Color(0xFF1B1B1B),
      heightFactor: 0.65,
      onShow: () => controller.getWallets(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GetBuilder<BlockchangeWalletController>(
              id: "blockchange-wallets",
              builder: (controller) {
                if (controller.isLoadingWallets.value ||
                    controller.wallets.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.wallets.length,
                  itemBuilder: (ctx, index) {
                    final wallet = controller.wallets[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 15),
                      minVerticalPadding: 0,
                      onTap: () {
                        if (!wallet.selected!) {
                          controller.selectWallet(wallet);
                          Get.back(result: true);
                        }
                      },
                      title: Text(wallet.name ?? "Unnamed Wallet"),
                      subtitle: FormattedNumber(
                        value: wallet.balance ?? 0,
                        decimalDigits: 2,
                        style: const TextStyle(fontSize: 18),
                        prefix: r"$",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (wallet.selected ?? false)
                            const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(width: 5),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Get.toNamed(
                                WalletDetailPage.route,
                                arguments: wallet.id,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Get.toNamed(AddWalletPage.route)?.then((result) {
                      if (result != null) {
                        controller.getWalletInfo();
                        Get.back(result: true);
                      }
                    });
                  },
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(
                    context.tr("Account.wallet.Addnew"),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).show(context);
  }
}

class WalletHeaderSkeleton {
  static List<SkeletonBlock> build() {
    return [
      const SkeletonBlock(
        hasBackground: false,
        padding: EdgeInsets.symmetric(vertical: 24),
        rows: [
          SkeletonRow(
            alignment: MainAxisAlignment.center,
            items: [SkeletonItem(width: 120, height: 12)],
          ),
          SkeletonRow(
            alignment: MainAxisAlignment.center,
            items: [SkeletonItem(width: 180, height: 28)],
          ),
        ],
      ),
    ];
  }
}

class TokenListSkeleton {
  static List<SkeletonBlock> build({int count = 3}) {
    return List.generate(count, (_) => TokenRowSkeleton.build());
  }
}

class TokenRowSkeleton {
  static SkeletonBlock build() {
    return SkeletonBlock(
      rows: [
        SkeletonRow(
          items: [
            SkeletonItem(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
            ),
            const SkeletonItem(expand: true, height: 14),
          ],
        ),
        const SkeletonRow(items: [SkeletonItem(width: 120, height: 12)]),
      ],
    );
  }
}
