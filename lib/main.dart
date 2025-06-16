import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/deep_link_manager.dart';
import 'package:hkcoin/core/firebase_service.dart';
import 'package:hkcoin/core/injection.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/widgets/custom_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  AppConfig.init(
    appName: "HKCoin",
    flavorName: AppFlavor.DEV,
    secondsTimeout: 30,
    host: "https://api.hakacoin.net",
    apiPath: "/odata/v1/",
    socketPath: "/hkc-hub/",
    basicAuthorization:
        'Basic NDY2OTc4YjU5YTQ1MzcxMzg1MWFjYTI5OGM0NmY2NjU6NTliZTZmMzljZTdmYWU1YzEyNTkyNmJiOGJkNWNiODU=',
  );
  await Injection.setup();
  await initializeFirebaseService();
  DeeplinkManager.initDeepLinks();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      startLocale: const Locale("en", "US"),
      path: "http://api.hakacoin.net/translations",
      fallbackLocale: const Locale('en', 'US'),
      useFallbackTranslations: true,
      assetLoader: const HttpAssetLoader(),
      child: const CustomMaterialApp(),
    ),
  );
}
