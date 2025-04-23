import 'package:dio/dio.dart';
import 'package:hkcoin/core/constants/endpoint.dart';
import 'package:hkcoin/core/dio_client.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';

class AuthDatasource {
  final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
  Future login(String username, String password) async {
    await handleRemoteRequest(() async {
      var body = {"Username": username, "Password": password};

      var response = await dioClient.call(
        DioParams(
          HttpMethod.POST,
          endpoint: Endpoints.login,
          body: body,
          needBasicAuth: true,
        ),
        contentType: "application/json",
      );

      Storage().saveToken(response["Data"]["accessToken"]);
    });
  }
}
