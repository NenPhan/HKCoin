import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/presentation.pages/product_detail_page.dart';

class HomeProductWidget extends StatefulWidget {
  const HomeProductWidget({super.key, required this.products});
  final List<Product> products;

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
            children: List.generate(widget.products.length, (index) {
              var product = widget.products[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(ProductDetailPage.route);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey[900],
                    child: Stack(
                      children: [
                        Image.network(
                          product.image.thumbUrl.contains("http")
                              ? product.image.thumbUrl
                              : "https:${product.image.thumbUrl}",
                          fit: BoxFit.cover,
                          width: 220,
                          height: 180,
                        ),
                        Container(
                          width: 220,
                          height: 180,
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
                          top: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.name,
                                style: textTheme(context).titleSmall,
                              ),
                              Text(
                                "\$${product.price.minimumCustomerEnteredPrice.toInt()} - \$${product.price.maximumCustomerEnteredPrice.toInt()}",
                                style: textTheme(context).bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
