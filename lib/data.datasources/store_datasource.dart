import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/store.dart';

class StoreDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<Store> getCurrentStore() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getCurrentStore,          
        ),
      );

      return Store.fromJson(response["Data"]);
    });
  }
}
