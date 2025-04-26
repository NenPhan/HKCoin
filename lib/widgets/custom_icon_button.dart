import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.noticeBadge = false,
  });
  final Icon icon;
  final VoidCallback onTap;
  final bool noticeBadge;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            widget.onTap.call();
          },
          icon: widget.icon,
        ),
        if (widget.noticeBadge)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
