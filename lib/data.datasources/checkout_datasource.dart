import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.models/params/add_address_param.dart';
import 'package:hkcoin/data.models/province.dart';

class CheckoutDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<Cart> getCart() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getCart,
          needAccessToken: true,
          headers: {"Accept-Language": AppConfig().language},
        ),
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
          headers: {"Accept-Language": AppConfig().language},
          body: body,
        ),
        contentType: "application/json",
      );
    });
  }

  Future<List<Address>> getAddresses() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getAddresses,
          needAccessToken: true,
        ),
      );

      return (response["Data"] as List)
          .map((e) => Address.fromJson(e))
          .toList();
    });
  }

  Future<List<Province>> getProvinces() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getProvinces(),
          headers: {"Accept-Language": AppConfig().language},
        ),
      );

      return (response["value"] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    });
  }

  Future<void> addAddress(AddAddressParam param) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.addAddress,
          needAccessToken: true,
          headers: {"Accept-Language": AppConfig().language},
          body: param.toJson(),
        ),
      );
    });
  }
}
