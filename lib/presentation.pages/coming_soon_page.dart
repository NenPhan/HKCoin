import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Opacity(
          opacity: 0.5,
          child: Text("Coming soon", style: textTheme(context).titleSmall),
        ),
      ),
    );
  }
}
