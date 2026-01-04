// ignore_for_file: unused_element

import 'dart:developer';

import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/wallet_histories_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';
import 'package:hkcoin/presentation.controllers/wallet_controller.dart';

class WalletHistoryPage extends StatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  State<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  final controller = Get.put(WalletHistoryController());
  final walletController = Get.put(WalletController());

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  Future<void> _loadMoreData() async {
    if (!controller.isLoadingMore.value &&
        (controller.walletHistoriesPagination?.hasNextPage ?? false)) {
      await controller.getWalletHistoriesData(
        page: (controller.walletHistoriesPagination?.pageNumber ?? 0) + 1,
        isLoadMore: true,
      );
    } else {
      log(
        "Load more not triggered: isLoadingMore=${controller.isLoadingMore.value}, hasNextPage=${controller.walletHistoriesPagination?.hasNextPage}",
      );
    }
  }

  // Hàm xử lý kéo xuống làm mới
  Future<void> _refreshData() async {
    log("Refresh data requested");
    await controller.getWalletHistoriesData(page: 1, isLoadMore: false);
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
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    BaseAppBar(
                      title: "Account.Transaction",
                      isBackEnabled: false,
                      actionWidget: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Xử lý tìm kiếm
                        },
                      ),
                    ),
                    Obx(() {
                      if (walletController.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (walletController.walletInfo == null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            context.tr("No wallet information available"),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SpacingColumn(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpacingColumn(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    context.tr("Account.Report.Walletmain"),
                                    style: textTheme(context).bodyLarge,
                                  ),
                                  Text(
                                    walletController.walletInfo!.walletMain,
                                    style: textTheme(context).titleLarge,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpacingColumn(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    context.tr("Account.Report.Shopping"),
                                    style: textTheme(context).bodyLarge,
                                  ),
                                  Text(
                                    walletController.walletInfo!.walletShopping,
                                    style: textTheme(context).titleLarge,
                                  ),
                                  Text(
                                    walletController
                                        .walletInfo!
                                        .profitsShopping,
                                    style: textTheme(context).bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpacingColumn(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    context.tr("Account.Report.Coupon"),
                                    style: textTheme(context).bodyLarge,
                                  ),
                                  Text(
                                    walletController.walletInfo!.walletCoupon,
                                    style: textTheme(context).titleLarge,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpacingColumn(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    context.tr("Account.Report.OrderTotal"),
                                    style: textTheme(context).bodyLarge,
                                  ),
                                  Text(
                                    walletController.walletInfo!.orderCount,
                                    style: textTheme(context).titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<WalletHistoryController>(
                        id: "wallet-histories-list",
                        builder: (controller) {
                          if (controller.isInitialLoading.value) {
                            return const LoadingWidget();
                          }
                          if (controller
                                  .walletHistoriesPagination
                                  ?.walletHistories
                                  ?.isEmpty ??
                              true) {
                            return Center(
                              child: Text(context.tr("No transactions found")),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: _refreshData,
                            child: PaginationScrollWidget(
                              scrollController: _verticalScrollController,
                              hasMoreData:
                                  controller
                                      .walletHistoriesPagination
                                      ?.hasNextPage ??
                                  false,
                              onLoadMore: _loadMoreData,
                              child: Scrollbar(
                                controller: _horizontalScrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _horizontalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 20,
                                    horizontalMargin:
                                        scrSize(context).width * 0.03,
                                    headingRowColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                          (Set<WidgetState> states) =>
                                              Colors.grey[900]!,
                                        ),
                                    columns: List.generate(
                                      controller.listColumn.length,
                                      (index) {
                                        return DataColumn(
                                          label: Text(
                                            context.tr(
                                              controller.listColumn[index],
                                            ),
                                            style: textTheme(
                                              context,
                                            ).bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                          ),
                                        );
                                      },
                                    ),
                                    rows:
                                        controller
                                            .walletHistoriesPagination!
                                            .walletHistories!
                                            .map(
                                              (histories) => DataRow(
                                                cells: [
                                                  _buildDataCell(
                                                    text:
                                                        histories.code
                                                            ?.toString() ??
                                                        '-',
                                                  ),
                                                  _buildDataCell(
                                                    text:
                                                        histories.amount ?? '-',
                                                  ),
                                                  _buildDataCell(
                                                    text:
                                                        histories.reasonStr ??
                                                        '-',
                                                  ),
                                                  _buildDataCell(
                                                    text:
                                                        histories.walletType ??
                                                        '-',
                                                  ),
                                                  _buildDataCell(
                                                    widget: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: _getStatusColor(
                                                          histories.statusId,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        histories.status
                                                            .toString(),
                                                        style: textTheme(
                                                          context,
                                                        ).bodySmall?.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  _buildDataCell(
                                                    text:
                                                        histories.message ??
                                                        '-',
                                                  ),
                                                  _buildDataCell(
                                                    text: dateFormat(
                                                      histories.createdOnUtc,
                                                    ),
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
            ],
          ),
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

  void showHalfScreenPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép sheet chiếm phần lớn màn hình
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
              0.5, // Chiếm 50% chiều cao màn hình
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Popup một nửa màn hình',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Thêm nội dung của bạn ở đây
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWalletPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr("Wallet Information")),
            content: Text(context.tr("Wallet details would be shown here")),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr("Close")),
              ),
            ],
          ),
    );
  }
}
