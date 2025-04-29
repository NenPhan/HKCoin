import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/cart.dart';

class CartDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<Cart> getCart() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getCart,
          needAccessToken: true,
          needBasicAuth: true,
          headers: {"Accept-Language": AppConfig().language},
        ),
        contentType: "application/json",
      );

      return Cart.fromJson(response["Data"]);
    });
  }

  Future<void> addToCart(int productId, int price) async {
    await handleRemoteRequest(() async {
      Map<String, dynamic> body = {
        "productId": productId,
        "extraData": {
          "customerEnteredPrice": {"price": price},
        },
      };
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.addToCart,
          needAccessToken: true,
          needBasicAuth: true,
          headers: {"Accept-Language": AppConfig().language},
          body: body,
        ),
        contentType: "application/json",
      );
    });
  }

  Future<void> updateCartItem(int productId, int price) async {
    await handleRemoteRequest(() async {
      Map<String, dynamic> body = {
        "extraData": {
          "customerEnteredPrice": {"price": price},
        },
      };
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.updateCartItem(productId),
          needAccessToken: true,
          needBasicAuth: true,
          headers: {"Accept-Language": AppConfig().language},
          body: body,
        ),
        contentType: "application/json",
      );
    });
  }

  Future<void> deleteCart() async {
    await handleRemoteRequest(() async {
      Map<String, dynamic> body = {"shoppingCartType": "1", "storeId": 0};
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.deleteCart,
          needAccessToken: true,
          needBasicAuth: true,
          headers: {"Accept-Language": AppConfig().language},
          body: body,
        ),
        contentType: "application/json",
      );
    });
  }
}
