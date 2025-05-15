import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/customer_info.dart';
import 'package:hkcoin/data.models/withdrawals_exchangeprice.dart';
import 'package:hkcoin/data.models/withdrawals_histories.dart';
import 'package:hkcoin/data.models/withdrawals_profit.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class WithDrawalsDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<WithDrawalsProfit> getWithDrawalsProfit() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWithDrawalsProfit,
          needAccessToken: true,
        ),
      );

      return WithDrawalsProfit.fromJson(response["Data"]);
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
  Future<WithDrawalHistoriesPagination> getWithDrawalHistoriesData({int page = 1, int limit = 10}) async {
    return await handleRemoteRequest(() async {
      Map<String, String> queryParams = {
        "s": limit.toString(),
        "page": page.toString(),
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWithDrawalsHistories,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },          
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return WithDrawalHistoriesPagination.fromJson(response);
    });
  }
   Future<ExchangePrice> getExchangePrice(int tokenType) async {
    return await handleRemoteRequest(() async {
       Map<String, String> queryParams = {
        "tokenType": tokenType.toString()        
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getExchangePrice,
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return ExchangePrice.fromJson(response["Data"]);
    });
  }
}
