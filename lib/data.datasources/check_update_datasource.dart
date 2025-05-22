import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/check_update.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class CheckUpdateDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());  
  Future<CheckUpdateResult> checkVersion({required String currentVersion,required String platform}) async {
    return await handleRemoteRequest(() async {
       Map<String, String> queryParams = {
        "currentVersion": currentVersion,
        "platform": platform,
      };
        var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.checkVersion,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          params: queryParams,
        ),
      );
       if(response == null || response["Data"] != null){
          return CheckUpdateResult.fromJson(response["Data"]);
       }        
        else{
          return CheckUpdateResult(updateAvailable: false);
        } 
    });
  }

}