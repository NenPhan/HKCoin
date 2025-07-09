import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/time_converter.dart';
import 'package:hkcoin/data.models/blockchain_transaction.dart';
import 'package:hkcoin/presentation.controllers/wallet_token_detail_controller.dart';
import 'package:hkcoin/presentation.pages/wallet_token_received_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_send_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/formated_number_widget.dart';
import 'package:hkcoin/widgets/token_icon_widget.dart';

class WalletTokenDetailPage extends StatefulWidget {
  const WalletTokenDetailPage({super.key});
  static String route = "/wallet-token-detail";

  @override
  State<WalletTokenDetailPage> createState() => _WalletTokenDetailPageState();
}

class _WalletTokenDetailPageState extends State<WalletTokenDetailPage> {
  final WalletTokenDetailController controller = Get.put(
    WalletTokenDetailController(),
  );
  Future<void> _onRefresh() async {
    // Call getWallet on refresh
    await controller.getWalletInfo(Get.arguments);
    // Update GetBuilder
    controller.update(['wallet-token-detail-page']);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletTokenDetailController>(
      id: "wallet-token-detail-page",
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SafeArea(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        BaseAppBar(
                          title: controller.walletsInfo?.symbol ?? "",
                          centerTitle: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6, // Tỉ lệ 6
                                child: Container(
                                  height: 36, // Chiều cao cố định
                                  margin: const EdgeInsets.only(
                                    right: 5,
                                  ), // Khoảng cách phải 5px (tổng 2 bên là 10px)
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    // Căn giữa nội dung theo chiều dọc và ngang
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min, // Co lại vừa đủ nội dung
                                        children: [
                                          const Icon(
                                            Icons.account_balance_wallet,
                                            size: 18,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            // Cho phép text co dãn trong container
                                            child: Text(
                                              controller.walletsInfo?.walletName ??
                                                  'My Wallet',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white70,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign:
                                                  TextAlign.left, // Căn giữa text
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Cột bên phải - Địa chỉ ví với nút copy (chiếm 40%)
                              Expanded(
                                flex: 4, // Tỉ lệ 4
                                child: Container(
                                  height: 36, // Chiều cao cố định
                                  margin: const EdgeInsets.only(
                                    left: 5,
                                  ), // Khoảng cách trái 5px (tổng 2 bên là 10px)
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center, // Căn giữa toàn bộ nội dung
                                    children: [
                                      Expanded(
                                        // Phần text chiếm hết không gian còn lại
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(
                                            controller.walletsInfo?.walletAddress !=
                                                    null
                                                ? '${controller.walletsInfo!.walletAddress!.substring(0, 5)}...${controller.walletsInfo!.walletAddress!.substring(controller.walletsInfo!.walletAddress!.length - 4)}'
                                                : '0x1a2...b3c4',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign:
                                                TextAlign.center, // Căn giữa text
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 36, // Cố định kích thước nút copy
                                        child: IconButton(
                                          icon: const Icon(Icons.copy, size: 18),
                                          onPressed: () {
                                            if (controller
                                                    .walletsInfo
                                                    ?.walletAddress !=
                                                null) {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      controller
                                                          .walletsInfo
                                                          ?.walletAddress ??
                                                      "",
                                                ),
                                              );
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          splashRadius: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Biểu tượng logo to tròn
                        TokenIconWidget(
                          imageUrl: controller.walletsInfo?.iconUrl,
                          width: 60,
                          height: 60,
                          hasBorder: false,
                          backgroundColor: Colors.transparent,
                          placeholder:
                              const CircularProgressIndicator(), // Tùy chọn
                          errorWidget: const Icon(
                            Icons.token,
                            size: 60,
                          ), // Tùy chọn
                          padding: const EdgeInsets.all(8),
                        ),
                        const SizedBox(height: 20),
                        // Số dư
                        FormattedNumber(
                          value: controller.walletsInfo?.totalBalance,
                          decimalDigits:
                              controller.walletsInfo?.chain == Chain.BNB ? 5 : 3,
                          style: const TextStyle(fontSize: 30),
                          suffix: controller.walletsInfo?.chain!.name,
                        ),
                        const SizedBox(height: 8),
                        FormattedNumber(
                          value: controller.walletsInfo?.balanceUSD,
                          decimalDigits: 3,
                          style: const TextStyle(fontSize: 18),
                          prefix: r"$",
                        ),

                        // Số dư bằng USD
                        // Text(
                        //   ,,
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        const SizedBox(height: 40),
                        // 2 nút Nhận và Gửi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                  WalletTokenReceivedPage.route,
                                  arguments: WalletTokenReceivedPageParam(
                                    wallet: controller.walletsInfo!,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Colors.white70,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                context.tr("Account.Wallet.Received"),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                  WalletTokenSendingPage.route,
                                  arguments: WalletTokenSendingPageParam(wallet: controller.walletsInfo!),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Colors.white70,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                context.tr('Account.Wallet.Send'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),                        
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = controller.transactions[index];                        
                        return TransactionItem(transaction: tx);
                      },
                      childCount: controller.transactions.length,
                    ),
                  ),
                ],                
              ),
            ),
          ),
        );
      },
    );
  }

}
class TransactionItem extends StatelessWidget {
  final BlockChainTransaction transaction;
  
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletTokenDetailController>();
    final isReceived = transaction.to.toLowerCase() == 
        controller.walletsInfo?.walletAddress?.toLowerCase();    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Transform.rotate(
           angle: isReceived ? -45 * (pi / 180) : 45 * (pi / 180),
            child: Icon(
            
            isReceived ? Icons.arrow_downward : Icons.arrow_upward,
            color: isReceived ? Colors.green : Colors.red,
            size: 24,
          ),
        ),                
        title: Text(
          isReceived 
              ? context.tr('Account.Wallet.Received')
              : context.tr('Account.Wallet.Send'),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isReceived ? Colors.green : Colors.red,
          ),
        ),
        subtitle: Text(          
          '${isReceived ? '${tr("Account.wallet.Transaction.From")} ' : '${tr("Account.wallet.Transaction.To")} '}${transaction.to.substring(0, 5)}...${transaction.to.substring(transaction.to.length - 4)}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isReceived ? '+' : '-'}${_formatValue(transaction.value)}',
              style: TextStyle(
                color: isReceived ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(transaction.timestamp.convertToUserTime()),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(context, transaction),
      ),
    );
  }

  String _formatValue(BigInt value) {
    final decimals = Get.find<WalletTokenDetailController>().walletsInfo?.decimals ?? 18;
    return (value / BigInt.from(10).pow(decimals)).toStringAsFixed(4);
  }

  void _showTransactionDetails(BuildContext context, BlockChainTransaction tx) {
    final controller = Get.find<WalletTokenDetailController>();
    final isReceived = tx.to.toLowerCase() == 
        controller.walletsInfo?.walletAddress?.toLowerCase();

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              isReceived 
                  ? context.tr('Account.Wallet.Received')
                  : context.tr('Account.Wallet.Send'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isReceived ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, 'Hash', tx.hash),
            _buildDetailRow(context, 'From', tx.from),
            _buildDetailRow(context, 'To', tx.to),
            _buildDetailRow(
              context, 
              'Amount', 
              '${_formatValue(tx.value)} ${controller.walletsInfo?.symbol ?? ''}'
            ),
            _buildDetailRow(
              context,
              'Date',
              DateFormat('dd/MM/yyyy HH:mm:ss').format(tx.timestamp),
            ),
            if (tx.status != null) 
              _buildDetailRow(context, 'Status', tx.status!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
               // final url = '${controller.selectedNetwork.value?.explorerUrl}/tx/${tx.hash}';
                // Mở trình duyệt xem transaction
                // Sử dụng package url_launcher
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(context.tr('Account.Wallet.ViewOnExplorer')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}