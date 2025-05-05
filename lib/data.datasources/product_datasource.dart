import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/order.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class ProductDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<List<Product>> getProducts() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getProduct,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeString,
          },
        ),
        contentType: "application/json",
      );

      return (response["Data"] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    });
  }

  Future<OrderPagination> getOrders({int page = 1, int limit = 10}) async {
    return await handleRemoteRequest(() async {
      Map<String, String> queryParams = {
        "s": limit.toString(),
        "page": page.toString(),
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getOrders,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeString,
          },
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return OrderPagination.fromJson(response);
    });
  }
}
