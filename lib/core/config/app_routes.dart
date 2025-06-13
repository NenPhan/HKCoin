import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hkcoin/presentation.pages/about_us_page.dart';
import 'package:hkcoin/presentation.pages/add_address_page.dart';
import 'package:hkcoin/presentation.pages/add_phase_mnemonic_page.dart';
import 'package:hkcoin/presentation.pages/add_wallet_bycontract_page.dart';
import 'package:hkcoin/presentation.pages/add_wallet_page.dart';
import 'package:hkcoin/presentation.pages/address_list_page.dart';
import 'package:hkcoin/presentation.pages/customer_downlines_page.dart';
import 'package:hkcoin/presentation.pages/kyc_camera_page.dart';
import 'package:hkcoin/presentation.pages/cart_page.dart';
import 'package:hkcoin/presentation.pages/change_password_page.dart';
import 'package:hkcoin/presentation.pages/checkout_complete_page.dart';
import 'package:hkcoin/presentation.pages/checkout_page.dart';
import 'package:hkcoin/presentation.pages/customer_info_page.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';
import 'package:hkcoin/presentation.pages/my_orders_page.dart';
import 'package:hkcoin/presentation.pages/news_category_detail_page.dart';
import 'package:hkcoin/presentation.pages/news_details_page.dart';
import 'package:hkcoin/presentation.pages/news_page.dart';
import 'package:hkcoin/presentation.pages/private_mesage_detail_page.dart';
import 'package:hkcoin/presentation.pages/private_message_page.dart';
import 'package:hkcoin/presentation.pages/product_detail_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:hkcoin/presentation.pages/splash_page.dart';
import 'package:hkcoin/presentation.pages/update_kyc_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_backup_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_page.dart';
import 'package:hkcoin/presentation.pages/wallet_detail_privatekey_page.dart';
import 'package:hkcoin/presentation.pages/wallet_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_add_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_detail_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_page.dart';
import 'package:hkcoin/presentation.pages/wallet_token_received_page.dart';
import 'package:hkcoin/presentation.pages/withdrawal_investment_page.dart';
import 'package:hkcoin/presentation.pages/withdrawal_profit_page.dart';
import 'package:hkcoin/presentation.pages/withdrawalrequest_page.dart';

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
    GetPage(name: AboutUsPage.route, page: () => const AboutUsPage()),
    GetPage(
      name: ProductDetailPage.route,
      page: () => const ProductDetailPage(),
    ),
    GetPage(name: NewsPage.route, page: () => const NewsPage()),
    GetPage(name: NewsDetailPage.route, page: () => const NewsDetailPage()),
    GetPage(name: NewsCategoryDetailPage.route, page: () => const NewsCategoryDetailPage()),
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
    GetPage(
      name: WithDrawRequestPage.route,
      page: () => const WithDrawRequestPage(),
    ),
    GetPage(name: UpdateKycPage.route, page: () => const UpdateKycPage()),
    GetPage(name: KycCameraPage.route, page: () => const KycCameraPage()),
    GetPage(name: ProfitWithdrawalContentPage.route, page: () => const ProfitWithdrawalContentPage()),
    GetPage(name: InvestmentWithdrawalContentPage.route, page: () => const InvestmentWithdrawalContentPage()),
    GetPage(name: CustomerDownlinesPage.route, page: () => const CustomerDownlinesPage()),
    GetPage(name: PrivateMessagePage.route, page: () => const PrivateMessagePage()),
    GetPage(name: PrivateMesageDetailPage.route, page: () => const PrivateMesageDetailPage()),    
    GetPage(name: AddWalletTokenPage.route, page: () => const AddWalletTokenPage()),    
    GetPage(name: AddWalletPage.route, page: () => const AddWalletPage()),  
    GetPage(name: AddMnemonicPage.route, page: () => const AddMnemonicPage()),
    GetPage(name: WalletPage.route, page: () => const WalletPage()),
    GetPage(name: AddWalletWithContractPage.route, page: () => const AddWalletWithContractPage()),
    GetPage(name: WalletDetailPage.route, page: () => const WalletDetailPage()),
    GetPage(name: WalletDetailBackupPage.route, page: () => const WalletDetailBackupPage()),
    GetPage(name: WalletExportPrivateKeyPage.route, page: () => const WalletExportPrivateKeyPage()),
    GetPage(name: WalletTokenDetailPage.route, page: () => const WalletTokenDetailPage()),       
    GetPage(name: WalletTokenReceivedPage.route, page: () => const WalletTokenReceivedPage()),       
     
  ];
}
