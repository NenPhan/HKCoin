import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class QRCodeWidget extends StatefulWidget {
  final String data;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? fileName; // Tùy chọn tên file

  const QRCodeWidget({
    Key? key,
    required this.data,
    this.size = 200,
    this.backgroundColor,
    this.foregroundColor,
    this.fileName,
  }) : super(key: key);

  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // QR Code
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: QrImageView(
              data: widget.data,
              version: QrVersions.auto,
              size: widget.size,
              gapless: true,
              backgroundColor: widget.backgroundColor ?? Colors.white,
              foregroundColor: widget.foregroundColor ?? Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Nút hành động
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút chia sẻ
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Chia sẻ'),
              onPressed: _shareQRCode,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),

            const SizedBox(width: 16),

            // Nút lưu
            ElevatedButton.icon(
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Lưu'),
              onPressed: _isSaving ? null : _saveQRCodeWithShare,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _shareQRCode() async {
    try {
      final imageBytes = await _captureQrImage();
      await _shareImage(imageBytes, isShare: true);
    } catch (e) {
      _showError('Lỗi khi chia sẻ: ${e.toString()}');
    }
  }

  Future<void> _saveQRCodeWithShare() async {
    setState(() => _isSaving = true);
    
    try {
      final imageBytes = await _captureQrImage();
      await _shareImage(imageBytes, isShare: false);
    } catch (e) {
      _showError('Lỗi khi lưu: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<Uint8List> _captureQrImage() async {
    final boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _shareImage(Uint8List imageBytes, {bool isShare = true}) async {
    // Tạo file tạm
    final tempDir = await getTemporaryDirectory();
    final fileName = widget.fileName ?? 'qrcode_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(imageBytes);

    // Chia sẻ hoặc lưu
    if (isShare) {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'QR Code: ${widget.data}',
        subject: 'Chia sẻ QR Code',
      );
    } else {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Lưu QR Code này vào thiết bị của bạn',
        subject: 'Lưu QR Code',
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}