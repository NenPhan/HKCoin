import 'package:flutter/material.dart';
import 'package:hkcoin/pages/home_body_page.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/models/bottom_bar_item_model.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/notch_bottom_bar.dart';
import 'package:hkcoin/widgets/animated_notch_bottom_bar-main/lib/src/notch_bottom_bar_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            PageView(children: const [HomeBodyPage()]),
            Align(
              alignment: Alignment.bottomCenter,
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
                onTap: (index) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
