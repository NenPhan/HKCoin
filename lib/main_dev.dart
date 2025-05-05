import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
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
    host: "https://sandbox.hakacoin.net",
    apiPath: "/odata/v1/",
    socketPath: "/hkc-hub/",
    basicAuthorization:
        'Basic NDY2OTc4YjU5YTQ1MzcxMzg1MWFjYTI5OGM0NmY2NjU6NTliZTZmMzljZTdmYWU1YzEyNTkyNmJiOGJkNWNiODU=',
  );
  await Injection.setup();
  runApp(
    GetBuilder<LocaleController>(
      id: "app",
      builder: (controller) {
        return EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
          startLocale: const Locale("en", "US"),
          path:
              controller.translationFile != null
                  ? controller.translationFile!.path
                  : "assets/translations",
          assetLoader:
              controller.translationFile == null
                  ? const RootBundleAssetLoader()
                  : const FileAssetLoader(),
          child: const CustomMaterialApp(),
        );
      },
    ),
  );
}
