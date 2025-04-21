import 'dart:developer';

import 'package:hkcoin/environment_config.dart';

class AppConfig {
  static AppConfig? _config;

  factory AppConfig() {
    if (_config == null) {
      log('AppConfig not init yet');
    }
    return _config!;
  }

  AppConfig._();

  static Future<AppConfig> init({
    required String appName,
    required AppFlavor flavorName,
    required int secondsTimeout,
  }) async {
    _config ??= AppConfig._();
    _config!.appName = appName;
    _config!.flavorName = flavorName;
    _config!.secondsTimeout = secondsTimeout;
    EnvironmentConfig.getInstance(flavorName: flavorName);
    // await dotenv.load(fileName: EnvironmentConfig.fileName);
    return _config!;
  }

  late final String appName;
  late final AppFlavor flavorName;
  late final int secondsTimeout;

  bool get isDevelopment => flavorName == AppFlavor.DEV;
}

// ignore: constant_identifier_names
enum AppFlavor { DEV, UAT, PROD }
