import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hkcoin/pages/home_page.dart';
import 'package:hkcoin/pages/login_page.dart';

class AppRoutes {
  static get routes => {
    // LoginPage.route: (context) => const LoginPage(),
  };
}

class AppGetRoutes {
  static get routes => [
    GetPage(name: LoginPage.route, page: () => LoginPage()),
    GetPage(name: HomePage.route, page: () => HomePage()),
  ];
}
