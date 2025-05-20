import 'package:flutter/material.dart';

class CountDisplay extends StatefulWidget {
  const CountDisplay({
    super.key,
    required this.icon,
    required this.onTap,
    this.count = 0, // Thêm tham số count
    this.countColor = Colors.red, // Màu của count badge
    this.countTextColor = Colors.white, // Màu chữ count
  });
  
  final Icon icon;
  final VoidCallback onTap;
  final int count; // Số lượng để hiển thị
  final Color countColor; // Màu nền badge
  final Color countTextColor; // Màu chữ badge

  @override
  State<CountDisplay> createState() => _CountDisplayState();
}

class _CountDisplayState extends State<CountDisplay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Cho phép badge vượt ra ngoài
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            widget.onTap.call();
          },
          icon: widget.icon,
        ),
        // Hiển thị count badge nếu count > 0
        if (widget.count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: widget.countColor,
                shape: BoxShape.circle,
                // Hoặc có thể dùng borderRadius cho hình chữ nhật bo tròn
                // borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  widget.count > 100 ? '99+' : widget.count.toString(),
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
    );
  }
}