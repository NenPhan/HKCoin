import 'package:flutter/material.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.onTap,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.size = 24,
    this.borderColor,
    this.borderWidth = 0,
    this.showZero = false,
    this.padding = const EdgeInsets.only(left: 5),
  });

  final int count;
  final int maxCount; // Maximum number to show before adding "+"
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final bool showZero;
  final EdgeInsets padding; // Tham số padding mới

  @override
  Widget build(BuildContext context) {
    final shouldShow = count > 0 || showZero;
    if (!shouldShow) return const SizedBox.shrink();

    // Format the count display
    final displayText = count > maxCount ? '$maxCount+' : count.toString();
    final fontSize = count > maxCount ? size * 0.4 : size * 0.5;
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          constraints: BoxConstraints(
            minWidth: size,
            minHeight: size,
          ),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: borderWidth,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              displayText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );    
  }
}