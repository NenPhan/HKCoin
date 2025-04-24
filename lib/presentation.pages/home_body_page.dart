import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/home_body_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/coin_exchange_rate_widget.dart';
import 'package:hkcoin/widgets/home_banner_widget.dart';
import 'package:hkcoin/widgets/home_product_widget.dart';
import 'package:hkcoin/widgets/news_widget.dart';

class HomeBodyPage extends StatefulWidget {
  const HomeBodyPage({super.key});

  @override
  State<HomeBodyPage> createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends State<HomeBodyPage> {
  final HomeBodyController homeBodyController = Get.put(HomeBodyController());

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
                    icon: const Icon(Icons.shopping_bag, size: 30),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(tr("Ví Tiền Thưởng"), style: textTheme(context).bodyLarge),
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
              const HomeBannerWidget(),
              const CoinExchangeRateWidget(),
              const SizedBox(height: 10),
              GetBuilder<HomeBodyController>(
                id: "product-list",
                builder:
                    (controller) =>
                        HomeProductWidget(products: controller.products),
              ),
              const SizedBox(height: 10),
              const NewsWidget(),
              const SizedBox(height: homeBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
