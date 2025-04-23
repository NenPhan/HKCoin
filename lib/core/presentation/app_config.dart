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
    required String apiUrl,
    required String resourceIcon,
    required String socketUrl,
    required int secondsTimeout,
    String? basicAuthorization,
  }) {
    _config ??= AppConfig._();
    _config!.appName = appName;
    _config!.flavorName = flavorName;
    _config!.apiUrl = apiUrl;
    _config!.resourceIcon = resourceIcon;
    _config!.socketUrl = socketUrl;
    _config!.secondsTimeout = secondsTimeout;
    _config!.basicAuthorization = basicAuthorization;
    return _config!;
  }

  late final String appName;
  late final AppFlavor flavorName;
  late final String apiUrl;
  late final String resourceIcon;
  late final String socketUrl;
  late final int secondsTimeout;
  late final String? basicAuthorization;

  bool get isDevelopment => flavorName == AppFlavor.DEV;
}

// ignore: constant_identifier_names
enum AppFlavor { DEV, PROD }
