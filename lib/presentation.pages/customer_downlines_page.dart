import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/presentation.controllers/customer_downlines_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/nodatawidget_refresh_scroll.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';

class CustomerDownlinesPage extends StatefulWidget {
  const CustomerDownlinesPage({super.key});
  static String route = "/customer-downlines";
  @override
  State<CustomerDownlinesPage> createState() => _CustomerDownlinesPageState();
}

class _CustomerDownlinesPageState extends State<CustomerDownlinesPage>
    with SingleTickerProviderStateMixin {
  final CustomerDownlinesController controller = Get.put(
    CustomerDownlinesController(),
  );
  final ScrollController _verticalScrollController = ScrollController();
  Future<void> _loadMoreData() async {
    if (!controller.isLoadingMore.value &&
        (controller.customerDownlines?.hasNextPage ?? false)) {
      await controller.getCustomerDownlinesData(
        page: (controller.customerDownlines?.pageNumber ?? 0) + 1,
        isLoadMore: true,
      );
    }
  }

  // Hàm xử lý kéo xuống làm mới
  Future<void> _refreshData() async {
    await controller.getCustomerDownlinesData(page: 1, isLoadMore: false);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BaseAppBar(title: "Account.Downlines.Customers"),
            Expanded(
              child: GetBuilder<CustomerDownlinesController>(
                id: "customer-downlines-page",
                builder: (controller) {
                  if (controller.isInitialLoading.value) {
                    return const Center(child: LoadingWidget());
                  }
                  // Kiểm tra nếu không có dữ liệu
                  if (controller.customerDownlines == null ||
                      controller.customerDownlines!.customerDownLineInfo ==
                          null ||
                      controller
                          .customerDownlines!
                          .customerDownLineInfo!
                          .isEmpty) {
                    return NoDataWidget(
                      message: 'No data to display',
                      icon: Icons.error_outline,
                      onRefresh: _refreshData,
                    );
                    //return _buildNoDataWidget(); // Widget hiển thị khi không có dữ liệu
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: PaginationScrollWidget(
                      scrollController: _verticalScrollController,
                      hasMoreData:
                          controller.customerDownlines?.hasNextPage ?? false,
                      onLoadMore: _loadMoreData,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            controller.customerDownlines!.customerDownLineInfo!
                                .map(
                                  (customer) => _buildAssetItemCircle(
                                    title:
                                        customer.fullName ??
                                        customer.email ??
                                        "N/A",
                                    phone: customer.phone ?? "",
                                    icon: Icons.account_circle_rounded,
                                    onSubmitted: () {
                                      controller.getCustomerDownlinesData(
                                        parentId: customer.id ?? 0,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
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

  Widget _buildAssetItemCircle({
    required String title,
    String? phone,
    required IconData icon,
    bool isSelected = false,
    VoidCallback? onSubmitted,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Avatar with gradient (non-clickable)
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    isSelected ? Colors.green.shade300 : Colors.blue.shade300,
                    isSelected ? Colors.green.shade700 : Colors.blue.shade700,
                  ],
                ),
              ),
              child: Icon(icon, size: 25, color: Colors.white),
            ),
            const SizedBox(width: 10),

            // Text content (non-clickable)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(phone!, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),

            // Clickable trailing icon only
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    isSelected
                        ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                          key: ValueKey('check'),
                        )
                        : const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          key: ValueKey('chevron'),
                        ),
              ),
              onPressed: onSubmitted,
              splashRadius: 20, // Custom splash radius
              padding: EdgeInsets.zero, // Remove default padding
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No customers found',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: _refreshData, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
