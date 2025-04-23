import 'package:flutter/material.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/splash_controller.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static String route = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SplashController().checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SpacingColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Center(
            child: Hero(
              tag: "main-logo",
              child: Assets.images.hkcLogo.image(
                width: 300,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          const LoadingWidget(),
        ],
      ),
    );
  }
}
