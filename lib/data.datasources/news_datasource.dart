import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/news.dart';

class NewsDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<List<News>> getNews() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getNews,
          headers: {"Accept-Language": AppConfig().language},
        ),
      );

      return (response["Data"] as List).map((e) => News.fromJson(e)).toList();
    });
  }
}
