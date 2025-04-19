import 'package:dio/dio.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/presentation/app_config.dart';


class Injection {
  static setup() async {
    final dioClient = DioClient(
      dio: Dio(),
      appConfig: AppConfig(),
    );

  }
}
