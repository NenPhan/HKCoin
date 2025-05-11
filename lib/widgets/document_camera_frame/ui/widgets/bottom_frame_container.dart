import 'package:hkcoin/core/config/app_theme.dart';

import 'package:flutter/material.dart';

class BottomFrameContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget? bottomFrameContainerChild;

  const BottomFrameContainer({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.bottomFrameContainerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: scrSize(context).height * 0.5 + (height / 2),
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: width,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              right: BorderSide(
                color: Colors.white,
                width: 3,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              left: BorderSide(
                color: Colors.white,
                width: 3,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              top: BorderSide(
                color: Colors.white,
                width: 3,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              bottom: BorderSide(
                color: Colors.white,
                width: 3,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
          ),
          child:
              bottomFrameContainerChild ??
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.credit_card_outlined, // Icon representing the ID
                    color: Colors.black54,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Your ID',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
