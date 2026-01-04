import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/data.models/services/store_service.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/widgets/base64_image_view.dart';

enum StoreBrandType { icon, full }

enum TextTransform { none, uppercase, lowercase }

class StoreBrandWidget extends StatelessWidget {
  final StoreBrandType type;
  final double logoSize;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextTransform textTransform;

  /// ⭐ NEW
  final bool enableTapHome;

  const StoreBrandWidget({
    super.key,
    required this.type,
    this.logoSize = 36,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.textTransform = TextTransform.none,
    this.enableTapHome = true,
  });

  @override
  Widget build(BuildContext context) {
    final storeService = Get.find<StoreService>();

    return Obx(() {
      final store = storeService.store.value;
      if (store == null) return const SizedBox();

      final logoUrl =
          type == StoreBrandType.icon
              ? store.iconLogoUrl ?? store.logoUrl
              : store.logoUrl ?? store.iconLogoUrl;

      if (logoUrl == null || logoUrl.isEmpty) {
        return const SizedBox();
      }

      final content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Base64ImageView(base64: logoUrl, width: logoSize),
          if (type == StoreBrandType.icon) ...[
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _transform(store.name ?? ''),
                  style:
                      titleStyle ??
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style:
                        subtitleStyle ??
                        TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
              ],
            ),
          ],
        ],
      );

      // 🔥 TAP TO HOME
      if (!enableTapHome) return content;

      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Get.offAllNamed(HomePage.route);
        },
        child: content,
      );
    });
  }

  String _transform(String text) {
    switch (textTransform) {
      case TextTransform.uppercase:
        return text.toUpperCase();
      case TextTransform.lowercase:
        return text.toLowerCase();
      default:
        return text;
    }
  }
}
