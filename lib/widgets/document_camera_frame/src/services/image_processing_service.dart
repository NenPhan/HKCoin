import 'dart:io';

import 'package:hkcoin/core/config/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageProcessingService {
  String cropImageToFrame(
    String filePath,
    double frameWidth,
    double frameHeight,
    BuildContext context,
  ) {
    final File imageFile = File(filePath);
    final img.Image originalImage =
        img.decodeImage(imageFile.readAsBytesSync())!;

    final int screenWidth = scrSize(context).width.toInt();
    final int screenHeight = scrSize(context).height.toInt();

    final int cropWidth = originalImage.width * frameWidth ~/ screenWidth;
    final int cropHeight = originalImage.height * frameHeight ~/ screenHeight;

    final int cropX = (originalImage.width - cropWidth) ~/ 2;
    final int cropY = (originalImage.height - cropHeight) ~/ 2;

    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    final String croppedFilePath = filePath.replaceAll('.jpg', '_cropped.jpg');
    File(croppedFilePath).writeAsBytesSync(img.encodeJpg(croppedImage));

    return croppedFilePath;
  }
}
