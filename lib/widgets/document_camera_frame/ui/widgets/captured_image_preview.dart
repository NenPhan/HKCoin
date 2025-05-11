import 'dart:io';

import 'package:flutter/material.dart';

class CapturedImagePreview extends StatelessWidget {
  final ValueNotifier<String> capturedImageNotifier;
  final double frameWidth;
  final double frameHeight;

  final double borderRadius;
  const CapturedImagePreview({
    super.key,
    required this.capturedImageNotifier,
    required this.frameWidth,
    required this.frameHeight,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: capturedImageNotifier,
      builder: (context, imagePath, child) {
        if (imagePath.isEmpty) {
          return const SizedBox.shrink();
        }
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: frameWidth,
            height: frameHeight,
            child: Stack(
              children: [
                Positioned(
                  top: 3,
                  left: 3,
                  right: 3,
                  child: Container(
                    width: frameWidth,
                    height: frameHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
