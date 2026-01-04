import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
/*
cách sử dụng
Html(
  data: news.fullDescription,
  extensions: [
    buildHtmlImageExtension(
      maxWidth: width * 0.94,
      borderRadius: 12,
    )
  ],
)
 */ // sửa lại path đúng với dự án của bạn

TagExtension buildHtmlImageExtension({
  required double maxWidth,
  double borderRadius = 12,
  double verticalPadding = 10,
}) {
  return TagExtension(
    tagsToExtend: {"img"},
    builder: (context) {
      final src = context.attributes["src"];
      if (src == null) return const SizedBox.shrink();

      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: CachedNetworkImage(
                      imageUrl: src,
                      placeholder:
                          (ctx, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 180,
                              width: maxWidth,
                              color: Colors.grey,
                            ),
                          ),
                      errorWidget: (ctx, url, error) => const SizedBox.shrink(),
                      // imageBuilder giữ khả năng tùy chỉnh nếu cần:
                      imageBuilder: (ctx, imageProvider) {
                        return Image(
                          image: imageProvider,
                          // để ảnh hiển thị ở kích thước tự nhiên; FittedBox sẽ scaleDown nếu quá lớn
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
