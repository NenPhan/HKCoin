import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/wallet_histories_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';

class WalletHistoryPage extends StatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  State<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  final controller = Get.put(WalletHistoryController());
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  Future<void> _loadMoreData() async {
    if (!controller.isLoadingMore.value &&
        (controller.walletHistoriesPagination?.hasNextPage ?? false)) {
      log("Load more data requested");
      await controller.getWalletHistoriesData(
        page: (controller.walletHistoriesPagination?.pageNumber ?? 0) + 1,
        isLoadMore: true,
      );
    } else {
      log("Load more not triggered: isLoadingMore=${controller.isLoadingMore.value}, hasNextPage=${controller.walletHistoriesPagination?.hasNextPage}");
    }
  }
  // Hàm xử lý kéo xuống làm mới
  Future<void> _refreshData() async {
    log("Refresh data requested");
    await controller.getWalletHistoriesData(
      page: 1,
      isLoadMore: false,
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BaseAppBar(
              title: "Account.Transaction",
              isBackEnabled: false,
            ),
            Expanded(
              child: GetBuilder<WalletHistoryController>(
                id: "wallet-histories-list",
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const LoadingWidget();
                  }

                  if (controller.walletHistoriesPagination?.walletHistories?.isEmpty ?? true) {
                    return Center(
                      child: Text(tr("No transactions found")),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: PaginationScrollWidget(
                      scrollController: _verticalScrollController,
                      hasMoreData: controller.walletHistoriesPagination?.hasNextPage ?? false,
                      onLoadMore: _loadMoreData,
                      child: Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20,
                            horizontalMargin: scrSize(context).width * 0.03,
                            headingRowColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) => Colors.grey[900]!,
                            ),
                            columns: List.generate(
                              controller.listColumn.length,
                              (index) {
                                return DataColumn(
                                  label: Text(
                                    tr(controller.listColumn[index]),
                                    style: textTheme(context).bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 3,
                                  ),
                                );
                              },
                            ),
                            rows: controller
                                .walletHistoriesPagination!
                                .walletHistories!
                                .map(
                                  (histories) => DataRow(
                                    cells: [
                                      _buildDataCell(
                                        text: histories.code?.toString() ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.amount ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.reasonStr ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.walletType ?? '-',
                                      ),
                                      _buildDataCell(
                                        widget: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(histories.statusId),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            histories.status.toString(),
                                            style: textTheme(context).bodySmall?.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      _buildDataCell(
                                        text: histories.message ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: dateFormat(histories.createdOnUtc),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  );                  
                },
              ),
            ),
            const SizedBox(height: homeBottomPadding),
          ],
        ),
      ),
    );
  }

  DataCell _buildDataCell({String? text, Widget? widget}) {
    return DataCell(
      text != null
          ? Text(
              text,
              style: textTheme(context).bodyMedium?.copyWith(color: Colors.white),
            )
          : widget ?? const SizedBox(),
    );
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 10: // Create
        return Colors.grey;
      case 20: // Pending
        return Colors.orange;
      case 30: // Approve
        return Colors.green;
      case 40: // NotApprove
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}