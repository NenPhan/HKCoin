import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/data.models/order_total.dart';
import 'package:hkcoin/data.models/params/add_address_param.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class CheckoutDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<Cart> getCart() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getCart,
          needAccessToken: true,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
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
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
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
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
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
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
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
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
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
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          body: param.toJson(),
        ),
        contentType: "application/json",
      );
    });
  }

  Future<void> selectAddress(int? id) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.selectAddress,
          needAccessToken: true,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          body: {"AddressId": id},
        ),
        contentType: "application/json",
      );
    });
  }

  Future<CheckoutData> getCheckoutData() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.checkout,
          needAccessToken: true,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
        ),
      );

      return CheckoutData.fromJson(response["Data"]);
    });
  }

  Future<void> selectPaymentMethod(String? methodName) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.selectPaymentMethod,
          needAccessToken: true,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          body: {"paymentMethodSystemName": methodName},
        ),
        contentType: "application/json",
      );
    });
  }

  Future<int?> checkout(int? addressId, String? paymentMethodName) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.checkout,
          needAccessToken: true,
          headers: {
            "Accept-Encoding": Get.find<LocaleController>().localeIsoCode,
          },
          body: {
            "AddressId": addressId,
            "PaymentMethodName": paymentMethodName,
            "CustomerComment": "",
          },
        ),
        contentType: "application/json",
      );
      if (response["Data"]["Id"] is int) {
        return response["Data"]["Id"];
      } else {
        return null;
      }
    });
  }

  Future<CheckoutComplateData> checkoutComplete(int id) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.checkoutComplete,
          needAccessToken: true,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          body: {"Id": id},
        ),
        contentType: "application/json",
      );
      return CheckoutComplateData.fromJson(response["Data"]);
    });
  }

  Future<OrderTotal> getOrderTotal() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.orderTotal,
          needAccessToken: true,
        ),
      );

      return OrderTotal.fromJson(response["Data"]);
    });
  }
}
