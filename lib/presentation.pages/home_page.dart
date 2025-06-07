import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/presentation.pages/home_body_page.dart';
import 'package:hkcoin/presentation.pages/profile_page.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/presentation.pages/wallet_histories_page.dart';
import 'package:hkcoin/presentation.pages/wallet_page.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/models/bottom_bar_item_model.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/notch_bottom_bar.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/notch_bottom_bar_controller.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeBodyPage(),
                WalletPage(),
                QRScanPage(),
                WalletHistoryPage(),
                ProfilePage(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: AnimatedNotchBottomBar(
                  notchBottomBarController: bottomController,
                  color: Colors.grey[900]!,
                  notchColor: Colors.deepOrange,
                  bottomBarItems: items,
                  kIconSize: 20,
                  kBottomRadius: 0,
                  showBottomRadius: false,
                  removeMargins: true,
                  showBlurBottomBar: false,
                  onTap: (index) {
                    controller.jumpToPage(index);
                    getItems(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
