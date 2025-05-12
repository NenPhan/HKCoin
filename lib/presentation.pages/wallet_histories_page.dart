import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/wallet_histories_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/pagination_widget.dart';

class WalletHistoryPage extends StatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  State<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  final controller = Get.put(WalletHistoryController());
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu ngay khi khởi tạo trang
    controller.getWalletHistoriesData(page: 1);
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
            const BaseAppBar(title: "Account.Transaction"),
            Expanded(
              child: GetBuilder<WalletHistoryController>(
                id: "wallet-histories-list",
                builder: (controller) {
                  // Log trạng thái để debug
                  debugPrint('isLoading: ${controller.isLoading.value}');
                  debugPrint('walletHistoriesPagination: ${controller.walletHistoriesPagination}');

                  if (controller.isLoading.value) {
                    return const Center(child: LoadingWidget());
                  }

                  if (controller.walletHistoriesPagination == null ||
                      controller.walletHistoriesPagination!.walletHistories == null ||
                      controller.walletHistoriesPagination!.walletHistories!.isEmpty) {
                    return Center(child: Text(tr("No transactions found")));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            child: Scrollbar(
                              controller: _horizontalScrollController,
                              thumbVisibility: true,
                              notificationPredicate: (notification) => notification.depth == 1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: DataTable(
                                    columnSpacing: 20,
                                    horizontalMargin: 0,
                                    headingRowHeight: 50,
                                    dataRowMinHeight: 40,
                                    dataRowMaxHeight: 60,
                                    headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) => Colors.grey[900]!,
                                    ),
                                    dataRowColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) => Colors.grey[850]!,
                                    ),
                                    border: TableBorder.all(
                                      color: Colors.grey[700]!,
                                      width: 1,
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: _TableHeaderText(tr("Account.Transaction.Fields.Code")),
                                      ),
                                      DataColumn(
                                        label: _TableHeaderText(tr("Account.Transaction.Fields.Amount")),
                                      ),
                                      DataColumn(
                                        label: _TableHeaderText(tr("Account.Transaction.Fields.WalletType")),
                                      ),
                                      DataColumn(
                                        label: _TableHeaderText(tr("Account.Transaction.Fields.Status")),
                                      ),
                                      DataColumn(
                                        label: _TableHeaderText(tr('Common.CreatedOn')),
                                      ),
                                    ],
                                    rows: controller.walletHistoriesPagination!.walletHistories!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final histories = entry.value;
                                      return DataRow(
                                        color: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) =>
                                              index % 2 == 0 ? Colors.grey[850]! : Colors.grey[800]!,
                                        ),
                                        cells: [
                                          DataCell(
                                            Text(
                                              histories.code?.toString() ?? '-',
                                              style: textTheme(context).bodyMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              histories.amount ?? '-',
                                              style: textTheme(context).bodyMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              histories.reasonStr ?? '-',
                                              style: textTheme(context).bodyMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(histories.statusId),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                histories.status?.toString() ?? '-',
                                                style: textTheme(context).bodySmall?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              histories.createdOnUtc != null
                                                  ? dateFormat(histories.createdOnUtc!)
                                                  : '-',
                                              style: textTheme(context).bodyMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.walletHistoriesPagination != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: PaginationWidget(
                            totalPage: controller.walletHistoriesPagination?.totalPages ?? 0,
                            onPageChange: (page) {
                              controller.getWalletHistoriesData(page: page);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int? statusId) {
    switch (statusId) {
      case 30:
        return Colors.green;
      case 40:
        return Colors.orange;
      case 50:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _TableHeaderText extends StatelessWidget {
  final String text;

  const _TableHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme(context).bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}