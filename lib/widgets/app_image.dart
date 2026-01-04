import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppImage extends StatefulWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? aspectRatio;
  final BorderRadius borderRadius;
  final bool enableBorderRadius; // ⭐ NEW
  final bool isAvatar;
  final String? heroTag;
  final bool hideOnError;
  final String? fallbackAsset;

  /// load ngay lập tức, không dùng VisibilityDetector
  final bool lazyLoad;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.enableBorderRadius = true, // ⭐ mặc định: có bo góc
    this.isAvatar = false,
    this.heroTag,
    this.hideOnError = false,
    this.fallbackAsset,
    this.lazyLoad = true,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  bool shouldLoad = false;
  @override
  Widget build(BuildContext context) {
    // ⭐ load ngay → không dùng visibility detector
    if (!widget.lazyLoad) {
      shouldLoad = true;
      return _wrapWithClip(_buildSizedContent());
    }

    // ⭐ lazy load dùng visibility detector
    Widget image = VisibilityDetector(
      key: Key(widget.url ?? UniqueKey().toString()),
      onVisibilityChanged: (info) {
        if (!shouldLoad && info.visibleFraction > 0.05) {
          setState(() => shouldLoad = true);
        }
      },
      child: _buildSizedContent(),
    );

    return _wrapWithClip(image);
  }

  Widget _wrapWithClip(Widget child) {
    if (widget.isAvatar) return ClipOval(child: child);
    if (!widget.enableBorderRadius) {
      return child; // ⭐ không bo góc
    }
    return ClipRRect(borderRadius: widget.borderRadius, child: child);
  }

  Widget _buildSizedContent() {
    double? w = widget.width;
    double? h = widget.height;

    if (widget.aspectRatio != null && (w == null && h == null)) {
      w = double.infinity; // ⭐ use parent width
      h = MediaQuery.of(context).size.width / widget.aspectRatio!;
    }

    if (widget.aspectRatio != null && w != null && h == null) {
      h = w / widget.aspectRatio!;
    }

    h ??= 120;

    return SizedBox(width: w, height: h, child: _buildImageContent(h));
  }

  Widget _buildImageContent(double height) {
    if (!shouldLoad) return _shimmer(height);

    if (widget.url == null || widget.url!.isEmpty) {
      return widget.hideOnError ? const SizedBox.shrink() : _fallback();
    }

    return CachedNetworkImage(
      imageUrl: widget.url!,
      fit: widget.fit,
      placeholder: (_, __) => _shimmer(height),

      errorWidget: (_, __, ___) {
        if (widget.hideOnError) {
          return const SizedBox.shrink();
        }
        return _fallback();
      },
    );
  }

  Widget _shimmer(double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _fallback() {
    return Image.asset(
      widget.fallbackAsset ?? "assets/images/no_image.png",
      fit: widget.fit,
    );
  }
}
