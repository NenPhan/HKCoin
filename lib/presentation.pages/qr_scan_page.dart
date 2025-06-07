import 'package:flutter/material.dart';
import 'package:hkcoin/presentation.controllers/qr_scan_controller.dart';
import 'package:hkcoin/widgets/qr_scan_widget.dart';


class QRScanPage extends StatelessWidget {
  final Function(String)? onScanResult;
   final bool showDialogOnScan;
  const QRScanPage({Key? key, this.onScanResult,this.showDialogOnScan = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = QRScannerController(showDialogOnScan: showDialogOnScan);
    return QRScannerWidget(
      controller: controller,
      onScanResult: (result) {
        // Gọi callback để xử lý kết quả
        if (onScanResult != null) {
          onScanResult!(result);
          controller.handleScannedResult(context, result);
        } else {
          // Hiển thị SnackBar mặc định nếu không có callback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR Code Result: $result')),
          );
        }
      },
    );
  }
}