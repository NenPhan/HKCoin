import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    apiUrl: 'https://sandbox.hakacoin.net/odata/v1/',
    resourceIcon: '',
    socketUrl: '',
    basicAuthorization:
        'Basic NDY2OTc4YjU5YTQ1MzcxMzg1MWFjYTI5OGM0NmY2NjU6NTliZTZmMzljZTdmYWU1YzEyNTkyNmJiOGJkNWNiODU=',
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
