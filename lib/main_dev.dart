import 'package:flutter/material.dart';
import 'package:hkcoin/core/deep_link_manager.dart';
import 'package:hkcoin/core/injection.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/widgets/custom_material_app.dart';
import 'package:hkcoin/localization/localization_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  AppConfig.init(
    appName: "HKCoin",
    flavorName: AppFlavor.DEV,
    secondsTimeout: 30,
    host: "https://aps.hakacoin.net",
    apiPath: "/odata/v1/",
    socketPath: "/hkc-hub/",
    basicAuthorization:
        'Basic NDY2OTc4YjU5YTQ1MzcxMzg1MWFjYTI5OGM0NmY2NjU6NTliZTZmMzljZTdmYWU1YzEyNTkyNmJiOGJkNWNiODU=',
  );
  await Injection.setup();
  //await initializeFirebaseService();
  DeeplinkManager.initDeepLinks();
  runApp(
    const LocalizationScope(
      remotePath: "https://aps.hakacoin.net/translations",
      supportedLocales: [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
        Locale('th', 'TH'),
        Locale('lo', 'LA'),
        Locale('km', 'KH'),
      ],
      fallbackLocale: Locale('en', 'US'),
      child: CustomMaterialApp(),
    ),
  );  
}
