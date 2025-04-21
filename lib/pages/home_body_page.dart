import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/widgets/coin_exchange_rate_widget.dart';

class HomeBodyPage extends StatefulWidget {
  const HomeBodyPage({super.key});

  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<HomeBodyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(scrSize(context).width * 0.03),
          child: SpacingColumn(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Assets.images.hkcLogo.image(height: 50),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Ví Tiền Thưởng".tr(), style: textTheme(context).bodyLarge),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "${oCcy.format(1800.056)} HKC",
                  style: textTheme(context).titleLarge?.copyWith(
                    fontSize: scrSize(context).width * 0.08,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "~ \$${oCcy.format(1800.056)}",
                  style: textTheme(context).titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              SpacingRow(
                spacing: scrSize(context).width * 0.1,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 120,
                        child: Image.network(
                          "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 120,
                        child: Image.network(
                          "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const CoinExchangeRateWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
