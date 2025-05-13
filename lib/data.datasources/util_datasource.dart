import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/country.dart';
import 'package:hkcoin/data.models/province.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class UtilDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

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

  Future<List<Country>> getCountries() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(HttpMethod.GET, endpoint: Endpoints.getCountry),
      );

      return (response["Data"] as List)
          .map((e) => Country.fromJson(e))
          .toList();
    });
  }
}
