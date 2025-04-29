import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hkcoin/core/config/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          (size ?? scrSize(context).width * 0.07) +
          scrSize(context).width * 0.05,
      child: SpinKitThreeBounce(
        size: size ?? scrSize(context).width * 0.07,
        color: Colors.white,
      ),
    );
  }
}
