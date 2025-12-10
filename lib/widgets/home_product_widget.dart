import 'package:hkcoin/localization/localization_context_extension.dart';
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
        Text(
          context.tr("Products.RecentlyAddedProducts"),
          style: textTheme(context).titleSmall,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SpacingRow(
            spacing: 15,
            children: List.generate(widget.products.length, (index) {
              var product = widget.products[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    ProductDetailPage.route,
                    arguments: ProductDetailPageParam(product: product),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "product${product.id.toString()}",
                      child: Image.network(
                        product.image.thumbUrl.contains("http")
                            ? product.image.thumbUrl
                            : "https:${product.image.thumbUrl}",
                        fit: BoxFit.fitHeight,
                        height: 220,
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       product.name,
                    //       style: textTheme(
                    //         context,
                    //       ).titleSmall?.copyWith(color: Colors.deepOrange),
                    //     ),
                    //     Text(
                    //       "\$${product.price.minimumCustomerEnteredPrice.toInt()} - \$${product.price.maximumCustomerEnteredPrice.toInt()}",
                    //       style: textTheme(
                    //         context,
                    //       ).bodyLarge?.copyWith(color: Colors.deepOrange),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
