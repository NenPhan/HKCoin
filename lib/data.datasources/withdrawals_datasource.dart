import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/withdrawals_exchangeprice.dart';
import 'package:hkcoin/data.models/withdrawals_histories.dart';
import 'package:hkcoin/data.models/withdrawals_investment.dart';
import 'package:hkcoin/data.models/withdrawals_profit.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class WithDrawalsDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
  Future<WithDrawalsInvestment> getWithDrawalsInvestments() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getWithDrawalsInvest,
          needAccessToken: true,
        ),
      );

      return WithDrawalsInvestment.fromJson(response["Data"]);
    });
  }
  Future<WithDrawalsProfit> getWithDrawalsProfit() async {
    return await handleRemoteRequest(() async {
      try{
        var response = await dioClient.call(
          DioParams(
            HttpMethod.GET,
            endpoint: Endpoints.getWithDrawalsProfit,
            needAccessToken: true,
          ),
        );        
        if (response == null || response["Data"] == null || response["Data"].isEmpty) {
          Get.back();
          throw Exception('No withdrawal profit data available');
        }
        return WithDrawalsProfit.fromJson(response["Data"]);
      }catch(ex){
        rethrow; // Ném lỗi để handleRemoteRequest xử lý
      }      
    });
  }
 Future<WithDrawalsProfit> submitProfit(WithDrawalsProfit form) async {
    return await handleRemoteRequest(() async {
      var body = form.toJson();
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST, endpoint: Endpoints.getWithDrawalsProfit,
          needAccessToken: true,
          body: body
        ),
        contentType: "application/json",
      );
      return WithDrawalsProfit.fromJson(response["Data"]);
    });
  } 
  Future<WithDrawalsInvestment> submitInvestment(WithDrawalsInvestment form) async {
    return await handleRemoteRequest(() async {
      var body = form.toJson();
      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST, endpoint: Endpoints.getWithDrawalsInvest,
          needAccessToken: true,
          body: body
        ),
        contentType: "application/json",
      );
      return WithDrawalsInvestment.fromJson(response["Data"]);
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
  Future<double> getExchangePackage(int packageId) async {
    return await handleRemoteRequest(() async {
       Map<String, String> queryParams = {
        "packageId": "$packageId"        
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getExchangePackage,
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return response["Data"].toDouble();
    });
  }
}
