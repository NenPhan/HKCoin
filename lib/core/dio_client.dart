import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/err/exception.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';

class DioClient {
  DioClient({
    required this.dio,

    ///using for test. if you use in app does not input Storage
    Storage? storage,
    required AppConfig appConfig,
  }) : super() {
    _appConfig = appConfig;
    _storage = storage;    
  }
  Storage? _storage;
  late AppConfig _appConfig;
  final Dio dio;
  Future<dynamic> call(DioParams fields, {String? contentType}) async {
    String url = '';
    if (fields.host == null) {
      url = '${AppConfig().apiUrl}${fields.endpoint}';
    } else {
      url = '${fields.host}${fields.endpoint}';
    }
    if (fields.params != null) {
      url += '?';

      if (fields.params != null) {
        fields.params!.forEach((key, value) {
          url += '$key=$value&';
        });
      }
    }
    Map<String, String> header = fields.headers ?? <String, String>{};
    String logString =
        '======>API REQUEST<===============================================================================';
    if (fields.needAccessToken) {
      //after login succes storage had token, if first init storage dont need init
      if (_storage == null && Storage.hadInited) {
        _storage = Storage();
      }
      String? token = _storage?.getToken;
      header['accessToken'] = token ?? "";
      // logString += '\nAccess Token: $token\n';
    }
    if (fields.needBasicAuth) {
      String? basicAuth = AppConfig().basicAuthorization;
      if (basicAuth != null) {
        header['Authorization'] = basicAuth;
        // logString += '\nAuthorization: $basicAuth\n';
      }
    }
    logString +=
        ('\n${fields.httpMethod}: $url ${fields.body != null ? fields.body.toString() : ""}\n==================================================================================================');
    log(logString);
    // log(header.toString());
    final rawResponse = (await _connect(
      fields.httpMethod,
      url: (fields.host ?? AppConfig().apiUrl) + fields.endpoint,
      headers: header,
      body: fields.body,
      contentType: contentType,
      queryParameters: fields.params,
    ));
    if (fields.shouldHandleResponse) {    
      try {
        return rawResponse.handleError(fields.allowedStatusCodes);
      } catch (e) {
        if (e is ServerException && rawResponse.statusCode == 401) {
          await _handleUnauthorizedError(); // Gọi logout nếu lỗi 401
        }
       // rethrow; // Ném lại lỗi để caller xử lý
      }
    } else {
      return rawResponse.data;
    }
  }

  Future<Response> _connect(
    HttpMethod method, {
    required String url,
    String? contentType,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (headers != null) {
      dio.options = BaseOptions(
        // dont use because some time in app call more one api
        // baseUrl: appConfig.apiUrl,
        headers: headers,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
        followRedirects: false,
        validateStatus: (statusCode) {
          return statusCode! <= 1000;
        },
        connectTimeout: _appConfig.secondsTimeout * 1000,
        receiveTimeout: _appConfig.secondsTimeout * 1000,
      );
    }

    switch (method) {
      case HttpMethod.DELETE:
        return dio.delete(url, data: body, queryParameters: queryParameters);
      case HttpMethod.GET:
        return dio.get(url, queryParameters: queryParameters);
      case HttpMethod.POST:
        return (dio.post(url, data: body, queryParameters: queryParameters));
      case HttpMethod.PUT:
        return (dio.put(url, data: body, queryParameters: queryParameters));
      case HttpMethod.PATCH:
        return (dio.patch(url, data: body, queryParameters: queryParameters));
    }
  }
  Future<void> _handleUnauthorizedError() async {
    // try {
    //   // Thử refresh token nếu có thể
    //   final newToken = await _refreshToken();
      
    //   if (newToken != null) {
    //     // Lưu token mới
    //     _storage?.saveToken(newToken);
    //     return;
    //   }
    // } catch (e) {
    //   log('Refresh token failed: $e');
    // }
    
    // Nếu không thể refresh token, thực hiện logout
    await _performLogout();
  }
  Future<void> _performLogout() async {
    await _storage?.deleteToken();
    // Điều hướng đến màn hình login   
    Get.offAllNamed(LoginPage.route);
  }
}

extension ResponseExtension on Response {
  // handle return data from server side to client
  Map<String, dynamic>? handleError(List<int> allowedStatusCodes) {
    String defaultErr = 'Identity.Error.DefaultError'.tr();
    if (data == null) return {};
    try {
      Map<String, dynamic> json;
      if (allowedStatusCodes.contains(statusCode)) {
        if (data == "") return {};
        if (data is! Map<String, dynamic>) {
          json = jsonDecode(data);
        } else {
          json = data;
        }
        return json;
      } else {
        String errorText = "";
        if (data is String) {
          errorText = data;
        } else if (data["message"] != null && data["message"] != "") {
          errorText = data["message"];
        } else if (data["Message"] != null && data["Message"] != "") {
          errorText = data["Message"];
          final errors = (data["Errors"] as List?)?.cast<String>() ?? [];
          if (errors.isNotEmpty) {
            errorText = '\n${errors.join('\n')}';
          }
        } else if (data["Errors"] != null) {
          if (data["Errors"] is List && (data["Errors"] as List).isNotEmpty) {
            errorText = data["Errors"][0];
          }
        } else {
          errorText = defaultErr;
        }
        throw ServerException(message: errorText);
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException(message: defaultErr);
      }
    }
  }
}

class DioParams {
  final HttpMethod httpMethod;
  final String? host;
  final String endpoint;
  final bool dynamicResponse;
  final Map<String, String>? headers;
  final Map<String, String>? params;
  final dynamic body;
  final bool needAccessToken;
  final bool needBasicAuth;
  final bool shouldHandleResponse;
  final List<int> allowedStatusCodes;

  DioParams(
    this.httpMethod, {
    this.host,
    required this.endpoint,
    this.headers,
    this.params,
    this.body,
    this.dynamicResponse = false,
    this.needAccessToken = false,
    this.needBasicAuth = true,
    this.shouldHandleResponse = true,
    this.allowedStatusCodes = const [200, 204],
  });
}
