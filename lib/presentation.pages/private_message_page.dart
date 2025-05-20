import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/private_message_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/private_mesage_detail_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/count_badge.dart';
import 'package:hkcoin/widgets/count_display_button.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';

class PrivateMessagePage extends StatefulWidget {
  const PrivateMessagePage({super.key});
  static String route = "/private-message";

  @override
  State<PrivateMessagePage> createState() => _PrivateMessagePageState();
}
class _PrivateMessagePageState extends State<PrivateMessagePage> 
with SingleTickerProviderStateMixin {
  
  final controller = Get.put(PrivateMessageController());
  final ScrollController _verticalScrollController = ScrollController();
   late TabController _tabController;
   final ScrollController _newMessagesScrollController = ScrollController();
  final ScrollController _readMessagesScrollController = ScrollController();
   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,vsync: this);  
    //_loadInitialData(); 
  }
 Future<void> _loadInitialData() async {
    await Future.wait([
      controller.gePrivateMessagesData(isRead: false),
      controller.gePrivateMessagesData(isRead: true),
    ]);
  }
  Future<void> _loadMoreData(int tabIndex) async {
    final isRead = tabIndex == 1;
    final pagination = isRead 
        ? controller.readMessagesPagination 
        : controller.newMessagesPagination;
        if (!controller.isLoadingMore.value && (pagination?.hasNextPage ?? false)) {
      await controller.gePrivateMessagesData(
        page: (pagination?.pageNumber ?? 0) + 1,
        isRead: isRead,
        isLoadMore: true,
      );
    }    
  }
   // Hàm xử lý kéo xuống làm mới  
  Future<void> _refreshData(bool isRead) async {    
    await controller.gePrivateMessagesData(
      page: 1,
      isRead: isRead,
      isLoadMore: false,
    );
  }
  @override
  void dispose() {
    _verticalScrollController.dispose();
    _tabController.dispose();
     _newMessagesScrollController.dispose();
    _readMessagesScrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BaseAppBar(              
              isBackEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GetBuilder<PrivateMessageController>(
                id: "private-message-list",
                builder: (controller) {
                  final unreadCount = controller.newMessagesPagination?.privateMessages?.length ?? 0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        tr("Account.PrivateMessage"),
                        style: textTheme(context).titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 5),
                      CountBadge(
                        key: UniqueKey(),                        
                        color: Colors.amber[900]??Colors.amber,
                        count: unreadCount,
                      ),                      
                    ],
                  );
                },
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: tr("Account.PrivateMessage.Tab.Inbox")),
                Tab(text: tr("Account.PrivateMessage.Tab.Read")),
              ],
              labelColor: Colors.amber[900], //Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.amber[900],//Theme.of(context).primaryColor,
            ),
            Expanded(
              child: GetBuilder<PrivateMessageController>(
                id: "private-message-list",
                builder: (controller) {                  
                  if (controller.isInitialLoading.value) {
                    return const LoadingWidget();
                  }                
                  return TabBarView(
                    controller: _tabController,
                    children: [                                         
                      _buildMessageList(
                        context: context,
                        isRead: false,
                        scrollController: _newMessagesScrollController,
                      ),
                      // Tab tin đã đọc
                      _buildMessageList(
                        context: context,
                        isRead: true,
                        scrollController: _readMessagesScrollController,
                      ),
                    ],
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
  Widget _buildMessageList({
    required BuildContext context,
    required bool isRead,
    required ScrollController scrollController,
  }) {
    return GetBuilder<PrivateMessageController>(
      id: isRead ? "read-messages-list" : "new-messages-list",
      builder: (controller) {
        final messages = isRead ? controller.readMessagesPagination?.privateMessages : controller.newMessagesPagination?.privateMessages;
        final pagination = isRead ? controller.readMessagesPagination : controller.newMessagesPagination;
        final isLoading = isRead ? controller.isLoadingReadMessages : controller.isLoadingNewMessages;

        if (isLoading.value && messages!.isEmpty) {
          return const LoadingWidget();
        }

        if (messages!.isEmpty) {
          return Center(
            child: Text(tr("No messages found")),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshData(isRead),
          child: PaginationScrollWidget(
            scrollController: scrollController,
            hasMoreData: pagination?.hasNextPage ?? false,
            onLoadMore: () => controller.loadMoreMessages(isRead: isRead),
            child: Column(
              children: [
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageCard(context, messages[index], isRead);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildMessageCard(BuildContext context, dynamic message, bool isRead) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child:InkWell(
         borderRadius: BorderRadius.circular(12),
        onTap: () {
          final wasUnread = !isRead;
          if (wasUnread) {
            controller.markAsReadAndRefresh(message.id);
          }                        
          final result = Get.toNamed(
          PrivateMesageDetailPage.route,
          arguments: message.id
        ); 
          // Hiển thị thông báo khi quay về
          if (wasUnread && result == true) {
            Get.snackbar(
              'Thông báo',
              'Tin nhắn đã được đánh dấu là đã đọc',
              backgroundColor: Colors.green[100],
              colorText: Colors.black,
            );
          }   
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.subject?.toString() ?? '-',
                style: textTheme(context).titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message.body ?? '-',
                style: textTheme(context).bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(message.createdOnUtc),
                style: textTheme(context).bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ),      
    );
  }
   String _formatDate(dynamic date) {
    if (date == null) return '-';
    try {
      // Giả sử createdOnUtc là chuỗi ISO 8601 hoặc DateTime
      final dateTime = date is String ? DateTime.parse(date) : date as DateTime;
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return '-';
    }
  }  
}
