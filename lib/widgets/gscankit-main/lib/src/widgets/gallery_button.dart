import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/widgets/gscankit-main/lib/qr_result_handler.dart';
import 'package:hkcoin/widgets/gscankit-main/lib/src/painters/image_enhancer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_scanner/mobile_scanner.dart';

enum GalleryButtonType { none, icon, filled }

/// Button chọn ảnh từ gallery → crop tay → scan QR bằng mobile_scanner
class GalleryButton extends StatefulWidget {
  final void Function(String?)? onImagePick;
  final void Function(BarcodeCapture)? onDetect;
  final ScanResultHandler? scanResultHandler;
  final bool Function(BarcodeCapture)? validator;
  final MobileScannerController controller;
  final ValueNotifier<bool?> isSuccess;
  final String text;
  final Icon? icon;
  final Widget? child;

  const GalleryButton({
    super.key,
    this.onImagePick,
    this.onDetect,
    this.scanResultHandler,
    this.validator,
    required this.controller,
    required this.isSuccess,
    this.text = 'Upload from gallery',
    this.icon,
    this.child,
  });

  @override
  State<GalleryButton> createState() => _GalleryButtonState();
}

class _GalleryButtonState extends State<GalleryButton> {
  final ValueNotifier<bool> _isAnalyzing = ValueNotifier(false);

  // ================= IMAGE PICK → CROP → SCAN =================

  Future<void> _pickAndAnalyzeImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (picked == null) return;
    widget.onImagePick?.call(picked.path);

    File file = File(picked.path);

    _isAnalyzing.value = true;

    try {
      // 1️⃣ Scan ảnh gốc (có timeout)
      final result1 = await _scanWithTimeout(file.path);
      if (_handleCapture(result1)) return;

      // 2️⃣ Fail → tắt overlay + hỏi crop
      _isAnalyzing.value = false;

      final wantCrop = await _askCropConfirm();
      if (!wantCrop) return;

      final cropped = await _cropImage(file);
      if (cropped == null) return;

      _isAnalyzing.value = true;

      // 3️⃣ Scan ảnh crop (có timeout)
      final result2 = await _scanWithTimeout(cropped.path);
      if (_handleCapture(result2)) return;
      _isAnalyzing.value = true;
      final enhanced = await QrImageProcessor.process(cropped);
      final result3 = await _scanWithTimeout(enhanced.path);
      if (_handleCapture(result3)) return;
      // ❌ Fail hoàn toàn
      _showScanFailedToast();
    } finally {
      // 🔥 LUÔN LUÔN reset overlay
      _isAnalyzing.value = false;
      HapticFeedback.heavyImpact();
    }
  }

  // ================= HANDLE RESULT =================

  bool _handleCapture(BarcodeCapture? capture) {
    if (capture == null || capture.barcodes.isEmpty) return false;

    final isValid = widget.validator?.call(capture) ?? true;
    widget.isSuccess.value = isValid;

    if (!isValid) {
      HapticFeedback.heavyImpact();
      return true;
    }

    final raw = capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return false;

    if (widget.scanResultHandler != null) {
      widget.scanResultHandler!.handle(context, raw);
    } else {
      widget.onDetect?.call(capture);
    }

    HapticFeedback.mediumImpact();
    return true;
  }

  // ================= IMAGE CROP =================

  Future<File?> _cropImage(File file) async {
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

  // ================= CROP + ZOOM =================

  Future<File> _cropAndZoom(File file, {int zoom = 2}) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final cropW = (image.width * 0.7).toInt();
    final cropH = (image.height * 0.7).toInt();

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

  Future<BarcodeCapture?> _scanWithTimeout(String path) async {
    try {
      return await widget.controller
          .analyzeImage(path)
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      return null;
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child != null
            ? GestureDetector(onTap: _pickAndAnalyzeImage, child: widget.child)
            : IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: CupertinoColors.systemGrey6,
                foregroundColor: CupertinoColors.darkBackgroundGray,
              ),
              icon: widget.icon ?? const Icon(CupertinoIcons.photo),
              onPressed: _pickAndAnalyzeImage,
            ),

        // 🔥 Loading overlay
        ValueListenableBuilder<bool>(
          valueListenable: _isAnalyzing,
          builder: (_, loading, __) {
            if (!loading) return const SizedBox.shrink();
            return Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.55),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 14),
                      Text(
                        'Đang phân tích ảnh…',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<bool> _askCropConfirm() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Không nhận diện được QR'),
        content: const Text(
          'Ảnh có thể chứa QR nhỏ hoặc mờ.\n'
          'Bạn có muốn cắt vùng QR để quét lại không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Cắt ảnh'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  void _showScanFailedToast() {
    Get.snackbar(
      'Không thể quét QR',
      'Ảnh quá mờ hoặc QR quá nhỏ.\nHãy thử ảnh khác hoặc quét bằng camera.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
