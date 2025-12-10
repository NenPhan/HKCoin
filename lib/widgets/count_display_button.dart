import 'dart:developer';

import 'package:flutter/material.dart';

class CountDisplay extends StatefulWidget {
  const CountDisplay({
    super.key,
    this.icon,
    required this.onTap,
    this.count = 0,
    this.countColor = Colors.amber,
    this.countTextColor = Colors.white,
    this.hideIcon = false, // Thêm tuỳ chọn ẩn icon
    this.badgePosition, // Tuỳ chỉnh vị trí badge
  });

  final Icon? icon;
  final VoidCallback onTap;
  final int count;
  final Color countColor;
  final Color countTextColor;
  final bool hideIcon;
  final Offset? badgePosition;
   @override
  State<CountDisplay> createState() => _CountDisplayState();
}
class _CountDisplayState extends State<CountDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.hideIcon ? null : 48, // Kích thước mặc định khi có icon
        height: widget.hideIcon ? null : 48,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Chỉ hiển thị icon nếu không bị ẩn và có icon
            if (!widget.hideIcon && widget.icon != null)
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: widget.onTap,
                icon: widget.icon!,
              ),
            // Hiển thị count badge nếu count > 0
            if (widget.count > 0)
              Positioned(
                right: widget.badgePosition?.dx ?? 0,
                top: widget.badgePosition?.dy ?? 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.countColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      widget.count > 99 ? '99+' : widget.count.toString(),
                      style: TextStyle(
                        color: widget.countTextColor,
                        fontSize: widget.count > 99 ? 8 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}