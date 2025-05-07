import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/expandale_container.dart';
import 'package:hkcoin/widgets/main_button.dart';

class WalletTokenPage extends StatefulWidget {
  const WalletTokenPage({super.key});
  static String route = "/wallet-token";

  @override
  State<WalletTokenPage> createState() => _WalletTokenPageState();
}

class _WalletTokenPageState extends State<WalletTokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SpacingColumn(
          spacing: 10,
          children: [
            const BaseAppBar(title: "Account.WalletToken"),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: scrSize(context).width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [MainButton(text: "Add token", onTap: () {})],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: scrSize(context).width * 0.03,
                  vertical: 0,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExpandaleContainer(
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HKC BEP20 Balance",
                            style: textTheme(
                              context,
                            ).bodyLarge?.copyWith(color: Colors.deepOrange),
                          ),
                          Text(
                            "3,590,495,110.67HKC",
                            style: textTheme(context).titleLarge,
                          ),
                        ],
                      ),
                      expandedWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://preview.redd.it/g3u6yq9awts41.jpg?auto=webp&s=6b1eb27d0f123f86eeb49528acf6c19df4c1bd96",
                            width: 200,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
