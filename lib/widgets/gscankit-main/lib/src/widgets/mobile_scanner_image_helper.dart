import 'dart:io';
import 'package:image/image.dart' as img;

class MobileScannerImageHelper {
  /// Crop trung tâm + zoom
  static Future<File> cropAndZoom(
    File file, {
    double cropRatio = 0.7,
    int zoom = 2,
  }) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final cropW = (image.width * cropRatio).toInt();
    final cropH = (image.height * cropRatio).toInt();

    final cropX = (image.width - cropW) ~/ 2;
    final cropY = (image.height - cropH) ~/ 2;

    final cropped = img.copyCrop(
      image,
      x: cropX,
      y: cropY,
      width: cropW,
      height: cropH,
    );

    final resized = img.copyResize(
      cropped,
      width: cropped.width * zoom,
      height: cropped.height * zoom,
      interpolation: img.Interpolation.cubic,
    );

    final outFile = File('${file.path}_zoom.jpg');
    await outFile.writeAsBytes(img.encodeJpg(resized, quality: 100));

    return outFile;
  }
}
