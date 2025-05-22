import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/customer_downlines.dart';
import 'package:hkcoin/data.models/params/change_password_param.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.models/wallet_histories.dart';
import 'package:hkcoin/data.models/wallet_info.dart';
import 'package:hkcoin/data.models/wallet_token.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class CustomerDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future login(String username, String password) async {
    await handleRemoteRequest(() async {
      var body = {"Username": username, "Password": password};

      var response = await dioClient.call(
        DioParams(HttpMethod.POST, endpoint: Endpoints.login, body: body),
        contentType: "application/json",
      );

      Storage().saveToken(response["Data"]["accessToken"]);
    });
  }

  Future<void> updateDeviceToken(String? token) async {
    await handleRemoteRequest(() async {
      var body = {
        "deviceToken": token,
        "deviceType": Platform.isIOS ? "1" : "0",
      };
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.deviceToken,
          body: body,
          needAccessToken: true,
        ),
        contentType: "application/json",
      );
    });
  }

  Future register(RegisterForm form) async {
    await handleRemoteRequest(() async {
      var body = form.toJson();

      await dioClient.call(
        DioParams(HttpMethod.POST, endpoint: Endpoints.register, body: body),
        contentType: "application/json",
      );
    });
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.customerInfo,
          needAccessToken: true,
        ),
      );

      return CustomerInfo.fromJson(response["Data"]);
    });
  }

  Future<CustomerInfo> updateCustomerInfo(CustomerInfo customerInfo) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.PATCH,
          endpoint: Endpoints.customerInfo,
          needAccessToken: true,
          body: customerInfo.toUpdateJson(),
        ),
        contentType: "application/json",
      );
      return CustomerInfo.fromJson(response["Data"]);
    });
  }

  Future changePassword(ChangePasswordParam param) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.changePassword,
          needAccessToken: true,
          body: param.toJson(),
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
        ),
        contentType: "application/json",
      );
    });
  }

  Future<WalletInfo> getWalletInfo() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWalletInfo,
          needAccessToken: true,
        ),
      );

      return WalletInfo.fromJson(response["Data"]);
    });
  }

  Future<List<WalletToken>> getWalletTokens() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWalletBalances,
          needAccessToken: true,
        ),
      );
      final tokens = (response["Data"]?["Tokens"] as List?) ?? [];
      return tokens.map((e) => WalletToken.fromJson(e)).toList();
    });
  }

  Future<WalletHistoriesPagination> getWalletHistoresData({
    int page = 1,
    int limit = 10,
  }) async {
    return await handleRemoteRequest(() async {
      Map<String, String> queryParams = {
        "s": limit.toString(),
        "page": page.toString(),
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWalletHistories,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return WalletHistoriesPagination.fromJson(response);
    });
  }

  Future<CustomerDownlines> getCustomerDownlinesData({
    int parentId = 0,
    int page = 1,
    int limit = 10,
  }) async {
    return await handleRemoteRequest(() async {
      Map<String, String> queryParams = {
        "parentId": parentId.toString(),
        "s": limit.toString(),
        "page": page.toString(),
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getDownlines,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return CustomerDownlines.fromJson(response);
    });
  }

  Future logout() async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.logout,
          needAccessToken: true,
        ),
      );
    });
  }
}
