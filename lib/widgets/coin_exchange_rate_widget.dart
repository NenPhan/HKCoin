import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/gen/assets.gen.dart';

class CoinExchangeRateWidget extends StatefulWidget {
  const CoinExchangeRateWidget({super.key, required this.data});
  final String data;

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
            context.tr("Tradings.Exchange"),
            textAlign: TextAlign.center,
            style: textTheme(context).bodyLarge,
          ),
          Text(widget.data, style: textTheme(context).titleMedium),
        ],
      ),
    );
  }
}
