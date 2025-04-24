import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:html/parser.dart';

class ProductDetailPageParam {
  final Product product;

  ProductDetailPageParam({required this.product});
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});
  static String route = "/product-detail";

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? product;
  List<String> description = [];
  @override
  void initState() {
    if (Get.arguments is ProductDetailPageParam) {
      product = (Get.arguments as ProductDetailPageParam).product;
      description =
          parse(
            product?.shortDescription,
          ).querySelectorAll("li").map((e) => e.innerHtml).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BaseAppBar(),
            Hero(
              tag: "product${product?.id.toString() ?? ""}",
              child: Image.network(
                product == null && !product!.image.thumbUrl.contains("http")
                    ? product?.image.thumbUrl ?? ""
                    : "https:${product?.image.thumbUrl ?? ""}",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(scrSize(context).width * 0.03),
              margin: EdgeInsets.all(scrSize(context).width * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SpacingColumn(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product?.name ?? "",
                    style: textTheme(context).titleLarge?.copyWith(
                      fontSize: scrSize(context).width * 0.08,
                    ),
                  ),
                  Text(
                    "\$${product?.price.minimumCustomerEnteredPrice.toInt()} - \$${product?.price.maximumCustomerEnteredPrice.toInt()}",
                    style: textTheme(
                      context,
                    ).bodyLarge?.copyWith(color: Colors.deepOrange),
                  ),
                  ...List.generate(description.length, (index) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(scrSize(context).width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            description[index],
                            style: textTheme(context).bodyLarge,
                          ),
                          const Spacer(),
                          const Icon(Icons.check, color: Colors.deepOrange),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(scrSize(context).width * 0.03),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(tr('Mua'), style: textTheme(context).titleSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
