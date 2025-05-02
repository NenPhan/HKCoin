import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/order.dart';
import 'package:hkcoin/data.repositories/product_repository.dart';

class MyOrdersController extends GetxController {
  OrderPagination? orderPagination;
  bool isLoading = true;

  @override
  void onInit() {
    getOrdersData();
    super.onInit();
  }

  Future getOrdersData({int page = 1, int limit = 10}) async {
    isLoading = true;
    update(["my-order-list"]);
    await handleEither(
      await ProductRepository().getOrders(page: page, limit: limit),
      (r) {
        orderPagination = r;
      },
    );
    isLoading = false;
    update(["my-order-list"]);
  }
}
