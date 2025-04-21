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
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          scrSize(context).width * 0.03,
          0,
        ),
        child: SingleChildScrollView(
          child: SpacingColumn(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: "main-logo",
                    child: Assets.images.hkcLogo.image(height: 50),
                  ),
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
                  "${oCcy().format(1000.005)} HKC",
                  style: textTheme(context).titleLarge?.copyWith(
                    fontSize: scrSize(context).width * 0.08,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "≈ \$${oCcy(format: "#,##0").format(100000)}",
                  style: textTheme(context).titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              SpacingRow(
                spacing: 15,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 100,
                        child: Image.network(
                          "",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[900],
                                child: Center(
                                  child: Text(
                                    "Banner",
                                    style: textTheme(context).bodyLarge,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 100,
                        child: Image.network(
                          "",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[900],
                                child: Center(
                                  child: Text(
                                    "Banner",
                                    style: textTheme(context).bodyLarge,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const CoinExchangeRateWidget(),
              SpacingRow(
                spacing: scrSize(context).width * 0.1,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[900],
                        child: SpacingColumn(
                          children: [
                            Image.network(
                              "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.03,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Monad Seeks \$200 Million Funding from Paradigm",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: textTheme(context).bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "The layer-1 blockchain project Monad is in discussions with several investment funds, including Paradigm, regarding conducting a fundraising round with a value of up to \$200 million.",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: textTheme(context).bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[900],
                        child: SpacingColumn(
                          children: [
                            Image.network(
                              "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.03,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Monad Seeks \$200 Million Funding from Paradigm",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: textTheme(context).bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "The layer-1 blockchain project Monad is in discussions with several investment funds, including Paradigm, regarding conducting a fundraising round with a value of up to \$200 million.",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: textTheme(context).bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SpacingRow(
                spacing: scrSize(context).width * 0.1,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[900],
                        child: SpacingColumn(
                          children: [
                            Image.network(
                              "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.03,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Monad Seeks \$200 Million Funding from Paradigm",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: textTheme(context).bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "The layer-1 blockchain project Monad is in discussions with several investment funds, including Paradigm, regarding conducting a fundraising round with a value of up to \$200 million.",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: textTheme(context).bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[900],
                        child: SpacingColumn(
                          children: [
                            Image.network(
                              "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                scrSize(context).width * 0.03,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Monad Seeks \$200 Million Funding from Paradigm",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: textTheme(context).bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "The layer-1 blockchain project Monad is in discussions with several investment funds, including Paradigm, regarding conducting a fundraising round with a value of up to \$200 million.",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: textTheme(context).bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
