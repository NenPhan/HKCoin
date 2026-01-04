import 'package:get/get.dart';
import 'package:hkcoin/presentation.controllers/home_body_controller.dart';
import 'package:hkcoin/data.models/menu/menu_action.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/presentation.pages/product_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

void handleAppAction(MenuAction action) {
  // 🌐 External
  if (action.isExternal) {
    _launchUrl(action.url!);
    return;
  }

  switch (action.module) {
    case "departments":
      Get.toNamed("/departments", arguments: {"id": action.id});
      break;

    case "ncategory":
      Get.toNamed("/news-category", arguments: {"id": action.id});
      break;

    case "product":
      final homeBodyController = Get.find<HomeBodyController>();

      final Product? product = homeBodyController.products.firstWhereOrNull(
        (e) => e.id == int.parse(action.id!),
      );

      if (product != null) {
        Get.toNamed(
          ProductDetailPage.route,
          arguments: ProductDetailPageParam(product: product),
        );
      }
      break;

    default:
      // fallback route
      Get.toNamed("/${action.module}");
  }
}

Future<void> _launchUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (_) {}
}
