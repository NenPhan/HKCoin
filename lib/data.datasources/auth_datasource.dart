import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/params/change_password_param.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/register_form.dart';
import 'package:hkcoin/data.models/wallet_info.dart';

class AuthDatasource {
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
          headers: {"Accept-Language": AppConfig().language},
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
