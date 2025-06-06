import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/deep_link_manager.dart';
import 'package:hkcoin/core/firebase_service.dart';
import 'package:hkcoin/core/injection.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/presentation/widgets/custom_material_app.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
  await initializeFirebaseService();
  DeeplinkManager.initDeepLinks();
  var localeController = Get.find<LocaleController>();
  runApp(
    EasyLocalization(
      supportedLocales: localeController.listLocal.isNotEmpty ? localeController.listLocal : [const Locale('en', 'US')],
      startLocale:
          localeController.translationFile != null
              ? null
              : const Locale("en", "US"),
      path:
          localeController.translationFile != null
              ? localeController.translationFile!.path
              : "assets/translations",
      assetLoader:
          localeController.translationFile == null
              ? const RootBundleAssetLoader()
              : const FileAssetLoader(),
      child: const CustomMaterialApp(),
    ),
  );
}
