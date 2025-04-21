import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/app_config.dart';
import 'package:hkcoin/core/presentation/app_routes.dart';
import 'package:hkcoin/core/presentation/widgets/app_navigator_observer.dart';
import 'package:hkcoin/pages/login_page.dart';
import 'package:toastification/toastification.dart';

class CustomMaterialApp extends StatelessWidget {
  const CustomMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ToastificationWrapper(
        child: GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          // builder: (context, child) {
          //   child = Padding(
          //     padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          //     child: child,
          //   );
          //   return child;
          // },
          title: AppConfig().appName,
          theme: AppThemes.lightTheme(context),
          darkTheme: AppThemes.darkTheme(context),
          themeMode: ThemeMode.dark,
          getPages: AppGetRoutes.routes,
          initialRoute: LoginPage.route,
          onUnknownRoute: (RouteSettings setting) {
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: const Text("Coming soon")),
                    body: const Center(child: Text("Building in proccess")),
                  ),
            );
          },
          navigatorObservers: [AppNavigatorObserver()],
          defaultTransition: Transition.rightToLeft,
        ),
      ),
    );
  }
}
