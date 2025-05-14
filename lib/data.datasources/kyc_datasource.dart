import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as gx;
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/kyc_info.dart';
import 'package:hkcoin/data.models/kyc_status.dart';
import 'package:hkcoin/data.models/params/update_kyc_param.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class KycDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<KycInfo> getKycInfo() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.kycInfo,
          needAccessToken: true,
          headers: {
            "Accept-Language": gx.Get.find<LocaleController>().localeIsoCode,
          },
        ),
        contentType: "application/json",
      );

      return KycInfo.fromJson(response["Data"]);
    });
  }

  Future<KycStatus> getKycStatus() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.kycStatus,
          needAccessToken: true,
          headers: {
            "Accept-Language": gx.Get.find<LocaleController>().localeIsoCode,
          },
        ),
      );

      return KycStatus.fromJson(response["Data"]);
    });
  }

  Future updateKycInfo(UpdateKycParam param) async {
    await handleRemoteRequest(() async {
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.kycInfo,
          needAccessToken: true,
          body: param.toJson(),
        ),
        contentType: "application/json",
      );
    });
  }

  Future kycValidate(String name, File file) async {
    await handleRemoteRequest(() async {
      var formData = FormData.fromMap({
        name: await MultipartFile.fromFile(file.path, filename: '$name.png'),
      });
      await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.kycValidate,
          needAccessToken: true,
          body: formData,
          params: {"step": "${name.replaceAll("Id", "")}Upload"},
        ),
      );
    });
  }
}
