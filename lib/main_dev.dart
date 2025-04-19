import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/injection.dart';
import 'package:hkcoin/core/presentation/app_config.dart';
import 'package:hkcoin/core/presentation/widgets/custom_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppConfig.init(
    appName: "Marketplace",
    flavorName: AppFlavor.DEV,
    secondsTimeout: 30,
  );
  Injection.setup();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      startLocale: const Locale('vi', 'VN'),
      path: 'assets/translations',
      child: const CustomMaterialApp(),
    ),
  );
}
