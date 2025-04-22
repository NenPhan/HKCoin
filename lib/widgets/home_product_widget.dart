import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class HomeProductWidget extends StatefulWidget {
  const HomeProductWidget({super.key});

  @override
  State<HomeProductWidget> createState() => _HomeProductWidgetState();
}

class _HomeProductWidgetState extends State<HomeProductWidget> {
  @override
  Widget build(BuildContext context) {
    return SpacingColumn(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gói đầu tư", style: textTheme(context).titleSmall),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SpacingRow(
            spacing: 15,
            children: List.generate(5, (index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.grey[900],
                  child: Stack(
                    children: [
                      Image.network(
                        "https://sandbox.hakacoin.net/media/1251/catalog/Kem%20xoa%20b%C3%B3p%20to%C3%A0n%20th%C3%A2n-01.png?size=550",
                        fit: BoxFit.cover,
                        width: 250,
                        height: 130,
                      ),
                      Container(
                        width: 250,
                        height: 130,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 50,
                        child: Column(
                          children: [
                            Text(
                              "Normal",
                              style: textTheme(context).titleSmall,
                            ),
                            Text(
                              "\$100 - \$499",
                              style: textTheme(context).bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
