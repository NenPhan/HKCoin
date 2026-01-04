import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:hkcoin/presentation.pages/home_body_page.dart';
import 'package:hkcoin/presentation.pages/profile_page.dart';
import 'package:hkcoin/presentation.pages/wallet_histories_page.dart';
import 'package:hkcoin/presentation.pages/wallet_page.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/models/bottom_bar_item_model.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/notch_bottom_bar_controller.dart';
import 'package:hkcoin/widgets/curved_labeled_navigation_bar/lib/curved_navigation_bar.dart';
import 'package:hkcoin/widgets/curved_labeled_navigation_bar/lib/curved_navigation_bar_item.dart';

const homeBottomPadding = 100.0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController(initialPage: 0);
  NotchBottomBarController bottomController = NotchBottomBarController();
  List<BottomBarItem> items = [
    const BottomBarItem(inActiveItem: Icon(Icons.qr_code, color: Colors.white)),
  ];
  int currentIndex = 0;
  void onTapNav(int index) {
    setState(() => currentIndex = index);
    controller.jumpToPage(index);
  }

  void getItems(int index) {
    items = [
      BottomBarItem(
        inActiveItem: Icon(
          Icons.home,
          color: index == 0 ? Colors.deepOrange : Colors.white,
          size: scrSize(context).width * 0.07,
        ),
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.wallet,
          color: index == 1 ? Colors.deepOrange : Colors.white,
          size: scrSize(context).width * 0.07,
        ),
      ),
      const BottomBarItem(
        inActiveItem: Icon(Icons.qr_code, color: Colors.white),
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.store,
          color: index == 3 ? Colors.deepOrange : Colors.white,
          size: scrSize(context).width * 0.07,
        ),
      ),
      BottomBarItem(
        inActiveItem: Icon(
          Icons.person,
          color: index == 4 ? Colors.deepOrange : Colors.white,
          size: scrSize(context).width * 0.07,
        ),
      ),
    ];
    bottomController.index = 2;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getItems((controller.page ?? 0).toInt());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeBodyPage(),
                WalletPage(),
                //QRScanPage(),
                WalletHistoryPage(),
                ProfilePage(),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black54,
            //           blurRadius: 10,
            //           offset: Offset(0, 20),
            //         ),
            //       ],
            //     ),
            //     child: AnimatedNotchBottomBar(
            //       notchBottomBarController: bottomController,
            //       color: Colors.grey[900]!,
            //       notchColor: Colors.deepOrange,
            //       bottomBarItems: items,
            //       kIconSize: 20,
            //       kBottomRadius: 0,
            //       showBottomRadius: false,
            //       removeMargins: true,
            //       showBlurBottomBar: false,
            //       onTap: (index) {
            //         controller.jumpToPage(index);
            //         getItems(index);
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: CurvedNavigationBar(
          index: currentIndex,
          onTap: (index) {
            onTapNav(index);
          },
          color: Colors.grey.shade900,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          animationDuration: const Duration(milliseconds: 300),

          items: [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.white : Colors.white70,
              ),
              label: context.tr("HomePage"),
              labelStyle: const TextStyle(color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.wallet,
                color: currentIndex == 1 ? Colors.white : Colors.white70,
              ),
              label: context.tr("Account.wallet.List"),
              labelStyle: const TextStyle(color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.receipt_long,
                color: currentIndex == 2 ? Colors.white : Colors.white70,
              ),
              label: context.tr("Account.History"),
              labelStyle: const TextStyle(color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.account_circle,
                color: currentIndex == 3 ? Colors.white : Colors.white70,
              ),
              label: context.tr("Common.Profile"),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
