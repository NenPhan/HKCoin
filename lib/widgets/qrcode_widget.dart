import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class QRCodeWidget extends StatefulWidget {
  final String data;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? fileName;
  final String? logoPath;
  final Widget? logoWidget;
  final bool showShare;
  final bool showSaveStore;

  const QRCodeWidget({
    Key? key,
    required this.data,
    this.size = 200,
    this.backgroundColor,
    this.foregroundColor,
    this.fileName,
    this.logoPath,
    this.logoWidget,
    this.showShare = true,
    this.showSaveStore = true,
  }) : super(key: key);

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: widget.data,
                  version: QrVersions.auto,
                  size: widget.size,
                  gapless: true,
                  backgroundColor: widget.backgroundColor ?? Colors.white,
                  foregroundColor: widget.foregroundColor ?? Colors.black,
                  embeddedImage:
                      widget.logoPath != null
                          ? NetworkImage(
                            widget.logoPath!,
                          ) // Sử dụng logo từ assets
                          : null,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(
                      widget.size * 0.25,
                      widget.size * 0.25,
                    ), // Kích thước logo (25% kích thước QR)
                  ),
                ),
                if (widget.logoWidget != null || widget.logoPath != null)
                  Container(
                    width: widget.size * 0.2,
                    height: widget.size * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        widget.logoWidget ??
                        (widget.logoPath != null
                            ? Image.network(
                              widget.logoPath!,
                              fit: BoxFit.contain,
                            )
                            : null),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showShare)
              _buildActionButton(
                icon: Icons.share,
                label: context.tr("Common.Share"),
                color: Colors.blue,
                onPressed: _shareQRCode,
              ),
            const SizedBox(width: 16),
            if (widget.showSaveStore)
              _buildActionButton(
                icon: Icons.save,
                label: context.tr("Admin.Common.Save"),
                color: Colors.green,
                onPressed: _isSaving ? null : _showSaveConfirmationDialog,
                isLoading: _isSaving,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return ElevatedButton.icon(
      icon:
          isLoading
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
      ),
    );
  }

  Future<void> _showSaveConfirmationDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('Common.Approve')),
            content: Text(context.tr("Common.QRCode.Question")),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.tr("Common.Cancel")),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.tr("Common.Apply")),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _saveQRCodeWithShare();
    }
  }

  Future<void> _shareQRCode() async {
    try {
      final imageBytes = await _captureQrImage();
      await _shareImage(imageBytes);
    } catch (e) {
      _showSnackBar('Lỗi khi chia sẻ: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _saveQRCodeWithShare() async {
    setState(() => _isSaving = true);
    try {
      if (!(await _requestStoragePermission())) {
        _showSnackBar(
          Get.context?.tr("Common.QRCode.Storage.Denied") ?? "",
          Colors.red,
        );
        return;
      }

      final imageBytes = await _captureQrImage();
      final success = await _saveImageToGallery(imageBytes);
      _showSnackBar(
        success
            ? Get.context?.tr("Common.QRCode.Storage.Success") ?? ""
            : Get.context?.tr("Common.QRCode.Storage.Failed") ?? "",
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // final statuses = await [Permission.storage, Permission.].request();
      // return statuses[Permission.storage]!.isGranted;
      return true;
    } else if (Platform.isIOS) {
      return (await Permission.photos.request()).isGranted;
    }
    return false;
  }

  Future<Uint8List> _captureQrImage() async {
    final boundary =
        _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _shareImage(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final fileName =
        widget.fileName ??
        'qrcode_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${tempDir.path}/$fileName')
      ..writeAsBytesSync(imageBytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'QR Code: ${widget.data}',
        subject: context.tr("Common.QRCode.Storage.Shared"),
      ),
    );
  }

  Future<bool> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      if (Platform.isIOS) {
        if (await Permission.photos.isGranted) {
          await FlutterImageGallerySaver.saveImage(imageBytes);
          return true;
        } else {
          return false;
        }
      } else {
        await FlutterImageGallerySaver.saveImage(imageBytes);
        return true;
      }
    } catch (e) {
      debugPrint('Lỗi khi lưu ảnh: $e');
      return false;
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
