import 'package:flutter/material.dart';
import 'package:hkcoin/presentation.pages/home_body_page.dart';
import 'package:hkcoin/presentation.pages/profile_page.dart';
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
  List<BottomBarItem> items = const [
    BottomBarItem(inActiveItem: Icon(Icons.home)),
    BottomBarItem(inActiveItem: Icon(Icons.wallet)),
    BottomBarItem(inActiveItem: Icon(Icons.qr_code)),
    BottomBarItem(inActiveItem: Icon(Icons.store)),
    BottomBarItem(inActiveItem: Icon(Icons.person)),
  ];
  var bottomController = NotchBottomBarController(index: 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomeBodyPage(),
                Container(color: Colors.red),
                Container(color: Colors.yellow),
                Container(color: Colors.blue),
                const ProfilePage(),
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
