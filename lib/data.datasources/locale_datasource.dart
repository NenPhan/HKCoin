import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/language.dart';
import 'package:path_provider/path_provider.dart';

class LocaleDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<File> getTranslationFile(Locale locale) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          host: AppConfig().host,
          endpoint:
              "/resourcestring.${locale.languageCode}-${locale.countryCode}.json",
          needBasicAuth: false,
          needAccessToken: false,
        ),
      );
      final path =
          "${(await getTemporaryDirectory()).path}/${locale.languageCode}-${locale.countryCode}.json";
      final file = File(path);

      file.writeAsString(jsonEncode(response));
      return file;
    });
  }

  Future<Language> getLanguage() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getLanguage,
          needAccessToken: true,
        ),
      );

      return Language.fromJson(response["Data"]);
    });
  }
}
