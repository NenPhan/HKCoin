import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hkcoin/presentation.pages/add_address_page.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';
import 'package:hkcoin/presentation.pages/cart_page.dart';
import 'package:hkcoin/presentation.pages/change_password_page.dart';
import 'package:hkcoin/presentation.pages/checkout_complete_page.dart';
import 'package:hkcoin/presentation.pages/checkout_page.dart';
import 'package:hkcoin/presentation.pages/customer_info_page.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';
import 'package:hkcoin/presentation.pages/my_orders_page.dart';
import 'package:hkcoin/presentation.pages/news_details_page.dart';
import 'package:hkcoin/presentation.pages/product_detail_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:hkcoin/presentation.pages/splash_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_page.dart';

class AppRoutes {
  static get routes => {
    // LoginPage.route: (context) => const LoginPage(),
  };
}

class AppGetRoutes {
  static get routes => [
    GetPage(name: SplashPage.route, page: () => const SplashPage()),
    GetPage(name: LoginPage.route, page: () => const LoginPage()),
    GetPage(name: RegisterPage.route, page: () => const RegisterPage()),
    GetPage(name: HomePage.route, page: () => const HomePage()),
    GetPage(
      name: ProductDetailPage.route,
      page: () => const ProductDetailPage(),
    ),
     GetPage(
      name: NewsDetailPage.route,
      page: () => const NewsDetailPage(),
    ),
    GetPage(name: CartPage.route, page: () => const CartPage()),
    GetPage(name: CustomerInfoPage.route, page: () => const CustomerInfoPage()),
    GetPage(
      name: ChangePasswordPage.route,
      page: () => const ChangePasswordPage(),
    ),
    GetPage(name: MyOrdersPage.route, page: () => const MyOrdersPage()),
    GetPage(name: CheckoutPage.route, page: () => const CheckoutPage()),
    GetPage(
      name: CheckoutCompletePage.route,
      page: () => const CheckoutCompletePage(),
    ),
    GetPage(name: AddressListPage.route, page: () => const AddressListPage()),
    GetPage(name: AddAddressPage.route, page: () => const AddAddressPage()),
    GetPage(name: WalletTokenPage.route, page: () => const WalletTokenPage()),
  ];
}
