import 'dart:io';
import 'package:image/image.dart' as img;

class QrImageProcessor {
  static Future<File> process(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    img.Image processed = image;

    // 1️⃣ Grayscale (bắt buộc)
    processed = img.grayscale(processed);

    // 2️⃣ Tăng contrast
    processed = img.adjustColor(processed, contrast: 1.6, brightness: 0.05);

    // 3️⃣ Blur nhẹ để giảm nhiễu (RẤT QUAN TRỌNG)
    processed = img.gaussianBlur(processed, radius: 1);

    // 4️⃣ Sharpen bằng convolution (KHÔNG div/offset)
    processed = img.convolution(
      processed,
      filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
      div: 1,
      offset: 0,
      amount: 1,
    );

    // 5️⃣ Threshold nhẹ (tuỳ ảnh)
    processed = _softThreshold(processed);

    final out = File('${file.path}_qr.jpg');
    await out.writeAsBytes(img.encodeJpg(processed, quality: 100));

    return out;
  }

  static img.Image _softThreshold(img.Image src) {
    final out = img.Image.from(src);

    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final p = src.getPixel(x, y);
        final l = img.getLuminance(p);
        final v = l > 130 ? 255 : 0;
        out.setPixelRgb(x, y, v, v, v);
      }
    }
    return out;
  }
}
