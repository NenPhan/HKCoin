import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/private_message.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class MessageDatasource {
   final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
   
  Future<int?> messageCount() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.messageCount,
          needAccessToken: true,              
        ),
        contentType: "application/json",
      );
      if (response["Data"]["Count"] is int) {
        return response["Data"]["Count"];
      } else {
        return null;
      }
    });
  }
  Future<PrivateMessagePagination> getPrivateMessagesData({bool isRead = false, int page = 1, int limit = 10}) async {
    return await handleRemoteRequest(() async {
      Map<String, String> queryParams = {
        "readed":"$isRead",
        "s": limit.toString(),
        "page": page.toString(),
      };
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getPrivateMessages,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          params: queryParams,
          needAccessToken: true,
        ),
      );

      return PrivateMessagePagination.fromJson(response);
    });
  }
   Future<PrivateMessage> getPrivateMessageDetail(int id) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getPrivateMessagesDetail(id),          
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
          needAccessToken: true, 
        ),
        contentType: "application/json",
      );
      return PrivateMessage.fromJson(response["Data"]);
    });
  } 
  Future updateStatusPrivateMessage(PrivateMessage param) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.updateStatusPrivateMessage,
          needAccessToken: true,
          body: param.toJson(),
        ),
        contentType: "application/json",
      );
    });
  }
}