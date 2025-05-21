import 'dart:developer';

import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/private_message.dart';
import 'package:hkcoin/data.repositories/message_repository.dart';

class PrivateMessageController extends GetxController {
  PrivateMessage? data;
  PrivateMessagePagination? newMessagesPagination;
  PrivateMessagePagination? readMessagesPagination;
  final RxInt privateMessageCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingReadMessages = false.obs;
  final RxBool isLoadingNewMessages = false.obs;
  @override
  void onInit() {
    gePrivateMessagesData(isRead: false);
    gePrivateMessagesData(isRead: true);
    getPrivateMessageCount();

    super.onInit();
  }

  void getPrivateMessageCount() async {
    isLoading.value = true;
    update(["message", "home-message-icon"]);
    if (Storage().getToken != null) {
      await handleEither(await MessageRepository().messageCount(), (r) {
        privateMessageCount.value = r ?? 0;
        update(["home-message-icon"]);
      });
    }
    isLoading.value = false;
    update(["message", "home-message-icon"]);
  }

  // Hàm này có thể được gọi khi user mở app hoặc vào trang tin nhắn
  Future<void> refreshMessageCount() async {
    getPrivateMessageCount();
  }

  Future gePrivateMessagesData({
    int page = 1,
    bool isLoadMore = false,
    bool isRead = false,
    int limit = 15,
  }) async {
    if (isRead) {
      isLoadingReadMessages.value = !isLoadMore;
    } else {
      isLoadingNewMessages.value = !isLoadMore;
    }
    if (!isLoadMore) {
      isInitialLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    try {
      update(["private-message-list"]);
      await handleEither(
        await MessageRepository().getPrivateMessages(
          isRead: isRead,
          page: page,
          limit: limit,
        ),
        (r) {
          if (isRead) {
            if (isLoadMore) {
              readMessagesPagination?.privateMessages?.addAll(
                r.privateMessages ?? [],
              );
              readMessagesPagination = r;
            } else {
              readMessagesPagination?.privateMessages?.assignAll(
                r.privateMessages ?? [],
              );
              readMessagesPagination = r;
            }
          } else {
            if (isLoadMore) {
              newMessagesPagination?.privateMessages?.addAll(
                r.privateMessages ?? [],
              );
              newMessagesPagination = r;
            } else {
              newMessagesPagination?.privateMessages?.assignAll(
                r.privateMessages ?? [],
              );
              newMessagesPagination = r;
            }
          }
        },
      );
      //update(["private-message-list"]);
      update([
        isRead ? "read-messages-list" : "new-messages-list",
        "private-message-pagination",
      ]);
      if (page == 1) {
        update(["private-message-pagination"]);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoadingReadMessages.value = false;
      isLoadingNewMessages.value = false;
      isInitialLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreMessages({required bool isRead}) async {
    final pagination = isRead ? readMessagesPagination : newMessagesPagination;
    if (pagination?.hasNextPage ?? false) {
      await gePrivateMessagesData(
        page: (pagination?.pageNumber ?? 0) + 1,
        isLoadMore: true,
        isRead: isRead,
      );
    }
  }

  Future<void> markAsReadAndRefresh(int messageId) async {
    try {
      final param = PrivateMessage(id: messageId, isRead: true);
      await MessageRepository().updateStatusPrivateMessage(param);

      // Cập nhật local state
      final message = newMessagesPagination?.privateMessages?.firstWhere(
        (m) => m.id == messageId,
      );

      if (message != null) {
        // Xóa khỏi danh sách chưa đọc
        newMessagesPagination?.privateMessages?.remove(message);

        // Thêm vào danh sách đã đọc
        message.isRead = true;
        readMessagesPagination?.privateMessages?.insert(0, message);
        // Cập nhật unread count
        updateUnreadCount();
        getPrivateMessageCount();
        // Trigger refresh UI
        update([
          'new-messages-list',
          'read-messages-list',
          'private-message-list',
        ]);
      }
    } catch (ex) {
      log('Error marking message as read: $ex');
      rethrow;
    }
  }

  void updateUnreadCount() {
    final count = newMessagesPagination?.privateMessages?.length ?? 0;
    // Nếu bạn có unreadCount riêng thì cập nhật ở đây
    update(['home-message-icon']); // ID riêng cho phần header
  }
}
