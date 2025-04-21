import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/pages/home_body_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List icons = const [Icons.home, Icons.wallet, Icons.store, Icons.person];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: const [HomeBodyPage()]),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.deepOrange,
        onPressed: () {},
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: Colors.grey[900],
        activeIndex: 0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 10,
        rightCornerRadius: 10,

        onTap: (index) {},
        itemCount: icons.length,
        tabBuilder: (index, isActive) {
          return IconButton(
            onPressed: () {},
            icon: Icon(
              icons[index],
              color: isActive ? Colors.deepOrange : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
