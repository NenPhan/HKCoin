import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/news_detail.dart';
import 'package:hkcoin/data.models/slide.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class NewsDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());

  Future<List<News>> getNews() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getNews,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
        ),
      );

      return (response["Data"] as List).map((e) => News.fromJson(e)).toList();
    });
  }
  Future<NewsDetail> getNewsDetail(int id) async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getNewsDetail(id),          
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          }          
        ),
        contentType: "application/json",
      );
      return NewsDetail.fromJson(response["Data"]);
    });
  } 
  Future<List<Slide>> getSlides() async {
    return await handleRemoteRequest(() async {
      var response = await dioClient.call(
        DioParams(
          HttpMethod.GET,
          endpoint: Endpoints.getSlides,
          headers: {
            "Accept-Language": Get.find<LocaleController>().localeIsoCode,
          },
        ),
      );

      return (response["Data"] as List).map((e) => Slide.fromJson(e)).toList();
    });
  }
}
