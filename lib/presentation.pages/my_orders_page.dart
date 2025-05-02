import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.controllers/my_orders_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/pagination_widget.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});
  static String route = "/my-orders";

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final controller = Get.put(MyOrdersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BaseAppBar(title: tr("Gói đầu tư của tôi")),
            Expanded(
              child: GetBuilder<MyOrdersController>(
                id: "my-order-list",
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (controller.isLoading)
                          SizedBox(
                            height: scrSize(context).height,
                            child: const LoadingWidget(),
                          ),
                        if (controller.isLoading == false)
                          ...List.generate(
                            controller.orderPagination?.orders?.length ?? 0,
                            (index) {
                              var order =
                                  controller.orderPagination!.orders![index];
                              return Container(
                                padding: EdgeInsets.all(
                                  scrSize(context).width * 0.03,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: scrSize(context).width * 0.03,
                                  vertical: scrSize(context).width * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "#${order.productName ?? ""}",
                                      style: textTheme(context).titleMedium
                                          ?.copyWith(color: Colors.deepOrange),
                                    ),
                                    Text(
                                      order.orderNumber ?? "",
                                      style: textTheme(context).titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      order.orderStatus.toString(),
                                      style: textTheme(context).bodyLarge
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      order.createdOn == null
                                          ? ""
                                          : DateFormat(
                                            'dd/MM/yyyy HH:mm',
                                          ).format(order.createdOn!),
                                      style: textTheme(context).bodyMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: EdgeInsets.all(
                                        scrSize(context).width * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(order.orderTotal ?? ""),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        if (controller.orderPagination != null)
                          PaginationWidget(
                            totalPage:
                                controller.orderPagination?.totalPages ?? 0,
                            onPageChange: (page) {
                              controller.getOrdersData(page: page);
                            },
                          ),
                      ],
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
}
