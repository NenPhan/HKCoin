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
                  if (controller.isLoading.value) {
                    return const LoadingWidget();
                  }

                  if (controller.walletHistoriesPagination?.walletHistories?.isEmpty ?? true) {
                    return Center(child: Text(tr("No transactions found")));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: _horizontalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalScrollController,
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: scrSize(context).width,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 0,
                                headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => Colors.grey[900]!,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      tr("Account.Transaction.Fields.Code"),
                                      style: textTheme(context).bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      tr("Account.Transaction.Fields.Amount"),
                                      style: textTheme(context).bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      tr("Account.Transaction.Fields.WalletType"),
                                      style: textTheme(context).bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      tr("Account.Transaction.Fields.Status"),
                                      style: textTheme(context).bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      tr('Common.CreatedOn'),
                                      style: textTheme(context).bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),                                  
                                ],
                                rows: controller.walletHistoriesPagination!.walletHistories!
                                    .map((histories) => DataRow(
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
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(histories.statusId),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  histories.status.toString(),
                                                  style: textTheme(context)
                                                      .bodySmall
                                                      ?.copyWith(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                dateFormat(histories.createdOnUtc!),
                                                style: textTheme(context).bodyMedium?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),                                           
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.walletHistoriesPagination != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: PaginationWidget(
                            totalPage:
                                controller.walletHistoriesPagination?.totalPages ?? 0,
                            onPageChange: (page) {
                              controller.getWalletHistoresData(page: page);
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

  Color _getStatusColor(int? status) {
    switch (status) {
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