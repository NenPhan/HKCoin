import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/presentation.controllers/withdrawal_histories_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/nodatawidget_refresh_scroll.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';

class WithdrawalrequestHistoryPage extends StatefulWidget {
  const WithdrawalrequestHistoryPage({super.key});

  @override
  State<WithdrawalrequestHistoryPage> createState() => _WithdrawalrequestHistoryPageState();
}

class _WithdrawalrequestHistoryPageState extends State<WithdrawalrequestHistoryPage> {
  final controller = Get.put(WithDrawalHistoryController());
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  Future<void> _loadMoreData() async {
    if (!controller.isLoadingMore.value &&
        (controller.withDrawalHistoriesPagination?.hasNextPage ?? false)) {      
      await controller.getWalletHistoriesData(
        page: (controller.withDrawalHistoriesPagination?.pageNumber ?? 0) + 1,
        isLoadMore: true,
      );
    }
  }
  // Hàm xử lý kéo xuống làm mới
  Future<void> _refreshData() async {    
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
            Expanded(
              child: GetBuilder<WithDrawalHistoryController>(
                id: "drawal-histories-list",
                builder: (controller) {  
                  if (controller.isInitialLoading.value) {     
                    return const Center(
                      child: LoadingWidget(),
                    );                            
                  }
                    // Kiểm tra nếu không có dữ liệu
                  if (controller.withDrawalHistoriesPagination == null || 
                      controller.withDrawalHistoriesPagination!.withDrawalHistories == null ||
                      controller.withDrawalHistoriesPagination!.withDrawalHistories!.isEmpty) {
                        return NoDataWidget(
                          message: 'No data to display',
                          icon: Icons.error_outline,
                          onRefresh: _refreshData,
                        );
                  }                
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: PaginationScrollWidget(
                      scrollController: _verticalScrollController,
                      hasMoreData: controller.withDrawalHistoriesPagination?.hasNextPage ?? false,
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
                                .withDrawalHistoriesPagination!
                                .withDrawalHistories!
                                .map(
                                  (histories) => DataRow(
                                    cells: [
                                      _buildDataCell(
                                        text: histories.withdrawalPrincipal ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.amount ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.amountSwap?.toString() ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.withDrawalSwap ?? '-',
                                      ),
                                      _buildDataCell(
                                        widget: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(histories.requestStatusId),
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
                                        text: histories.reason ?? '-',
                                      ),
                                      _buildDataCell(
                                        text: histories.customerComments ?? '-',
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