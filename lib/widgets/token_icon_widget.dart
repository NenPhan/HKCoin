import 'package:flutter/material.dart';

class TokenIconWidget extends StatelessWidget {
  final String? imageUrl; // URL hình ảnh token
  final ImageProvider? imageProvider; // ImageProvider cho tài nguyên cục bộ
  final double width; // Chiều rộng
  final double height; // Chiều cao
  final Color backgroundColor; // Màu nền
  final bool hasBorder; // Có viền hay không
  final Color borderColor; // Màu viền
  final double borderWidth; // Độ dày viền
  final Color? iconColor; // Màu icon (áp dụng ColorFilter)
  final Widget? placeholder; // Widget hiển thị khi đang tải
  final Widget? errorWidget; // Widget hiển thị khi lỗi
  final EdgeInsetsGeometry padding;

  const TokenIconWidget({
    super.key,
    this.imageUrl,
    this.imageProvider,
    this.width = 100,
    this.height = 100,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.borderColor = Colors.grey,
    this.borderWidth = 2.0,
    this.iconColor,
    this.placeholder,
    this.errorWidget,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: borderColor,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: Padding(
          padding: padding,
          child: imageUrl != null
              ? ColorFiltered(
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(
                          iconColor!,
                          BlendMode.srcIn,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.srcOver,
                        ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return placeholder ??
                          Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return errorWidget ??
                          Icon(
                            Icons.token,
                            size: width * 0.6,
                            color: iconColor ?? Colors.grey,
                          );
                    },
                  ),
                )
              : imageProvider != null
                  ? ColorFiltered(
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(
                              iconColor!,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.srcOver,
                            ),
                      child: Image(
                        image: imageProvider!,
                        fit: BoxFit.cover,
                        width: width,
                        height: height,
                        errorBuilder: (context, error, stackTrace) {
                          return errorWidget ??
                              Icon(
                                Icons.token,
                                size: width * 0.6,
                                color: iconColor ?? Colors.grey,
                              );
                        },
                      ),
                    )
                  : errorWidget ??
                      Icon(
                        Icons.token,
                        size: width * 0.6,
                        color: iconColor ?? Colors.grey,
                      ),
        ),
      ),
    );
  }
}