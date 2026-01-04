import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class ImageCropperHelper {
  static Future<File?> crop(File file) async {
    final result = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cắt vùng QR',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cắt vùng QR'),
      ],
    );

    if (result == null) return null;
    return File(result.path);
  }
}
