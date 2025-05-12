import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/wallet_histories_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
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
            const BaseAppBar(
              title: "Account.Transaction",
              isBackEnabled: false,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GetBuilder<WalletHistoryController>(
                      id: "wallet-histories-list",
                      builder: (controller) {
                        if (controller.isLoading.value) {
                          return const LoadingWidget();
                        }

                        if (controller
                                .walletHistoriesPagination
                                ?.walletHistories
                                ?.isEmpty ??
                            true) {
                          return Center(
                            child: Text(tr("No transactions found")),
                          );
                        }

                        return SingleChildScrollView(
                          child: Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: scrSize(context).width * 0.03,
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
                                        tr(controller.listColumn[index]),
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
                                                text: histories.amount ?? '-',
                                              ),
                                              _buildDataCell(
                                                text:
                                                    histories.reasonStr ?? '-',
                                              ),
                                              _buildDataCell(
                                                text:
                                                    histories.walletType ?? '-',
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
                                                    histories.status.toString(),
                                                    style: textTheme(
                                                      context,
                                                    ).bodySmall?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              _buildDataCell(
                                                text: histories.message ?? '-',
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
                        );
                      },
                    ),
                  ),
                  GetBuilder<WalletHistoryController>(
                    id: "wallet-histories-pagination",
                    builder: (controller) {
                      if (controller.walletHistoriesPagination != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: PaginationWidget(
                            totalPage:
                                controller
                                    .walletHistoriesPagination
                                    ?.totalPages ??
                                0,
                            onPageChange: (page) {
                              controller.getWalletHistoriesData(page: page);
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: homeBottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDataCell({String? text, Widget? widget}) {
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
