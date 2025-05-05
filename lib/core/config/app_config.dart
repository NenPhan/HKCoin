import 'dart:developer';

class AppConfig {
  static AppConfig? _config;

  factory AppConfig() {
    if (_config == null) {
      log('AppConfig need to call init');
    }
    return _config!;
  }

  AppConfig._();

  static AppConfig init({
    required String appName,
    required AppFlavor flavorName,
    required String host,
    required String apiPath,
    String? socketPath,
    required int secondsTimeout,
    String? basicAuthorization,
  }) {
    _config ??= AppConfig._();
    _config!.appName = appName;
    _config!.flavorName = flavorName;
    _config!.host = host;
    _config!.apiPath = apiPath;
    _config!.socketPath = socketPath;
    _config!.secondsTimeout = secondsTimeout;
    _config!.basicAuthorization = basicAuthorization;
    return _config!;
  }

  late final String appName;
  late final AppFlavor flavorName;
  late final String host;
  late final String apiPath;
  late final String? socketPath;
  late final int secondsTimeout;
  late final String? basicAuthorization;

  bool get isDevelopment => flavorName == AppFlavor.DEV;
  String get apiUrl => host + apiPath;
  String get socketUrl => host + (socketPath ?? "");
}

// ignore: constant_identifier_names
enum AppFlavor { DEV, PROD }
