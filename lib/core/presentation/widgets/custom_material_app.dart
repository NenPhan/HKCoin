import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/config/app_config.dart';
import 'package:hkcoin/core/config/app_routes.dart';
import 'package:hkcoin/core/presentation/widgets/app_navigator_observer.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.pages/splash_page.dart';

class CustomMaterialApp extends StatelessWidget {
  const CustomMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ToastificationWrapper(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // ⭐ LOCALE từ LocalizationService
          locale: LocalizationService.instance.currentLocale ??
              const Locale("en", "US"),

          supportedLocales: const [
            Locale("vi", "VN"),
            Locale("en", "US"),
            Locale("th", "TH"),
            Locale("lo", "LA"),
            Locale("km", "KH"),
          ],

          // ⭐ SETUP LOCALIZATION CHUẨN CỦA FLUTTER
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          title: AppConfig().appName,

          theme: AppThemes.lightTheme(context),
          darkTheme: AppThemes.darkTheme(context),
          themeMode: ThemeMode.dark,

          // ⭐ ROUTES
          getPages: AppGetRoutes.routes,
          initialRoute: SplashPage.route,

          navigatorObservers: [
            AppNavigatorObserver(),
          ],

          defaultTransition: Transition.rightToLeft,
        ),
      ),
    );
  }
}
