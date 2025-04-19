import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hkcoin/core/presentation/app_config.dart';

class EnvironmentConfig {
  final AppFlavor appFlavor;

  EnvironmentConfig({required this.appFlavor});

  static EnvironmentConfig? _instance;

  static EnvironmentConfig getInstance({flavorName}) {
    if (_instance == null) {
      _instance = EnvironmentConfig(appFlavor: flavorName);
      return _instance!;
    }
    return _instance!;
  }

  static String get fileName {
    if (_instance!.appFlavor == AppFlavor.DEV) {
      return '.env.dev';
    } else if (_instance?.appFlavor == AppFlavor.UAT) {
      return '.env.uat';
    } else if (_instance!.appFlavor == AppFlavor.PROD) {
      return '.env.prod';
    } else {
      return '';
    }
  }

  static String get env {
    return _instance?.appFlavor.name ?? '';
  }

  // get value from file .env.*
  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'API_URL not found';
  }

  static String get moengageAppId {
    return dotenv.env['MOENGAGE_APP_ID'] ?? 'MOENGAGE_APP_ID not found';
  }

  static String get talonApiUrl {
    return dotenv.env['TALON_ONE_API_URL'] ?? 'TALON_ONE_API_URL not found';
  }

  static String get talonAppId {
    return dotenv.env['TALON_ONE_APP_ID'] ?? 'TALON_ONE_APP_ID not found';
  }

  static String get talonManagementApiKey {
    return dotenv.env['TALON_ONE_MANAGEMENT_API_KEY'] ??
        'TALON_ONE_MANAGEMENT_API_KEY not found';
  }

  static String get talonIntegrationApiKey {
    return dotenv.env['TALON_ONE_INTEGRATION_API_KEY'] ??
        'TALON_ONE_INTEGRATION_API_KEY not found';
  }
}
