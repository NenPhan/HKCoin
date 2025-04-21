import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/gen/assets.gen.dart';

class CoinExchangeRateWidget extends StatefulWidget {
  const CoinExchangeRateWidget({super.key});

  @override
  State<CoinExchangeRateWidget> createState() => _CoinExchangeRateWidgetState();
}

class _CoinExchangeRateWidgetState extends State<CoinExchangeRateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: scrSize(context).width * 0.1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Assets.icons.hkcLogoIcon.image(width: 50),
          Text(
            "HKC/USD\nToday",
            textAlign: TextAlign.center,
            style: textTheme(context).bodyLarge,
          ),
          Text(
            "\$${oCcy().format(0.9)}",
            style: textTheme(context).titleMedium,
          ),
        ],
      ),
    );
  }
}
