import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/cache/base64_image_cache.dart';

class Base64ImageView extends StatelessWidget {
  /// 🔥 CHỈ NHẬN BASE64 STRING (đã cache)
  final String? base64;

  /// Hoặc truyền trực tiếp bytes (ưu tiên hơn)
  final Uint8List? imageBytes;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const Base64ImageView({
    super.key,
    this.base64,
    this.imageBytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Uint8List? bytes = imageBytes ?? Base64ImageCache.decode(base64);

    if (bytes == null || bytes.isEmpty) {
      return errorWidget ?? _defaultNoImage();
    }

    return Image.memory(
      bytes,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true, // ⭐ tránh nhấp nháy khi rebuild
      filterQuality: FilterQuality.low, // ⭐ nhẹ GPU
      errorBuilder: (_, __, ___) {
        return errorWidget ?? _defaultNoImage();
      },
    );
  }

  Widget _defaultNoImage() {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
